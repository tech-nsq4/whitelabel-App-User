import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/notifications_repo.dart';

part 'unread_count_state.dart';

/// The bell badge count on `HomeHeader`. An app-wide singleton (like
/// `AppointmentsCubit`) — `LayoutScreen` fetches it once right when the
/// authenticated user lands on the app shell, and `NotificationsScreen`
/// refreshes this exact instance after marking anything read, so the badge
/// updates the moment you go back without a manual re-fetch.
class UnreadCountCubit extends Cubit<UnreadCountState> {
  UnreadCountCubit(this._repo) : super(const UnreadCountInitial());

  final NotificationsRepo _repo;

  /// Silent by design — a badge count going stale for a beat isn't worth
  /// showing the user an error overlay over, so failures are just ignored
  /// and the last-known count stays put.
  Future<void> getUnreadCount() async {
    try {
      final count = await _repo.getUnreadCount();
      emit(UnreadCountSuccess(count));
    } catch (_) {
      // Ignored on purpose — see doc comment above.
    }
  }
}
