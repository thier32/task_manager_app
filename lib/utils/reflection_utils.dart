// --- 1. TO JSON UNIVERSEL ---
import 'package:reflectable/reflectable.dart';
import 'package:task_manager_app/utils/reflector.dart';

Map<String, dynamic> ToJson(dynamic object) {
 final instanceMirror = reflector.reflect(object);
 final classMirror = instanceMirror.type;

 Map<String, dynamic> json = {};

 // Parcourt tous les champs de la classe dynamiquement
 for (var variableName in classMirror.declarations.keys) {
  final declaration = classMirror.declarations[variableName];
  // On filtre pour ne garder que les champs (variables)
  if (declaration is VariableMirror && !declaration.isStatic) {
   json[variableName] = instanceMirror.invokeGetter(variableName);
  }
 }
 return json;
}

// --- 2. FROM JSON UNIVERSEL ---
T FromJson<T>(Map<String, dynamic> json) {
 // Récupère le miroir de type de la classe T
 final classMirror = reflector.reflectType(T) as ClassMirror;

 // Prépare une map de paramètres nommés pour le constructeur
 Map<Symbol, dynamic> constructorParams = {};

 json.forEach((key, value) {
  constructorParams[Symbol(key)] = value;
 });
 // Instancie l'objet dynamiquement via son constructeur par défaut
 return classMirror.newInstance('', [], constructorParams) as T;
}
