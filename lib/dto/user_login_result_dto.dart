import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class UserLoginResultDto extends BaseModel<UserLoginResultDto> {
  String? username;
  String? email;
  List<dynamic>? roles;
  String? bearer;

  UserLoginResultDto({
    this.username,
    this.email,
    this.roles,
    this.bearer,
  });
}