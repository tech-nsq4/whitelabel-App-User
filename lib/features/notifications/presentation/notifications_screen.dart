import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/notifications_cubit.dart';
import 'widgets/no_notifications_view.dart';
import 'widgets/notification_tile.dart';

/// Notifications feed, backed by `GET /notifications` — reached from the
/// bell icon on `HomeHeader`. Each row is appointment-related; tapping one
/// with an `appointment_id` opens `AppointmentDetailScreen` for it.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit = getIt<NotificationsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getNotifications();
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
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final notifications = state is NotificationsSuccess ? state.notifications : const [];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.notifications_title.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is NotificationsLoading || state is NotificationsInitial,
                        error: state is NotificationsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getNotifications(),
                        isEmpty: notifications.isEmpty,
                        noDataBuilder: (_) => const NoNotificationsView(),
                        builder: (context) => ListView.builder(
                          padding: EdgeInsets.only(bottom: 24.h),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            final appointmentId = notification.appointmentId;
                            return NotificationTile(
                              notification: notification,
                              onTap: appointmentId == null
                                  ? null
                                  : () => Navigator.pushNamed(
                                        context,
                                        Routes.appointmentDetail,
                                        arguments: {'id': appointmentId},
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
