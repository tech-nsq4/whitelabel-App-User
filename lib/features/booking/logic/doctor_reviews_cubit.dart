import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_review_model.dart';

part 'doctor_reviews_state.dart';

class DoctorReviewsCubit extends Cubit<DoctorReviewsState> {
  DoctorReviewsCubit(this._repo) : super(const DoctorReviewsInitial());

  final BookingRepo _repo;

  Future<void> getReviews(int doctorId) async {
    emit(const DoctorReviewsLoading());
    try {
      final reviews = await _repo.getDoctorReviews(doctorId);
      emit(DoctorReviewsSuccess(reviews));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(DoctorReviewsError(msg));
    }
  }
}
