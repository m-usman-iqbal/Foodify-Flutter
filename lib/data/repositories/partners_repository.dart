import 'package:burger/data/services/partner_services.dart';
import 'package:burger/domain/models/partners_model.dart';

class PartnersRepository {
  final PartnersService _service;

  PartnersRepository(this._service);

  Future<List<Partner>> getAllPartners() async {
    try {
      final partners = await _service.fetchPartners();
      // You can add additional logic here if needed
      return partners;
    } catch (e) {
      throw Exception('Failed to load partners: $e');
    }
  }
}
