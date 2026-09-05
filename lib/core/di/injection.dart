import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/booking/data/booking_repo.dart';
import '../../features/booking/logic/appointment_detail_cubit.dart';
import '../../features/booking/logic/appointments_cubit.dart';
import '../../features/booking/logic/branches_cubit.dart';
import '../../features/booking/logic/doctor_details_cubit.dart';
import '../../features/booking/logic/doctors_cubit.dart';
import '../../features/booking/logic/my_bookings_cubit.dart';
import '../../features/booking/logic/specializations_cubit.dart';
import '../../features/booking/logic/time_tables_cubit.dart';
import '../../features/chat/data/chat_repo.dart';
import '../../features/chat/logic/chat_cubit.dart';
import '../../features/family/data/family_repo.dart';
import '../../features/family/logic/family_cubit.dart';
import '../../features/lab/data/lab_repo.dart';
import '../../features/lab/logic/test_history_cubit.dart';
import '../../features/medications/data/medications_repo.dart';
import '../../features/medications/logic/medications_cubit.dart';
import '../../features/notifications/data/notifications_repo.dart';
import '../../features/notifications/logic/notifications_cubit.dart';
import '../../features/notifications/logic/unread_count_cubit.dart';
import '../../features/offers/data/offers_repo.dart';
import '../../features/offers/logic/offers_cubit.dart';
import '../../features/payments/data/payments_repo.dart';
import '../../features/payments/logic/payments_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../network/dio_client.dart';
import '../storage/local_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  // ─── Storage ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => LocalStorage());

  // ─── Network ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => DioClient(storage: getIt()));

  // ─── Repos ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => AuthRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => BookingRepo(dio: getIt()));
  getIt.registerLazySingleton(() => FamilyRepo(dio: getIt()));
  getIt.registerLazySingleton(() => NotificationsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => LabRepo(dio: getIt()));
  getIt.registerLazySingleton(() => MedicationsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => PaymentsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => OffersRepo(dio: getIt()));
  getIt.registerLazySingleton(() => ChatRepo(dio: getIt()));

  // ─── Cubits ───────────────────────────────────────────────────────────────
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => SpecializationsCubit(getIt()));
  getIt.registerFactory(() => DoctorsCubit(getIt()));
  getIt.registerFactory(() => DoctorDetailsCubit(getIt()));
  getIt.registerFactory(() => FamilyCubit(getIt()));
  getIt.registerFactory(() => BranchesCubit(getIt()));
  getIt.registerFactory(() => TimeTablesCubit(getIt()));
  getIt.registerFactory(() => AppointmentDetailCubit(getIt()));
  getIt.registerFactory(() => MyBookingsCubit(getIt()));
  getIt.registerFactory(() => NotificationsCubit(getIt()));
  getIt.registerFactory(() => TestHistoryCubit(getIt()));
  getIt.registerFactory(() => MedicationsCubit(getIt()));
  getIt.registerFactory(() => PaymentsCubit(getIt()));
  getIt.registerFactory(() => OffersCubit(getIt()));
  getIt.registerFactory(() => ChatCubit(getIt()));

  // `AppointmentsCubit` is a singleton (not the usual per-screen factory):
  // `DoctorScreen` refreshes it right after booking and `HomeScreen`'s
  // "upcoming appointment" card listens to that very same instance, so the
  // card updates live the moment you go back — no manual refresh, no extra
  // re-fetch on navigation. Never call `.close()` on it from a screen's
  // `dispose()`; it lives for the app's session.
  getIt.registerLazySingleton(() => AppointmentsCubit(getIt()));

  // Same reasoning as `AppointmentsCubit` above: `LayoutScreen` fetches this
  // once on app-shell mount, `HomeHeader`'s bell badge reads it, and
  // `NotificationsScreen` refreshes this exact instance after marking
  // anything read.
  getIt.registerLazySingleton(() => UnreadCountCubit(getIt()));
}
