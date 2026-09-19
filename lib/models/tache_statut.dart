import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class TacheStatut extends BaseModel<TacheStatut> {
  
  String? value;
  String? name;

  TacheStatut({
    this.value = '',
    this.name = '',
  });
}