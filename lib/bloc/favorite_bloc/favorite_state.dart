import '../../../domain/models/favorite_model.dart';

class FavoriteState {
  final List<FavoriteModel> favorites;
  final bool isLoading;
  final String? error;

  FavoriteState({required this.favorites, required this.isLoading, this.error});

  factory FavoriteState.initial() {
    return FavoriteState(favorites: [], isLoading: false);
  }
}
