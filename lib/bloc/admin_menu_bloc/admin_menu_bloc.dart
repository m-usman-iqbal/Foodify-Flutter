import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/admin_menu_repository.dart';
import 'admin_menu_event.dart';
import 'admin_menu_state.dart';

class AdminMenuBloc extends Bloc<AdminMenuEvent, AdminMenuState> {
  final AdminMenuRepository repository;

  AdminMenuBloc({required this.repository}) : super(AdminMenuInitial()) {
    on<CheckMenuEvent>((event, emit) async {
      emit(AdminMenuLoading());
      try {
        final menuItems = await repository.getMenu(); // fetch items
        if (menuItems.isEmpty) {
          emit(AdminMenuEmpty());
        } else {
          emit(AdminMenuHasMenu(menuItems: menuItems)); // pass items to state
        }
      } catch (e) {
        emit(AdminMenuError(message: e.toString()));
      }
    });
  }
}
