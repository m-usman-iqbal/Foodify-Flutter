part of 'partners_bloc.dart';

sealed class PartnersState extends Equatable {
  const PartnersState();

  @override
  List<Object> get props => [];
}

final class PartnersLoading extends PartnersState {}

final class PartnersLoaded extends PartnersState {
  final List<Partner> partners;
  const PartnersLoaded(this.partners);

  @override
  List<Object> get props => [partners];
}

final class PartnersError extends PartnersState {
  final String message;
  const PartnersError(this.message);
}

final class PartnersInitial extends PartnersState {}
