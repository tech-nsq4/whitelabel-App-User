import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/appointment_detail_cubit.dart';
import 'widgets/appointment_detail_body.dart';

/// Appointment detail screen, backed by `GET /appointments/{id}` — reached
/// by tapping the home screen's "upcoming appointment" card.
class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  final int appointmentId;

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late final AppointmentDetailCubit _cubit = getIt<AppointmentDetailCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getAppointment(widget.appointmentId);
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
      child: BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_appointmentDetailsTitle.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is AppointmentDetailLoading || state is AppointmentDetailInitial,
                        error: state is AppointmentDetailError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getAppointment(widget.appointmentId),
                        builder: (context) {
                          final appointment = (state as AppointmentDetailSuccess).appointment;
                          return AppointmentDetailBody(appointment: appointment);
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
