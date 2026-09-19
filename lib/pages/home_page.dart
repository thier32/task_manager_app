import 'package:flutter/material.dart';
import 'package:task_manager_app/models/tache.dart';
import 'package:task_manager_app/pages/login_page.dart';
import 'package:task_manager_app/services/api_service.dart';
import 'package:task_manager_app/services/api_tache_service.dart';
import 'package:task_manager_app/widgets/tache_form.dart';
import 'package:task_manager_app/widgets/tache_grid.dart';

class PageAccueilTaches extends StatefulWidget {
  const PageAccueilTaches({super.key});

  @override
  State<PageAccueilTaches> createState() => _PageAccueilTachesState();
}

class _PageAccueilTachesState extends State<PageAccueilTaches> {
  final List<Tache> _taches = [];
  String _filtreTexte = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerTaches();
  }

  Future<void> _chargerTaches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tachesServeur = await ApiTacheService.getTaches();
      setState(() {
        _taches.clear();
        _taches.addAll(tachesServeur);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Tache> get _tachesFiltrees {
    if (_filtreTexte.isEmpty) {
      return _taches;
    }
    return _taches.where((tache) {
      return tache.title.toLowerCase().contains(_filtreTexte.toLowerCase()) ||
             tache.description.toLowerCase().contains(_filtreTexte.toLowerCase());
    }).toList();
  }

  void _onDeconnexion(){
      ApiService.clearToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );              
  }

  Future<void> _soumettreTache(Tache tache, {int? index}) async {
    setState(() {
      _isLoading = true;
    });
  
    try {
      if (index == null) {
         await ApiTacheService.enregistrerTache(tache);
      } else {
         await ApiTacheService.enregistrerTache(tache);
      }
      await _chargerTaches();
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement : ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _supprimerTache(int index) {
    setState(() {
      _taches.removeAt(index);
    });
  }



  void _confirmerSuppression(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer cette tâche ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _supprimerTache(index);
                Navigator.pop(context);
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _ouvrirModalFormulaire(BuildContext context, {int? index, Tache? tache}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TacheForm(
                tache: tache,
                onTacheSoumise: (tacheForm) {
                  _soumettreTache(tacheForm, index: index);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // On filtre aussi pour l'onglet des tâches terminées
    final tachesTerminees = _tachesFiltrees.where((t) => t.status == 'Urgent' || t.terminee).toList(); // Ajustez selon votre logique de statut

    return DefaultTabController(
      length: 2, // 2 onglets correspondants à la TabBar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mon Gestionnaire de Tâches'),
          backgroundColor: Colors.blue.shade100,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black54),
              tooltip: 'Se déconnecter',
              onPressed: _onDeconnexion
            ),
          ],
        ),
        body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Affiche le loader pendant le chargement
            ) : Column(
          children: [
            // Barre de recherche fixe en haut pour toutes les vues
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Rechercher une tâche...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                onChanged: (valeur) {
                  setState(() {
                    _filtreTexte = valeur;
                  });
                },
              ),
            ),
            // Vues des onglets
            Expanded(
              child: TabBarView(
                children: [
                  // Onglet 1 : Toutes les tâches filtrées
                  TacheGrid(
                    taches: _tachesFiltrees,
                    onCheckboxChanged: (index, valeur) {
                      setState(() {
                        _tachesFiltrees[index].terminee = valeur ?? false;
                      });
                    },
                    onDeletePressed: (index) {
                      final tacheReelle = _tachesFiltrees[index];
                      final indexReel = _taches.indexOf(tacheReelle);
                      _confirmerSuppression(context, indexReel);
                    },
                    onEditPressed: (index) {
                      final tacheReelle = _tachesFiltrees[index];
                      final indexReel = _taches.indexOf(tacheReelle);
                      _ouvrirModalFormulaire(context, index: indexReel, tache: tacheReelle);
                    },
                  ),
                  // Onglet 2 : Tâches terminées
                  TacheGrid(
                    taches: tachesTerminees,
                    onCheckboxChanged: (index, valeur) {
                      setState(() {
                        tachesTerminees[index].terminee = valeur ?? false;
                      });
                    },
                    onDeletePressed: (index) {
                      final tacheReelle = tachesTerminees[index];
                      final indexReel = _taches.indexOf(tacheReelle);
                      _confirmerSuppression(context, indexReel);
                    },
                    onEditPressed: (index) {
                      final tacheReelle = tachesTerminees[index];
                      final indexReel = _taches.indexOf(tacheReelle);
                      _ouvrirModalFormulaire(context, index: indexReel, tache: tacheReelle);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _ouvrirModalFormulaire(context),
          icon: const Icon(Icons.add),
          label: const Text('Nouvelle tâche'),
          backgroundColor: Colors.blue.shade200,
        ),
        bottomNavigationBar: Container(
          color: Colors.blue.shade50,
          child: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Toutes les tâches'),
              Tab(icon: Icon(Icons.check_circle), text: 'Terminées'),
            ],
          ),
        ),
      ),
    );
  }
}