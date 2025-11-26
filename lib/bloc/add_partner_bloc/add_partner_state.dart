import 'package:equatable/equatable.dart';

abstract class PartnerState extends Equatable {
  const PartnerState();

  @override
  List<Object> get props => [];
}

class PartnerInitial extends PartnerState {}

class PartnerLoading extends PartnerState {}

class PartnerSuccess extends PartnerState {}

class PartnerFailure extends PartnerState {
  final String message;

  const PartnerFailure(this.message);

  @override
  List<Object> get props => [message];
}
