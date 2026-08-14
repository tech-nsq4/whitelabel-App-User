// ignore_for_file: constant_identifier_names
//
// Usage: LocaleKeys.auth_login.tr()

abstract class LocaleKeys {
  // ─── App ─────────────────────────────────────────────────────────────────
  static const String app_name = 'app_name';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String auth_tagline = 'auth.tagline';
  static const String auth_login = 'auth.login';
  static const String auth_register = 'auth.register';
  static const String auth_email = 'auth.email';
  static const String auth_password = 'auth.password';
  static const String auth_dontHaveAccount = 'auth.dont_have_account';
  static const String auth_alreadyHaveAccount = 'auth.already_have_account';
  static const String auth_or = 'auth.or';
  static const String auth_continueAsGuest = 'auth.continue_as_guest';
  static const String auth_registerSubtitle = 'auth.register_subtitle';
  static const String auth_loginSubtitle = 'auth.login_subtitle';
  static const String auth_phone = 'auth.phone';
  static const String auth_name = 'auth.name';
  static const String auth_signIn = 'auth.sign_in';
  static const String auth_otpTitle = 'auth.otp_title';
  static const String auth_otpSubtitle = 'auth.otp_subtitle';
  static const String auth_otpConfirm = 'auth.otp_confirm';
  static const String auth_otpResend = 'auth.otp_resend';
  static const String auth_otpResendIn = 'auth.otp_resend_in';
  static const String auth_otpChangeNumber = 'auth.otp_change_number';

  // ─── Booking ──────────────────────────────────────────────────────────────
  static const String booking_chooseSpecialty = 'booking.choose_specialty';
  static const String booking_subSpecialtiesCount =
      'booking.sub_specialties_count';
  static const String booking_doctorsCount = 'booking.doctors_count';
  static const String booking_experienceYears = 'booking.experience_years';
  static const String booking_doctorProfileTitle = 'booking.doctor_profile_title';
  static const String booking_availableAppointments = 'booking.available_appointments';
  static const String booking_about = 'booking.about';
  static const String booking_clinicInfo = 'booking.clinic_info';
  static const String booking_searchDoctorHint = 'booking.search_doctor_hint';
  static const String booking_filterConsultant = 'booking.filter_consultant';
  static const String booking_filterTopRated = 'booking.filter_top_rated';
  static const String booking_filterNearest = 'booking.filter_nearest';
  static const String booking_locationUnavailable = 'booking.location_unavailable';
  static const String booking_byDoctor = 'booking.by_doctor';
  static const String booking_byDoctorSubtitle = 'booking.by_doctor_subtitle';
  static const String booking_branchesTitle = 'booking.branches_title';
  static const String booking_branchesCount = 'booking.branches_count';
  static const String booking_viewDoctors = 'booking.view_doctors';
  static const String booking_directions = 'booking.directions';
  static const String booking_chooseDateTime = 'booking.choose_date_time';
  static const String booking_calendarLegend = 'booking.calendar_legend';
  static const String booking_availableSlotsCount = 'booking.available_slots_count';
  static const String booking_noSlotsForDay = 'booking.no_slots_for_day';
  static const String booking_continueToPayment = 'booking.continue_to_payment';
  static const String booking_doctorLabel = 'booking.doctor_label';
  static const String booking_appointmentLabel = 'booking.appointment_label';
  static const String booking_branchLabel = 'booking.branch_label';
  static const String booking_priceLabel = 'booking.price_label';
  static const String booking_noAppointmentsTitle = 'booking.no_appointments_title';
  static const String booking_noAppointmentsDescription = 'booking.no_appointments_description';
  static const String booking_bookForLabel = 'booking.book_for_label';
  static const String booking_bookForSelf = 'booking.book_for_self';
  static const String booking_patientLabel = 'booking.patient_label';
  static const String booking_appointmentDetailsTitle = 'booking.appointment_details_title';
  static const String booking_statusPending = 'booking.status_pending';
  static const String booking_statusConfirmed = 'booking.status_confirmed';
  static const String booking_statusCompleted = 'booking.status_completed';
  static const String booking_statusCancelled = 'booking.status_cancelled';

  // ─── Calendar ─────────────────────────────────────────────────────────────
  static const String calendar_sat = 'calendar.sat';
  static const String calendar_sun = 'calendar.sun';
  static const String calendar_mon = 'calendar.mon';
  static const String calendar_tue = 'calendar.tue';
  static const String calendar_wed = 'calendar.wed';
  static const String calendar_thu = 'calendar.thu';
  static const String calendar_fri = 'calendar.fri';

  // ─── Common ───────────────────────────────────────────────────────────────
  static const String common_cancel = 'common.cancel';
  static const String common_close = 'common.close';
  static const String common_search = 'common.search';
  static const String common_retry = 'common.retry';
  static const String common_confirm = 'common.confirm';
  static const String common_currency = 'common.currency';

  // ─── Family ───────────────────────────────────────────────────────────────
  static const String family_title = 'family.title';
  static const String family_membersCount = 'family.members_count';
  static const String family_addMember = 'family.add_member';
  static const String family_addMemberSheetTitle = 'family.add_member_sheet_title';
  static const String family_addMemberSheetSubtitle = 'family.add_member_sheet_subtitle';
  static const String family_idNumber = 'family.id_number';
  static const String family_medicalFiles = 'family.medical_files';
  static const String family_addPhoto = 'family.add_photo';
  static const String family_addSuccess = 'family.add_success';
  static const String family_ageLabel = 'family.age_label';
  static const String family_medicalFilesCount = 'family.medical_files_count';
  static const String family_editMemberSheetTitle = 'family.edit_member_sheet_title';
  static const String family_editMemberSheetSubtitle = 'family.edit_member_sheet_subtitle';
  static const String family_updateSuccess = 'family.update_success';
  static const String family_existingFiles = 'family.existing_files';
  static const String family_editMember = 'family.edit_member';
  static const String family_guestTitle = 'family.guest_title';
  static const String family_guestDescription = 'family.guest_description';

  // ─── Validation ───────────────────────────────────────────────────────────
  static const String validation_required = 'validation.required';
  static const String validation_invalidEmail = 'validation.invalid_email';
  static const String validation_shortPassword = 'validation.short_password';
  static const String validation_invalidPhone = 'validation.invalid_phone';
  static const String validation_invalidOtp = 'validation.invalid_otp';
  static const String validation_invalidNumber = 'validation.invalid_number';

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const String onboarding_skip = 'onboarding.skip';
  static const String onboarding_next = 'onboarding.next';
  static const String onboarding_getStarted = 'onboarding.get_started';
  static const String onboarding_slide1_title = 'onboarding.slide1_title';
  static const String onboarding_slide1_subtitle = 'onboarding.slide1_subtitle';
  static const String onboarding_slide2_title = 'onboarding.slide2_title';
  static const String onboarding_slide2_subtitle = 'onboarding.slide2_subtitle';
  static const String onboarding_slide3_title = 'onboarding.slide3_title';
  static const String onboarding_slide3_subtitle = 'onboarding.slide3_subtitle';
  static const String onboarding_slide4_title = 'onboarding.slide4_title';
  static const String onboarding_slide4_subtitle = 'onboarding.slide4_subtitle';

  // ─── Navigation ───────────────────────────────────────────────────────────
  static const String nav_home = 'nav.home';
  static const String nav_more = 'nav.more';
  static const String nav_medicalFile = 'nav.medical_file';
  static const String nav_family = 'nav.family';
  static const String nav_account = 'nav.account';

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String home_welcome = 'home.welcome';
  static const String home_greetingMorning = 'home.greeting_morning';
  static const String home_familyName = 'home.family_name';
  static const String home_healthCardLabel = 'home.health_card_label';
  static const String home_orgName = 'home.org_name';
  static const String home_patientName = 'home.patient_name';
  static const String home_patientId = 'home.patient_id';
  static const String home_bloodTypeLabel = 'home.blood_type_label';
  static const String home_ageUnit = 'home.age_unit';
  static const String home_heightUnit = 'home.height_unit';
  static const String home_weightUnit = 'home.weight_unit';
  static const String home_addToWallet = 'home.add_to_wallet';
  static const String home_aiAssistantTitle = 'home.ai_assistant_title';
  static const String home_aiAssistantBadge = 'home.ai_assistant_badge';
  static const String home_aiAssistantDesc = 'home.ai_assistant_desc';
  static const String home_upcomingAppointment = 'home.upcoming_appointment';
  static const String home_noUpcomingAppointment = 'home.no_upcoming_appointment';
  static const String home_services = 'home.services';
  static const String home_seeAll = 'home.see_all';
  static const String home_bookAppointment = 'home.book_appointment';
  static const String home_bookAppointmentSubtitle =
      'home.book_appointment_subtitle';
  static const String home_consultation = 'home.consultation';
  static const String home_consultationSubtitle =
      'home.consultation_subtitle';
  static const String home_emergency = 'home.emergency';
  static const String home_emergencySubtitle = 'home.emergency_subtitle';
  static const String home_medicalRecord = 'home.medical_record';
  static const String home_visits = 'home.visits';
  static const String home_visitsSubtitle = 'home.visits_subtitle';
  static const String home_labResults = 'home.lab_results';
  static const String home_labResultsSubtitle = 'home.lab_results_subtitle';
  static const String home_labResultsBadge = 'home.lab_results_badge';
  static const String home_xray = 'home.xray';
  static const String home_xraySubtitle = 'home.xray_subtitle';
  static const String home_medications = 'home.medications';
  static const String home_medicationsSubtitle = 'home.medications_subtitle';
  static const String home_comingSoon = 'home.coming_soon';

  // ─── More ─────────────────────────────────────────────────────────────────
  static const String more_title = 'more.title';
  static const String more_profileCardSubtitle = 'more.profile_card_subtitle';

  // ─── Profile ──────────────────────────────────────────────────────────────
  static const String profile_title = 'profile.title';
  static const String profile_loginNow = 'profile.login_now';
  static const String profile_completeTitle = 'profile.complete_title';
  static const String profile_completeSubtitle = 'profile.complete_subtitle';
  static const String profile_dateOfBirth = 'profile.date_of_birth';
  static const String profile_height = 'profile.height';
  static const String profile_weight = 'profile.weight';
  static const String profile_saveContinue = 'profile.save_continue';
  static const String profile_guestName = 'profile.guest_name';
  static const String profile_guestSubtitle = 'profile.guest_subtitle';
  static const String profile_saveChanges = 'profile.save_changes';
  static const String profile_updateSuccess = 'profile.update_success';

  // ─── Settings ─────────────────────────────────────────────────────────────
  static const String settings_changeLanguage = 'settings.change_language';
  static const String settings_changeLanguageSubtitle =
      'settings.change_language_subtitle';
  static const String settings_languageTitle = 'settings.language_title';
  static const String settings_arabic = 'settings.arabic';
  static const String settings_english = 'settings.english';
  static const String settings_logout = 'settings.logout';
  static const String settings_logoutSubtitle = 'settings.logout_subtitle';
  static const String settings_logoutDialogTitle =
      'settings.logout_dialog_title';
  static const String settings_logoutDialogMessage =
      'settings.logout_dialog_message';

  // ─── Errors ───────────────────────────────────────────────────────────────
  static const String error_unauthorized = 'error.unauthorized';
  static const String error_notFound = 'error.not_found';
  static const String error_generic = 'error.generic';
}
