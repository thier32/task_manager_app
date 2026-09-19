import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class UserRegisterDto extends BaseModel<UserRegisterDto> {
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  String? name;

  UserRegisterDto({
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
    this.name,
  });
}