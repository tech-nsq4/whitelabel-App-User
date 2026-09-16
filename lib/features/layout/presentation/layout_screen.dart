import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../account/presentation/account_screen.dart';
import '../../booking/logic/appointments_cubit.dart';
import '../../booking/logic/favorites_cubit.dart';
import '../../chat/data/chat_repo.dart';
import '../../chat/data/models/chat_message_model.dart';
import '../../family/presentation/family_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../medical_file/presentation/medical_file_screen.dart';
import '../../notifications/logic/unread_count_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import 'widgets/custom_nav_bar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.currentPage = 0});

  final int currentPage;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> with WidgetsBindingObserver {
  late int _currentIndex;

  static final _screens = [
    const HomeScreen(),
    const MedicalFileScreen(),
    const FamilyScreen(),
    const AccountScreen(),
  ];

  static final _navItems = [
    NavBarItem(icon: AppSvgIcons.home, labelKey: LocaleKeys.nav_home),
    NavBarItem(
        icon: AppSvgIcons.medicalFile, labelKey: LocaleKeys.nav_medicalFile),
    NavBarItem(icon: AppSvgIcons.family, labelKey: LocaleKeys.nav_family),
    NavBarItem(icon: AppSvgIcons.account, labelKey: LocaleKeys.nav_account),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.currentPage;
    _onLogin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _setPresence(online: state == AppLifecycleState.resumed);
  }

  void _setPresence({required bool online}) {
    if (kIsGuest) return;
    final repo = getIt<ChatRepo>();
    if (online) {
      repo.setOnline(role: ChatSenderRole.user, id: kUserModel!.id);
    } else {
      repo.setOffline(role: ChatSenderRole.user, id: kUserModel!.id);
    }
  }

  /// Fires the device-housekeeping/data calls that only make sense for a
  /// signed-in session — push-token registration, UI-language sync, the
  /// home screen's upcoming-appointment card, the notifications badge — all
  /// best-effort/fire-and-forget. Skipped entirely for a guest.
  ///
  /// Called both once from [initState] (covers arriving here already signed
  /// in) and again from the [BlocListener] in [build] whenever a guest
  /// session turns into a signed-in one without ever re-entering this screen
  /// (e.g. `requireGuestLogin` resuming a gated tap on `FamilyScreen` or
  /// `HomeScreen`). That second case matters because every tab here is kept
  /// alive in an `IndexedStack` built from a `static final` list — each
  /// tab's own `initState`/`build` only runs once per app session, so
  /// whatever `kIsGuest` was at that first run would otherwise stick
  /// forever instead of picking up a later login.
  void _onLogin() {
    if (kIsGuest) return;
    final profileCubit = context.read<ProfileCubit>();

    FirebaseMessaging.instance.getToken().then((fcmToken) {
      if (fcmToken != null && fcmToken.isNotEmpty) {
        profileCubit.registerFcmToken(fcmToken);
      }
    });

    profileCubit.syncAppLang(getIt<LocalStorage>().getLang());
    getIt<UnreadCountCubit>().getUnreadCount();
    getIt<AppointmentsCubit>().getAppointments();
    getIt<FavoritesCubit>().load();
    _setPresence(online: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous is! ProfileSuccess && current is ProfileSuccess,
      listener: (context, state) => _onLogin(),
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _screens),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavBar(
                currentIndex: _currentIndex,
                items: _navItems,
                onTap: (i) => setState(() => _currentIndex = i),
                onFabTap: () => Navigator.pushNamed(context, Routes.book),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
