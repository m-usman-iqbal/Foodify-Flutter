abstract class AdminMenuState {}

class AdminMenuInitial extends AdminMenuState {}

class AdminMenuLoading extends AdminMenuState {}

class AdminMenuHasMenu extends AdminMenuState {
  final List<Map<String, dynamic>> menuItems;

  AdminMenuHasMenu({required this.menuItems});
}

class AdminMenuEmpty extends AdminMenuState {}

class AdminMenuError extends AdminMenuState {
  final String message;
  AdminMenuError({required this.message});
}
