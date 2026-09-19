import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/models/tache.dart';
import 'package:task_manager_app/services/api_service.dart';

class ApiTacheService {
  // Remplacez par l'URL de votre backend (ex: 'http://localhost:3000/taches')
  // Note : Sur un emulateur Android, 'http://10.0.2.2:3000' pointe vers le localhost de votre PC.
 // static const String baseUrl = 'http://localhost:6001//taches'; 

  // GET : Récupérer toutes les tâches
  static Future<List<Tache>> getTaches() async {
    final response = await ApiService.get("/api/tasks");
    if (int.tryParse(response['code'].toString()) == 200) {
      final rows = response['result']['rows'];      
      debugPrint(rows.toString());

      return (rows as List).map((json) => Tache().fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Erreur lors du chargement des tâches');
    }
  }

  static Future<List<Tache>> getTachesStatus() async {
    final response = await ApiService.get("/api/tasks/status");
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body?.data?.result?.rows);
      return data.map((json) => Tache().fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des tâches');
    }
  }

  // POST : Ajouter une tâche
  static Future<Tache> enregistrerTache(Tache tache) async {
   final response = await ApiService.post('/api/tasks', bodyData: tache.toJson());
   if (int.tryParse(response['code'].toString()) == 200) {
      // Décode le JSON reçu en Map
      final result = response['result'];
      // Instancie dynamiquement le type T (ex: User ou Tache)
      return Tache().fromJson(result);
    } else {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${response.body}');
    }
  }

    // POST : Ajouter une tâche
  static Future<Tache> miseajourTache(Tache tache) async {
   final response = await ApiService.put('/api/tasks/${tache.taskId}', bodyData: tache.toJson());
   if (int.tryParse(response['code'].toString()) == 200) {
      final result = response['result'];
      return Tache().fromJson(result);
    } else {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${response.body}');
    }
  }


  // DELETE : Supprimer une tâche
  /*static Future<void> supprimerTache(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }*/
}