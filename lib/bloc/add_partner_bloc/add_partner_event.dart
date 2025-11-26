import 'package:burger/domain/models/add_partner_model.dart';
import 'package:equatable/equatable.dart';

abstract class PartnerEvent extends Equatable {
  const PartnerEvent();

  @override
  List<Object> get props => [];
}

class AddPartnerPressed extends PartnerEvent {
  final AddPartner partner;

  const AddPartnerPressed(this.partner);

  @override
  List<Object> get props => [partner];
}
