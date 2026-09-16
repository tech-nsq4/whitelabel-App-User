import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../offers/presentation/offer_navigation.dart';
import '../data/models/notification_model.dart';
import '../logic/notifications_cubit.dart';
import '../logic/unread_count_cubit.dart';
import 'widgets/no_notifications_view.dart';
import 'widgets/notification_tile.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit = getIt<NotificationsCubit>();
  late final UnreadCountCubit _unreadCountCubit = getIt<UnreadCountCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getNotifications();
  }

  @override
  void dispose() {
    _cubit.close();
    // `_unreadCountCubit` is the app-wide singleton `HomeHeader`'s bell
    // badge listens to (see `injection.dart`) — don't close it here.
    super.dispose();
  }

  Future<void> _markAllAsRead() async {
    final ok = await _cubit.markAllAsRead();
    if (ok) unawaited(_unreadCountCubit.getUnreadCount());
  }

  Future<void> _refresh() async {
    await _cubit.getNotifications(silent: true);
    unawaited(_unreadCountCubit.getUnreadCount());
  }

  void _onTapNotification(NotificationModel notification) {
    if (!notification.isRead) {
      unawaited(_cubit.markAsRead(notification.id).then((ok) {
        if (ok) _unreadCountCubit.getUnreadCount();
      }));
    }
    _openTarget(notification);
  }

  void _openTarget(NotificationModel notification) {
    final appointmentId = notification.appointmentId;
    if (appointmentId != null) {
      Navigator.pushNamed(context, Routes.appointmentDetail,
          arguments: {'id': appointmentId});
      return;
    }
    final offerId = notification.offerId;
    if (offerId != null) {
      unawaited(openOfferById(context, offerId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final notifications = state is NotificationsSuccess ? state.notifications : const [];
          final hasUnread = notifications.any((n) => !n.isRead);

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(
                      title: LocaleKeys.notifications_title.tr(),
                      trailing: hasUnread
                          ? GestureDetector(
                              onTap: _markAllAsRead,
                              child: AppText(
                                LocaleKeys.notifications_markAllRead.tr(),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor.themeColor,
                              ),
                            )
                          : null,
                    ),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is NotificationsLoading || state is NotificationsInitial,
                        error: state is NotificationsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getNotifications(),
                        onRefresh: _refresh,
                        isEmpty: notifications.isEmpty,
                        noDataBuilder: (_) => RefreshIndicator(
                          onRefresh: _refresh,
                          child: const NoNotificationsView(),
                        ),
                        builder: (context) => ListView.builder(
                          padding: EdgeInsets.only(bottom: 24.h),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(
                              notification: notification,
                              onTap: () => _onTapNotification(notification),
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
