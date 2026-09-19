import 'package:flutter/material.dart';
import 'package:task_manager_app/models/tache.dart';

class TacheForm extends StatefulWidget {

  final Function(Tache) onTacheSoumise; 
  final Tache? tache;

  const TacheForm({super.key, required this.onTacheSoumise,
  this.tache});


  @override
  State<TacheForm> createState() => _TacheFormState();
}

class _TacheFormState extends State<TacheForm> {
  // Les contrôleurs vivent maintenant ici, au plus près du formulaire
  late TextEditingController _titreController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  late String _categorieSelectionnee = 'Personnel';
  final List<String> _categories = ['Personnel', 'Travail', 'Urgent', 'Autre'];

  void _soumettre() {
    if (_titreController.text.trim().isEmpty) return;
    
    Tache tacheResultat = Tache(
      taskId: widget.tache?.taskId,
      title: _titreController.text,
      description: _descriptionController.text,
      status: _categorieSelectionnee,
    );

    print(tacheResultat);
    
    // On remonte les données à la page parente via le callback
    widget.onTacheSoumise(tacheResultat);
    
    // On nettoie les champs en interne
    _titreController.clear();
    _descriptionController.clear();
  }

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.tache?.title ?? '');
    _descriptionController = TextEditingController(text: widget.tache?.description ?? '');
    
    if (widget.tache != null && _categories.contains(widget.tache!.status)) {
      _categorieSelectionnee = widget.tache!.status;
    } else {
      _categorieSelectionnee = _categories.first;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool estModeEdition = widget.tache != null;
   
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            estModeEdition ? 'Modifier la tâche' : 'Créer une nouvelle tâche',
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
          TextField(
            controller: _titreController,
            decoration: const InputDecoration(
              labelText: 'Titre de la tâche...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description (optionnelle)...',
              border: OutlineInputBorder(),
            ),
          ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: _categorieSelectionnee,
          decoration: const InputDecoration(
            labelText: 'Statut',
            border: OutlineInputBorder(),
          ),
          items: _categories.map((String categorie) {
            return DropdownMenuItem<String>(
              value: categorie,
              child: Text(categorie),
            );
          }).toList(),
          onChanged: (String? nouvelleValeur) {
            setState(() {
              _categorieSelectionnee = nouvelleValeur!;
            });
          },
        ),
        const SizedBox(height: 15),
          Row(
          children: [
            // Bouton Annuler
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme la modale sans ajouter
                },
                child: const Text('Annuler'),
              ),
            ),
            const SizedBox(width: 10), // Espace entre les deux boutons
            // Bouton Ajouter
            Expanded(
              child: ElevatedButton(
                onPressed: _soumettre,
                child:  Text( estModeEdition ?   'Modifier':'Ajouter'),
              ),
            ),
          ],
        ),
      ],
      ),
    );
  }
}