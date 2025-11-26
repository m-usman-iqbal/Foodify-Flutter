import 'package:burger/data/repositories/search_partner_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_partner_event.dart';
import 'search_partner_state.dart';

class SearchPartnerBloc extends Bloc<SearchPartnerEvent, SearchPartnerState> {
  final SearchPartnerRepository repository;

  SearchPartnerBloc({required this.repository})
    : super(SearchPartnerInitial()) {
    on<SearchPartnerQueryChanged>((event, emit) async {
      final query = event.query.trim().toLowerCase();

      if (query.isEmpty) {
        emit(SearchPartnerLoaded(partners: [], searchQuery: ''));
        return;
      }

      emit(SearchPartnerLoading());

      try {
        final partners = await repository.getAllPartners();
        emit(SearchPartnerLoaded(partners: partners, searchQuery: query));
      } catch (e) {
        emit(SearchPartnerError(message: e.toString()));
      }
    });
  }
}
