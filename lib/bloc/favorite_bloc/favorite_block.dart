import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import '../../../data/repositories/favorite_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteState.initial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteState(isLoading: true, favorites: []));

    try {
      final favData = await repository.getFavorites();
      emit(FavoriteState(isLoading: false, favorites: favData));
    } catch (e) {
      emit(FavoriteState(isLoading: false, favorites: [], error: e.toString()));
    }
  }
}
