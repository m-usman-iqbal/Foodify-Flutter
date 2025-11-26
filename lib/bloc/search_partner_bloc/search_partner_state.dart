import 'package:burger/domain/models/search_partner_model.dart';

abstract class SearchPartnerState {}

class SearchPartnerInitial extends SearchPartnerState {}

class SearchPartnerLoading extends SearchPartnerState {}

class SearchPartnerLoaded extends SearchPartnerState {
  final List<SearchPartnerModel> partners;
  final String searchQuery;

  SearchPartnerLoaded({required this.partners, required this.searchQuery});
}

class SearchPartnerError extends SearchPartnerState {
  final String message;
  SearchPartnerError({required this.message});
}
