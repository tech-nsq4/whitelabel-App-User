import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  final NotificationsRepo _repo;

  /// [silent] skips the [NotificationsLoading] emission and, on failure,
  /// shows an error overlay instead of an [NotificationsError] state — used
  /// by [markAsRead] so tapping one row refreshes the list quietly instead
  /// of flashing the whole screen back to a spinner.
  Future<void> getNotifications({bool silent = false}) async {
    if (!silent) emit(const NotificationsLoading());
    try {
      final items = await _repo.getNotifications();
      emit(NotificationsSuccess(items));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      if (silent) {
        AppOverlay.showError(msg);
      } else {
        emit(NotificationsError(msg));
      }
    }
  }

  /// Marks every notification as read, then reloads the list (loading state
  /// and all — this is an explicit, tap-and-wait action). `false` on
  /// failure (still reloads, so the list reflects whatever actually
  /// happened server-side).
  Future<bool> markAllAsRead() async {
    emit(const NotificationsLoading());
    try {
      await _repo.markAllAsRead();
      await getNotifications();
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      await getNotifications();
      return false;
    }
  }

  /// Marks [notificationId] as read, then silently refreshes the list (no
  /// loading flash — see [getNotifications]). `false` on failure (only
  /// shows the error overlay).
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
      await getNotifications(silent: true);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
