import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/section_header.dart';
import '../../booking/logic/appointments_cubit.dart';
import 'widgets/ai_assistant_banner.dart';
import 'widgets/health_card.dart';
import 'widgets/health_card_modal.dart';
import 'widgets/home_header.dart';
import 'widgets/home_services_grid.dart';
import 'widgets/medical_record_list.dart';
import 'widgets/no_upcoming_appointment_tile.dart';
import 'widgets/upcoming_appointment_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppointmentsCubit _cubit = getIt<AppointmentsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getAppointments();
  }

  // No `dispose()`/`.close()` override here: `_cubit` is the app-wide
  // `AppointmentsCubit` singleton (see `injection.dart`) — `DoctorScreen`
  // refreshes this exact instance right after booking, which is how this
  // card updates the moment you come back without a manual refresh. Closing
  // it here would break that for the rest of the app's session.

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 110.h),
            children: [
              HomeHeader(
                notificationCount: 4,
                onNotificationsTap: () => Navigator.pushNamed(context, Routes.notifications),
                onCardTap: () => showHealthCardModal(context),
              ),
              22.height,
              HealthCard(onTap: () => showHealthCardModal(context)),
              22.height,
              AiAssistantBanner(
                onTap: () => Navigator.pushNamed(context, Routes.aiAssistant),
              ),
              10.height,
              SectionHeader(title: LocaleKeys.home_upcomingAppointment.tr()),
              10.height,
              BlocBuilder<AppointmentsCubit, AppointmentsState>(
                builder: (context, state) {
                  if (state is AppointmentsLoading || state is AppointmentsInitial) {
                    return const SizedBox.shrink();
                  }
                  final appointment = state is AppointmentsSuccess ? state.nextUpcoming : null;
                  if (appointment == null) {
                    return NoUpcomingAppointmentTile(onTap: () => Navigator.pushNamed(context, Routes.book));
                  }

                  final dateTime = appointment.dateTime!;
                  final doctor = appointment.doctor;
                  final clinicBranch = [
                    if (doctor?.specialtyLabel.isNotEmpty ?? false) doctor!.specialtyLabel,
                    if (doctor?.clinic?.name != null) doctor!.clinic!.name,
                  ].join(' · ');

                  return UpcomingAppointmentTile(
                    day: DateFormat('d', locale).format(dateTime),
                    month: DateFormat('MMMM', locale).format(dateTime),
                    time: DateFormat('h:mm', locale).format(dateTime),
                    period: DateFormat('a', locale).format(dateTime),
                    doctorName: doctor?.name ?? '',
                    clinicBranch: clinicBranch,
                    onTap: () => Navigator.pushNamed(context, Routes.appointmentDetail, arguments: {
                      'id': appointment.id,
                    }),
                  );
                },
              ),
              24.height,
              SectionHeader(
                title: LocaleKeys.home_services.tr(),
                actionLabel: LocaleKeys.home_seeAll.tr(),
                onActionTap: () => Navigator.pushNamed(context, Routes.services),
              ),
              12.height,
              HomeServicesGrid(
                onBookTap: () => Navigator.pushNamed(context, Routes.book),
                onTelemedTap: () => Navigator.pushNamed(context, Routes.telemed),
                onEmergencyTap: () => Navigator.pushNamed(context, Routes.emergency),
              ),
              24.height,
              SectionHeader(
                title: LocaleKeys.home_medicalRecord.tr(),
                actionLabel: LocaleKeys.home_seeAll.tr(),
                onActionTap: () => Navigator.pushNamed(context, Routes.visits),
              ),
              12.height,
              MedicalRecordList(
                onVisitsTap: () => Navigator.pushNamed(context, Routes.visits),
                onLabResultsTap: () => Navigator.pushNamed(context, Routes.labClinics),
                onXrayTap: () => Navigator.pushNamed(context, Routes.xrayClinics),
                onMedicationsTap: () => Navigator.pushNamed(context, Routes.medications),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
