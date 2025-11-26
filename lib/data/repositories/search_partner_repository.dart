import 'package:burger/data/services/search_partner_service.dart';
import 'package:burger/domain/models/search_partner_model.dart';

class SearchPartnerRepository {
  final SearchPartnerService service;

  SearchPartnerRepository({required this.service});

  Future<List<SearchPartnerModel>> getAllPartners() async {
    return await service.fetchPartners();
  }
}
