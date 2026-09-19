import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class Tache extends BaseModel<Tache> {
  int? taskId;
  String title;
  String description;
  String status;
  String createdAt;
  String updatedAt;
  bool terminee;

  Tache({
    this.taskId,
    this.title = '',
    this.description = '',
    this.status = '',    
    this.createdAt = '',
    this.updatedAt = '',
    this.terminee = false,
  });
}