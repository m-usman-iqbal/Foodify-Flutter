import 'package:bloc/bloc.dart';
import 'package:burger/data/repositories/profile_repository.dart';
import 'package:burger/domain/models/profile_model.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoadingState());
      final profile = await repository.service.fetchProfile();
      emit(ProfileLoaded(profile: profile));
    });
  }
}
