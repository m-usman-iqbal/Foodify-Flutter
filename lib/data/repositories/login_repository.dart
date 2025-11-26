import 'package:burger/data/services/login_servies.dart';

abstract class LoginRepository {
  Future<void> login({required String email, required String password});
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginService _service;

  LoginRepositoryImpl(this._service);

  @override
  Future<void> login({required String email, required String password}) async {
    await _service.signIn(email: email, password: password);
  }
}
