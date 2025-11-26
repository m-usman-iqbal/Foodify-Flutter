import 'package:burger/data/services/signup_services.dart';

class SignupRepository {
  final SignupService service;

  SignupRepository({required this.service});

  Future<void> signup({
    required String email,
    required String password,
    required String username,
    required String address,
    required String imagePath,
  }) async {
    return service.signup(
      email: email,
      password: password,
      username: username,
      address: address,
      imagePath: imagePath,
    );
  }
}
