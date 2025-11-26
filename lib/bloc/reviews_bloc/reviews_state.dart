part of 'reviews_bloc.dart';

sealed class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object> get props => [];
}

final class ReviewsInitial extends ReviewsState {}

final class ReviewsLoading extends ReviewsState {}

final class ReviewsLoaded extends ReviewsState {
  final List<Map<String, dynamic>> reviews;
  const ReviewsLoaded({required this.reviews});
}

final class ReviewsFailed extends ReviewsState {}
