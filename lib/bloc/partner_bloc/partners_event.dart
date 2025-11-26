part of 'partners_bloc.dart';

sealed class PartnersEvent extends Equatable {
  const PartnersEvent();

  @override
  List<Object> get props => [];
}

class LoadPartners extends PartnersEvent {}
