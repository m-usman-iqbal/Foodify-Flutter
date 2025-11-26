import 'package:bloc/bloc.dart';
import 'package:burger/data/repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        await repository.login(email: event.email, password: event.password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(message: e.toString()));
      }
    });
  }
}
