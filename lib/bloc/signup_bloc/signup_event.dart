import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;
  final String username;
  final String address;
  final String imagePath;

  const SignupButtonPressed({
    required this.email,
    required this.password,
    required this.username,
    required this.address,
    required this.imagePath,
  });

  @override
  List<Object> get props => [email, password, username, address, imagePath];
}
