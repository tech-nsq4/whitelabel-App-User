class ApiEndpoints {
  ApiEndpoints._();

  static const String rootUrl = 'https://white-label.nsq4.sa/api/';
  static const String baseUrl = '${rootUrl}user/';

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const String splashes = 'splashes';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String sendOtp = 'auth/otp';
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

  /// A doctor's patient reviews (1-5 stars + an optional comment), shown on
  /// `DoctorScreen`'s "reviews" tab.
  static String doctorReviews(int doctorId) => 'doctors/$doctorId/reviews';

  /// `GET` lists the current user's booked appointments (powers the home
  /// screen's "upcoming appointment" card); `POST` books a new one from
  /// `BookingSlotsSheet`.
  static const String appointments = 'appointments';

  static const String appointmentQuote = 'appointments/quote';

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

  // ─── Chat ─────────────────────────────────────────────────────────────────
  static const String chatImageUpload = 'chat/images';
  static const String chatNotifications = '${rootUrl}chat/notifications';

  // ─── Offers ───────────────────────────────────────────────────────────────
  /// Active promotional offers — shown on `OffersScreen` (reached from the
  /// home screen's services grid) and, where `show_on_home` is true, meant
  /// to be highlighted on the home screen itself.
  static const String offers = 'offers';

  /// A single offer's full record (same shape as one element of [offers]) —
  /// fetched when a home banner with `type: "offer"` is tapped, so its
  /// booking flow has the real `scope`/`doctors`/`clinics`/`specializations`.
  static String offerDetails(int id) => 'offers/$id';

  // ─── Banners ──────────────────────────────────────────────────────────────
  /// The home screen's promotional carousel. Each item carries a `type`
  /// (`offer` / `doctor` / `clinic` / `none`) plus a `target_id` that the app
  /// resolves to the matching screen when the banner is tapped.
  static const String banners = 'banners';

  // ─── Favorites ────────────────────────────────────────────────────────────
  /// `GET` lists the account's favorite clinics/branches (same shape as
  /// [branches], each with `is_favorite`). Shown on `FavoritesScreen`.
  static const String favoriteBranches = 'favorite-branches';

  /// `POST` adds the clinic to favorites, `DELETE` removes it — fired by the
  /// heart toggle on `BranchCard`.
  static String favoriteBranch(int clinicId) => 'favorite-branches/$clinicId';

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

  // ─── Contact ──────────────────────────────────────────────────────────────
  /// The org's public contact channels (`phone` / `whatsapp_number` /
  /// `email`) shown on `ContactScreen` — must be reachable for guests too.
  static const String contactInfo = 'contact-info';

  /// `POST` sends a contact-form message (`name` / `email` / `subject` /
  /// `message`).
  static const String contactMessages = 'contact-messages';

  // ─── Device ───────────────────────────────────────────────────────────────
  /// Registers/refreshes this device's push-notification token.
  static const String fcmToken = 'fcm-token';

  /// Syncs the app's active UI language with the backend.
  static const String appLang = 'app-lang';

  // ─── Static pages ─────────────────────────────────────────────────────────
  /// A CMS content page by slug (e.g. `terms-and-conditions`,
  /// `privacy-policy`). `data.translations.{title,description}.{ar,en}` carry
  /// the localized copy — the top-level `title`/`description` are not
  /// reliably localized, so resolve from `translations`.
  static String page(String slug) => 'pages/$slug';

  static const String pageTermsSlug = 'terms-and-conditions';
  static const String pagePrivacySlug = 'privacy-policy';
}
