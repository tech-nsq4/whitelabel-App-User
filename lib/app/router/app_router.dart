import 'package:flutter/material.dart';

import '../../features/account/presentation/branches_screen.dart';
import '../../features/account/presentation/contact_screen.dart';
import '../../features/account/presentation/feedback_screen.dart';
import '../../features/account/presentation/privacy_screen.dart';
import '../../features/account/presentation/profile_screen.dart';
import '../../features/account/presentation/settings_screen.dart';
import '../../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../../features/ai_assistant/presentation/ai_plan_screen.dart';
import '../../features/ask_doctor/presentation/ask_doctor_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/booking/presentation/book_screen.dart';
import '../../features/booking/presentation/doctor_screen.dart';
import '../../features/booking/presentation/specs_screen.dart';
import '../../features/booking/presentation/symptom_checker_screen.dart';
import '../../features/emergency/presentation/em_ambulance_screen.dart';
import '../../features/emergency/presentation/em_checkin_screen.dart';
import '../../features/emergency/presentation/em_nearest_screen.dart';
import '../../features/emergency/presentation/em_rapid_screen.dart';
import '../../features/emergency/presentation/emergency_screen.dart';
import '../../features/family/presentation/member_screen.dart';
import '../../features/homecare/presentation/homecare_screen.dart';
import '../../features/immunity/presentation/immunity_screen.dart';
import '../../features/lab/data/models/clinic_report_model.dart';
import '../../features/lab/presentation/clinic_appts_screen.dart';
import '../../features/lab/presentation/clinic_reports_screen.dart';
import '../../features/lab/presentation/report_view_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/medications/presentation/medications_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/on_boarding_screen.dart';
import '../../features/payments/presentation/payments_screen.dart';
import '../../features/pharmacy/presentation/ph_appts_screen.dart';
import '../../features/pharmacy/presentation/ph_clinics_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/telemed/presentation/telemed_screen.dart';
import '../../features/visits/presentation/visit_detail_screen.dart';
import '../../features/visits/presentation/visit_list_screen.dart';
import '../../features/visits/presentation/visits_screen.dart';
import '../../features/vitals/presentation/vitals_screen.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return _pageRoute(const SplashScreen());

      case Routes.onBoardingScreen:
        return _pageRoute(const OnBoardingScreen());

      case Routes.loginScreen:
        return _pageRoute(const LoginScreen());

      case Routes.registerScreen:
        return _pageRoute(const RegisterScreen());

      case Routes.layoutScreen:
        return _pageRoute(LayoutScreen(
          currentPage: arguments?['currentPage'] ?? 0,
        ));

      case Routes.visits:
        return _pageRoute(const VisitsScreen());

      case Routes.visitList:
        return _pageRoute(VisitListScreen(clinic: arguments?['clinic'] as String));

      case Routes.visitDetail:
        return _pageRoute(VisitDetailScreen(
          clinic: arguments?['clinic'] as String,
          visitId: arguments?['visitId'] as String,
        ));

      case Routes.labClinics:
        return _pageRoute(const ClinicReportsScreen(type: ReportType.lab));

      case Routes.xrayClinics:
        return _pageRoute(const ClinicReportsScreen(type: ReportType.xray));

      case Routes.clinicAppts:
        return _pageRoute(ClinicApptsScreen(
          type: arguments?['type'] as ReportType,
          clinic: arguments?['clinic'] as String,
        ));

      case Routes.reportView:
        return _pageRoute(ReportViewScreen(
          type: arguments?['type'] as ReportType,
          clinic: arguments?['clinic'] as String,
          number: arguments?['number'] as String,
        ));

      case Routes.phClinics:
        return _pageRoute(const PhClinicsScreen());

      case Routes.phAppts:
        return _pageRoute(PhApptsScreen(clinic: arguments?['clinic'] as String));

      case Routes.notifications:
        return _pageRoute(const NotificationsScreen());

      case Routes.services:
        return _pageRoute(const ServicesScreen());

      case Routes.medications:
        return _pageRoute(const MedicationsScreen());

      case Routes.vitals:
        return _pageRoute(const VitalsScreen());

      case Routes.payments:
        return _pageRoute(const PaymentsScreen());

      case Routes.reports:
        return _pageRoute(const ReportsScreen());

      case Routes.immunity:
        return _pageRoute(const ImmunityScreen());

      case Routes.askDoctor:
        return _pageRoute(const AskDoctorScreen());

      case Routes.telemed:
        return _pageRoute(const TelemedScreen());

      case Routes.emergency:
        return _pageRoute(const EmergencyScreen());

      case Routes.emAmbulance:
        return _pageRoute(const EmAmbulanceScreen());

      case Routes.emNearest:
        return _pageRoute(const EmNearestScreen());

      case Routes.emRapid:
        return _pageRoute(const EmRapidScreen());

      case Routes.emCheckin:
        return _pageRoute(const EmCheckinScreen());

      case Routes.homeCare:
        return _pageRoute(const HomeCareScreen());

      case Routes.book:
        return _pageRoute(const BookScreen());

      case Routes.specs:
        return _pageRoute(SpecsScreen(initialSpecialty: arguments?['initialSpecialty'] as String?));

      case Routes.doctor:
        return _pageRoute(DoctorScreen(doctorId: arguments?['id'] as String));

      case Routes.symptomChecker:
        return _pageRoute(const SymptomCheckerScreen());

      case Routes.member:
        return _pageRoute(MemberScreen(memberId: arguments?['id'] as String));

      case Routes.profile:
        return _pageRoute(const ProfileScreen());

      case Routes.settings:
        return _pageRoute(const SettingsScreen());

      case Routes.privacy:
        return _pageRoute(const PrivacyScreen());

      case Routes.feedback:
        return _pageRoute(const FeedbackScreen());

      case Routes.contact:
        return _pageRoute(const ContactScreen());

      case Routes.branches:
        return _pageRoute(const BranchesScreen());

      case Routes.aiAssistant:
        return _pageRoute(const AiAssistantScreen());

      case Routes.aiPlan:
        return _pageRoute(const AiPlanScreen());

      default:
        return _pageRoute(const _UndefinedScreen());
    }
  }

  static PageRoute<dynamic> _pageRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class _UndefinedScreen extends StatelessWidget {
  const _UndefinedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }
}
