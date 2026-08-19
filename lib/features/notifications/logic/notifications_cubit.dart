import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  final NotificationsRepo _repo;

  Future<void> getNotifications() async {
    emit(const NotificationsLoading());
    try {
      final items = await _repo.getNotifications();
      emit(NotificationsSuccess(items));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(NotificationsError(msg));
    }
  }
}
