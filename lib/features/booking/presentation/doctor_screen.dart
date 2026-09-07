import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../offers/data/models/applied_offer.dart';
import '../logic/doctor_details_cubit.dart';
import 'booking_flow.dart';
import 'widgets/doctor_profile_body.dart';

/// Doctor profile / booking-entry screen, backed by `GET /doctors/{id}`.
class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key, required this.doctorId, this.offer});

  final int doctorId;
  final AppliedOffer? offer;

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late final DoctorDetailsCubit _cubit = getIt<DoctorDetailsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getDoctor(widget.doctorId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_doctorProfileTitle.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is DoctorDetailsLoading || state is DoctorDetailsInitial,
                        error: state is DoctorDetailsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getDoctor(widget.doctorId),
                        builder: (context) {
                          final doctor = (state as DoctorDetailsSuccess).doctor;
                          return DoctorProfileBody(
                            doctor: doctor,
                            offer: widget.offer,
                            onBook: (clinicId) => startDoctorBooking(
                              context,
                              doctor: doctor,
                              clinicId: clinicId,
                              offer: widget.offer,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
