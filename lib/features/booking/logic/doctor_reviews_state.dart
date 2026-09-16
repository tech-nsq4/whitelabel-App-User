part of 'doctor_reviews_cubit.dart';

sealed class DoctorReviewsState extends Equatable {
  const DoctorReviewsState();

  @override
  List<Object?> get props => [];
}

final class DoctorReviewsInitial extends DoctorReviewsState {
  const DoctorReviewsInitial();
}

final class DoctorReviewsLoading extends DoctorReviewsState {
  const DoctorReviewsLoading();
}

final class DoctorReviewsSuccess extends DoctorReviewsState {
  final List<DoctorReviewModel> reviews;
  const DoctorReviewsSuccess(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

final class DoctorReviewsError extends DoctorReviewsState {
  final String message;
  const DoctorReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
