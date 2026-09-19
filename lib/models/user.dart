import 'package:task_manager_app/models/base_model.dart';
import 'package:task_manager_app/utils/reflector.dart';

@reflector
class User extends BaseModel<User> {
  int? userId;
  String? username;
  String? email;
  String? confirmPassword;
  String? password;
  String? token;

  User({
    this.userId,
    this.username,
    this.email,
    this.password,
    this.confirmPassword,
    this.token,
  });
}