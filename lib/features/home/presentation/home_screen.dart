import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/section_header.dart';
import 'widgets/ai_assistant_banner.dart';
import 'widgets/health_card.dart';
import 'widgets/health_card_modal.dart';
import 'widgets/home_header.dart';
import 'widgets/home_services_grid.dart';
import 'widgets/medical_record_list.dart';
import 'widgets/upcoming_appointment_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            UpcomingAppointmentTile(
              day: '15',
              month: 'يونيو',
              time: '10:30',
              period: 'صباحاً',
              onTap: () => Navigator.pushNamed(context, Routes.visits),
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
    );
  }
}
