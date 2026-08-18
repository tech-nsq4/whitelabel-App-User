import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/my_bookings_cubit.dart';
import 'widgets/appointment_list_tile.dart';
import 'widgets/booking_status_tabs.dart';
import 'widgets/no_bookings_view.dart';

/// The account's booking history, backed by `GET /appointments` — reached
/// from `MedicalFileScreen`'s "حجوزاتي" row. [BookingStatusTabs] re-fetches
/// with the matching `status` query filter; tapping a booking opens
/// `AppointmentDetailScreen` for its full details.
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late final MyBookingsCubit _cubit = getIt<MyBookingsCubit>();
  BookingStatusFilter _filter = BookingStatusFilter.all;

  @override
  void initState() {
    super.initState();
    _cubit.getAppointments();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onSelectFilter(BookingStatusFilter filter) {
    setState(() => _filter = filter);
    _cubit.getAppointments(status: filter.apiValue);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
        builder: (context, state) {
          final appointments = state is MyBookingsSuccess ? state.appointments : const [];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_myBookingsTitle.tr()),
                    BookingStatusTabs(selected: _filter, onSelect: _onSelectFilter),
                    14.height,
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is MyBookingsLoading || state is MyBookingsInitial,
                        error: state is MyBookingsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getAppointments(status: _filter.apiValue),
                        isEmpty: appointments.isEmpty,
                        noDataBuilder: (_) => const NoBookingsView(),
                        builder: (context) => ListView.builder(
                          padding: EdgeInsets.only(bottom: 24.h),
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return AppointmentListTile(
                              appointment: appointment,
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.appointmentDetail,
                                arguments: {'id': appointment.id},
                              ),
                            );
                          },
                        ),
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
