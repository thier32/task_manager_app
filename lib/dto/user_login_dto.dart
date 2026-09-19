import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class UserLoginDto extends BaseModel<UserLoginDto> {
  String username;
  String password;

  UserLoginDto({
    required this.username,
    required this.password,
  });
}