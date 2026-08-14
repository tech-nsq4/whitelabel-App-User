import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/booking/data/booking_repo.dart';
import '../../features/booking/logic/appointment_detail_cubit.dart';
import '../../features/booking/logic/appointments_cubit.dart';
import '../../features/booking/logic/branches_cubit.dart';
import '../../features/booking/logic/doctor_details_cubit.dart';
import '../../features/booking/logic/doctors_cubit.dart';
import '../../features/booking/logic/specializations_cubit.dart';
import '../../features/booking/logic/time_tables_cubit.dart';
import '../../features/family/data/family_repo.dart';
import '../../features/family/logic/family_cubit.dart';
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

  // `AppointmentsCubit` is a singleton (not the usual per-screen factory):
  // `DoctorScreen` refreshes it right after booking and `HomeScreen`'s
  // "upcoming appointment" card listens to that very same instance, so the
  // card updates live the moment you go back — no manual refresh, no extra
  // re-fetch on navigation. Never call `.close()` on it from a screen's
  // `dispose()`; it lives for the app's session.
  getIt.registerLazySingleton(() => AppointmentsCubit(getIt()));
}
