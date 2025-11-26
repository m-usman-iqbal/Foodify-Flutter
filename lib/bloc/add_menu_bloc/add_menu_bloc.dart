import 'package:burger/bloc/add_menu_bloc/add_menu_event.dart';
import 'package:burger/bloc/add_menu_bloc/add_menu_state.dart';
import 'package:burger/data/repositories/add_menu_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuBloc extends Bloc<AdminMenuItemEvent, MenuState> {
  final MenuRepository repository;

  MenuBloc({required this.repository}) : super(MenuInitial()) {
    /// ✅ Add menu item event
    on<AddMenuItemEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        await repository.addMenuItem(
          title: event.title,
          imagePath: event.imagePath,
          description: event.description,
          price: event.price,
          popular: event.popular,
        );
        emit(MenuSuccess());
      } catch (e) {
        emit(MenuError(message: e.toString()));
      }
    });

    /// ✅ Delete menu item event
    on<DeleteMenuItemEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        await repository.deleteMenuItem(
          partnerId: event.partnerId,
          menuId: event.menuId,
        );
        emit(MenuSuccess());
      } catch (e) {
        emit(MenuError(message: e.toString()));
      }
    });
  }
}
