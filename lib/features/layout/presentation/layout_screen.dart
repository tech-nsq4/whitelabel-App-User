import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../account/presentation/account_screen.dart';
import '../../family/presentation/family_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../medical_file/presentation/medical_file_screen.dart';
import '../../profile/logic/profile_cubit.dart';
import 'widgets/custom_nav_bar.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.currentPage = 0});

  final int currentPage;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
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
    _currentIndex = widget.currentPage;
    _syncDeviceOnLogin();
  }

  /// Fires the two device-housekeeping calls once, right when the
  /// authenticated user lands on the main app shell: registering the
  /// push-notification token and syncing the active UI language with the
  /// backend. Both are best-effort/fire-and-forget (see [ProfileCubit]) and
  /// skipped entirely for a guest session.
  void _syncDeviceOnLogin() {
    if (kIsGuest) return;
    final profileCubit = context.read<ProfileCubit>();

    // TODO(fcm): wire up `firebase_messaging` (add the package + platform
    // config) and pass the real device token here — left as a no-op until
    // then so this call doesn't fire with a bogus value.
    const fcmToken = '';
    if (fcmToken.isNotEmpty) profileCubit.registerFcmToken(fcmToken);

    profileCubit.syncAppLang(getIt<LocalStorage>().getLang());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
