class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://white-label.nsq4.sa/api/user/';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  /// Requests an OTP for a phone number — shared by both login and register.
  static const String sendOtp = 'auth/otp';

  /// Verifies the OTP and logs the user in (creating the account first if
  /// it doesn't exist yet — see `is_new_user` on the [sendOtp] response).
  static const String verifyOtp = 'auth/login';

  static const String logout = 'auth/logout';
  static const String profile = 'profile';

  // ─── Booking ──────────────────────────────────────────────────────────────
  /// The specialties tree (with nested sub-specializations) shown on
  /// `SpecsScreen`.
  static const String specializations = 'specializations';

  /// The doctors list — filterable by `specialization_id`, `clinic_id`,
  /// `lat`/`lng` (nearest-first).
  static const String doctors = 'doctors';

  /// A single doctor's full profile.
  static String doctorDetails(int id) => 'doctors/$id';

  /// The clinics/branches list shown on `BranchesScreen`.
  static const String branches = 'branches';

  /// A doctor's recurring weekly schedule(s) — powers the calendar/time
  /// picker on `BookingSlotsSheet`.
  static String doctorTimeTables(int doctorId) => 'doctors/$doctorId/time-tables';

  /// `GET` lists the current user's booked appointments (powers the home
  /// screen's "upcoming appointment" card); `POST` books a new one from
  /// `BookingSlotsSheet`.
  static const String appointments = 'appointments';

  /// A single appointment's full details, shown on `AppointmentDetailScreen`.
  static String appointmentDetails(int id) => 'appointments/$id';

  // ─── Family ───────────────────────────────────────────────────────────────
  /// `GET` lists the account's linked family members; `POST` (multipart,
  /// for the `medical_files[]` attachments) adds a new one.
  static const String familyMembers = 'family-members';

  /// Updates one family member (multipart, same shape as [familyMembers]'s
  /// `POST`).
  static String familyMemberDetails(int id) => 'family-members/$id';

  // ─── Device ───────────────────────────────────────────────────────────────
  /// Registers/refreshes this device's push-notification token.
  static const String fcmToken = 'fcm-token';

  /// Syncs the app's active UI language with the backend.
  static const String appLang = 'app-lang';
}
