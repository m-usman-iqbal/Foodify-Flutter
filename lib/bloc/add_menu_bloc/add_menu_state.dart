abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuSuccess extends MenuState {}

class MenuError extends MenuState {
  final String message;
  MenuError({required this.message});
}
