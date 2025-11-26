import 'package:burger/bloc/add_partner_bloc/add_partner_event.dart';
import 'package:burger/bloc/add_partner_bloc/add_partner_state.dart';
import 'package:burger/data/repositories/add_partner_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  final PartnerRepository repository;

  PartnerBloc({required this.repository}) : super(PartnerInitial()) {
    on<AddPartnerPressed>((event, emit) async {
      emit(PartnerLoading());
      try {
        await repository.addPartner(event.partner);
        emit(PartnerSuccess());
      } catch (e) {
        emit(PartnerFailure(e.toString()));
      }
    });
  }
}
