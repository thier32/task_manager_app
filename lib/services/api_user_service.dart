import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/dto/user_login_result_dto.dart';
import 'package:task_manager_app/dto/user_register_dto.dart';
import 'package:task_manager_app/models/tache.dart';
import 'package:task_manager_app/models/user.dart';
import 'package:task_manager_app/dto/user_login_dto.dart';
import 'package:task_manager_app/services/api_service.dart';

class ApiUserService {

  static Future<UserRegisterDto> enregistrerUtilisateur(UserRegisterDto user) async {
   final response = await ApiService.post('/auth/register', bodyData: user.toJson());
   if (int.tryParse(response['code'].toString()) == 200) {
      // Décode le JSON reçu en Map
      final Map<String, dynamic> data = json.decode(response.body);
      // Instancie dynamiquement le type T (ex: User ou Tache)
      return UserRegisterDto().fromJson(data);
    } else {
      throw Exception('Erreur HTTP (${response.statusCode}) : ${response.body}');
    }
  }


  static Future<UserLoginResultDto> authUtilisateur(UserLoginDto user) async {
   final response = await ApiService.post('auth/login', bodyData:  user.toJson());
   
   if (int.tryParse(response['code'].toString()) == 200) {
      // Décode le JSON reçu en Map
      //final Map<String, dynamic> data = json.decode(response.body);
      // Instancie dynamiquement le type T (ex: User ou Tache)
      UserLoginResultDto user = UserLoginResultDto().fromJson(response['result']); 
      ApiService.setToken(user.bearer); // On sauvegarde le token globalement
      //debugPrint("User ${user.bearer}");
      return user;
    } else {
      throw Exception('Erreur HTTP (${response['code']}) : ${response['result']}');
    }
  }

  // DELETE : Supprimer une tâche
  /*static Future<void> supprimerTache(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }*/
}