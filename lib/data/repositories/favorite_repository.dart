import '../../domain/models/favorite_model.dart';
import '../services/favorite_services.dart';

class FavoriteRepository {
  final FavoriteService _service;

  // we will get the service object from somewhere else and then we will set the _service variable
  FavoriteRepository(this._service);

  Future<List<FavoriteModel>> getFavorites() {
    return _service.fetchFavorites();
  }
}
