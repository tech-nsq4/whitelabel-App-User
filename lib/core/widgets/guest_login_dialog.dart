import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/router/routes.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/locale_keys.dart';
import 'app_button.dart';
import 'app_text.dart';

/// The guest gate for an action that actually needs an account (e.g.
/// confirming a booking): shows [GuestLoginDialog] and, if the guest taps
/// through, pushes the login flow **on top of** the current screen
/// (`popOnSuccess: true`) instead of replacing the whole stack — so once
/// they sign in, this pops back to exactly where they left off and returns
/// `true` to let the caller resume its own flow with its own local state
/// (already-picked slot, etc.) instead of restarting from the app shell.
///
/// Returns `false` if the guest cancels the dialog or backs out of the auth
/// flow anywhere along the way.
Future<bool> requireGuestLogin(BuildContext context) async {
  final wantsToLogin = await showDialog<bool>(
    context: context,
    builder: (_) => const GuestLoginDialog(),
  );
  if (wantsToLogin != true || !context.mounted) return false;

  // Deliberately untyped: `RouteGenerator`'s `_pageRoute` builds every route
  // as `MaterialPageRoute<dynamic>` (no generic argument), and Flutter's
  // `pushNamed<T>` casts whatever `onGenerateRoute` returns to `Route<T>?`
  // internally — `pushNamed<bool>` here would throw ("MaterialPageRoute
  // <dynamic> is not a subtype of Route<bool?>") the moment it tried to
  // actually push, since a `Route<dynamic>` doesn't satisfy that cast.
  final result = await Navigator.pushNamed(
    context,
    Routes.loginScreen,
    arguments: {'popOnSuccess': true},
  );
  return result == true;
}

/// The common case built on [requireGuestLogin]: a tile/button that would
/// normally just `Navigator.pushNamed` straight to a member-only screen
/// (bookings, lab results, notifications, ...). For a guest it shows the
/// gate first and only follows through to [route] once they've actually
/// signed in; for a logged-in user it's a plain, immediate navigation.
Future<void> pushNamedOrRequireLogin(
  BuildContext context,
  String route, {
  Object? arguments,
}) async {
  if (kIsGuest) {
    final loggedIn = await requireGuestLogin(context);
    if (!loggedIn || !context.mounted) return;
  }
  if (!context.mounted) return;
  Navigator.pushNamed(context, route, arguments: arguments);
}

/// App-logo + big description prompt telling a guest they need to sign in
/// to continue — the badge mirrors [AuthHeader]'s brand mark so it reads as
/// "the app's logo" rather than a generic dialog icon.
class GuestLoginDialog extends StatelessWidget {
  const GuestLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.cardColor.themeColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 76.w,
              height: 76.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 76.w,
                    height: 76.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: primary.withValues(alpha: 0.10)),
                  ),
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      border: Border.all(color: AppColors.accentGold.themeColor, width: 2),
                    ),
                    child: Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 28.sp),
                  ),
                ],
              ),
            ),
            18.height,
            AppText(
              LocaleKeys.booking_guestLoginTitle.tr(),
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor,
              textAlign: TextAlign.center,
            ),
            10.height,
            AppText(
              LocaleKeys.booking_guestLoginDescription.tr(),
              fontSize: 13,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
              height: 1.6,
            ),
            28.height,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context, false),
                    title: LocaleKeys.common_cancel.tr(),
                    isOutlined: true,
                    borderColor: AppColors.dividerColor.themeColor,
                    textColor: AppColors.textSecondaryColor.themeColor,
                    color: Colors.transparent,
                  ),
                ),
                12.width,
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context, true),
                    title: LocaleKeys.auth_login.tr(),
                    color: primary,
                    borderColor: primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
