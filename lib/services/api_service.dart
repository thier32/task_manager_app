import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/models/tache.dart';

class ApiService {
  // Remplacez par l'URL de votre backend (ex: 'http://localhost:3000/taches')
  // Note : Sur un emulateur Android, 'http://10.0.2.2:3000' pointe vers le localhost de votre PC.
  static const String baseUrl = 'http://192.168.1.129:6001'; 

  // Variable statique pour stocker le token de connexion
  static String? _token;

  // Méthode pour enregistrer le token après une connexion réussie
  static void setToken(String? token) {
    _token = token;
  }

  // Méthode pour effacer le token (déconnexion)
  static void clearToken() {
    _token = null;
  }

  

  // En-têtes HTTP communs centralisés
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',   
        if (_token != null && _token!.isNotEmpty)
          'Authorization': 'Bearer $_token',      
  };
  static Uri getUrl(String endpoint){
    final url = Uri.parse('$baseUrl${endpoint.startsWith('/') ? '' : '/'}$endpoint');
    debugPrint('URL: $url');
    return url;
  }

  // --- Méthode POST universelle ---
  static Future<dynamic> post(String endpoint,{dynamic bodyData}) async {
    final url = getUrl(endpoint);
    final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(bodyData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${getMessage(response)}');
    }    

    return getResult(response);
  }

  static dynamic getResult(dynamic response){
   final Map<String, dynamic> decodedData = json.decode(response.body);
    if (response.statusCode == 200) {
      return  decodedData;
    }
    return decodedData;
  }


    // --- Méthode POST universelle ---
  static Future<dynamic> put(String endpoint,{dynamic bodyData}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.put(
      url,
      headers: _headers,
      body: json.encode(bodyData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${getMessage(response)}');
    }
    return response;
  }

  static String getMessage(dynamic response){
    String errorMessage = response.body; 
    final decodedData = json.decode(response.body);
    if (decodedData is Map && decodedData.containsKey('message')) {
      errorMessage = decodedData['message'];
    }
    return errorMessage;
  }

  // --- Méthode GET universelle ---
  static Future<dynamic> get(String endpoint,{dynamic bodyData}) async {
    final url = getUrl(endpoint);

    final response = await http.get(
      url,
      headers: _headers
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${getMessage(response)}');
    }
    return getResult(response);
  }

  // --- Méthode GET universelle ---
  static Future<dynamic> delete(String endpoint,{dynamic bodyData}) async {
    final url = getUrl(endpoint);
    final response = await http.delete(
      url,
      headers: _headers
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${getMessage(response)}');
    }
    return response;
  }


  // POST : Ajouter une tâche
  static Future<void> ajouterTache(Tache tache) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tache.toJson()),
    );
  }

  // DELETE : Supprimer une tâche
  static Future<void> supprimerTache(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}