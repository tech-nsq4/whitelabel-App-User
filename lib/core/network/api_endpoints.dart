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

  /// Moves an existing appointment to a new doctor/schedule/slot, chosen the
  /// same way as a fresh booking (`BookingSlotsSheet`) — same body shape as
  /// [appointments]' `POST`, minus `family_member_id`.
  static String appointmentReschedule(int id) => 'appointments/$id/reschedule';

  /// Cancels an appointment that hasn't happened yet.
  static String appointmentCancel(int id) => 'appointments/$id/cancel';

  /// Rates a completed appointment (1-5 stars + an optional comment).
  static String appointmentRate(int id) => 'appointments/$id/rate';

  // ─── Family ───────────────────────────────────────────────────────────────
  /// `GET` lists the account's linked family members; `POST` (multipart,
  /// for the `medical_files[]` attachments) adds a new one.
  static const String familyMembers = 'family-members';

  /// Updates one family member (multipart, same shape as [familyMembers]'s
  /// `POST`).
  static String familyMemberDetails(int id) => 'family-members/$id';

  // ─── Medical records ──────────────────────────────────────────────────────
  /// The account's lab-analysis history (`TestRequestModel`, `type:
  /// "analysis"`), shown on `TestHistoryScreen`.
  static const String analysesHistory = 'analyses/history';

  /// The account's x-ray history (`TestRequestModel`, `type: "xray"`), shown
  /// on `TestHistoryScreen`.
  static const String xraysHistory = 'xrays/history';

  /// The account's full prescription/medication history, shown on
  /// `MedicationsScreen`.
  static const String prescriptionsHistory = 'prescriptions/history';

  // ─── Notifications ────────────────────────────────────────────────────────
  /// The account's notifications feed, shown on `NotificationsScreen`.
  /// `title`/`body` come back as `easy_localization` dot-path keys (e.g.
  /// `"notifications.booking.completed.manager.title"`), not literal text —
  /// translate them client-side.
  static const String notifications = 'notifications';

  /// The account's unread notifications count — powers the bell badge on
  /// `HomeHeader`, fetched once `LayoutScreen` mounts.
  static const String notificationsUnreadCount = 'notifications/unread-count';

  /// Marks every notification as read (`NotificationsScreen`'s header
  /// action).
  static const String notificationsReadAll = 'notifications/read-all';

  /// Marks a single notification as read — fired when it's tapped.
  static String notificationRead(String id) => 'notifications/$id/read';

  // ─── Payments ─────────────────────────────────────────────────────────────
  /// The account's payment summary — `total_paid` + the itemized `invoices`
  /// (one per paid/pending appointment), shown on `PaymentsScreen`.
  static const String payments = 'payments';

  // ─── Device ───────────────────────────────────────────────────────────────
  /// Registers/refreshes this device's push-notification token.
  static const String fcmToken = 'fcm-token';

  /// Syncs the app's active UI language with the backend.
  static const String appLang = 'app-lang';
}
