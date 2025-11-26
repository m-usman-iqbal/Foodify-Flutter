import 'package:burger/domain/models/partners_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'partners_event.dart';
part 'partners_state.dart';

class PartnersBloc extends Bloc<PartnersEvent, PartnersState> {
  PartnersBloc() : super(PartnersLoading()) {
    on<LoadPartners>(_onLoadPartners);
  }
}

Future<void> _onLoadPartners(
  LoadPartners event,
  Emitter<PartnersState> emit,
) async {
  emit(PartnersLoading());
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('partners')
        .get();
    final partners = snapshot.docs
        .map(
          (doc) => Partner(
            image: doc['image'],
            title: doc['title'],
            status: doc['status'],
            type: doc['type'],
            rating: (doc['rating'] ?? 0).toDouble(),
            distance: doc['distance'],
            shipping: doc['shipping'],
            address: doc['address'],
            id: doc.id,
          ),
        )
        .toList();
    emit(PartnersLoaded(partners));
  } catch (e) {
    emit(PartnersError(e.toString()));
  }
}
