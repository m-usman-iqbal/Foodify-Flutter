import 'package:burger/data/repositories/partners_repository.dart';
import 'package:burger/domain/models/partners_model.dart';
import 'package:flutter/foundation.dart';

class PartnersViewModel extends ChangeNotifier {
  final PartnersRepository _repository;

  PartnersViewModel(this._repository);

  List<Partner> _partners = [];
  List<Partner> get partners => _partners;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadPartners() async {
    _isLoading = true;
    notifyListeners();

    try {
      _partners = await _repository.getAllPartners();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _partners = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
