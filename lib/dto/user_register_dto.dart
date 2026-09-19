import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class UserRegisterDto extends BaseModel<UserRegisterDto> {
  String username;
  String email;
  String password;
  String confirmPassword;

  UserRegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}