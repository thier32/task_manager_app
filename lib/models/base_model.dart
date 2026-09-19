import 'package:task_manager_app/utils/reflection_utils.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
abstract class BaseModel<T> {
  const BaseModel();

  Map<String, dynamic> toJson() {
    return ToJson(this);
  }

  T fromJson(Map<String, dynamic> json){
    return FromJson(json);
  }
}