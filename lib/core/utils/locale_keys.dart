// ignore_for_file: constant_identifier_names
//
// Usage: LocaleKeys.auth_login.tr()

abstract class LocaleKeys {
  // ─── App ─────────────────────────────────────────────────────────────────
  static const String app_name = 'app_name';

  // ─── Splash ──────────────────────────────────────────────────────────────
  static const String splash_tagline = 'splash.tagline';

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
  static const String booking_bookTitle = 'booking.book_title';
  static const String booking_symptomPrompt = 'booking.symptom_prompt';
  static const String booking_symptomPromptSub = 'booking.symptom_prompt_sub';
  static const String booking_filterAll = 'booking.filter_all';
  static const String booking_allDoctors = 'booking.all_doctors';
  static const String booking_sortTitle = 'booking.sort_title';
  static const String booking_sortDefault = 'booking.sort_default';
  static const String booking_bookAction = 'booking.book_action';
  static const String booking_profileAction = 'booking.profile_action';
  static const String booking_chooseSpecialty = 'booking.choose_specialty';
  static const String booking_subSpecialtiesCount =
      'booking.sub_specialties_count';
  static const String booking_doctorsCount = 'booking.doctors_count';
  static const String booking_experienceYears = 'booking.experience_years';
  static const String booking_yearsValue = 'booking.years_value';
  static const String booking_experienceLabel = 'booking.experience_label';
  static const String booking_ratingLabel = 'booking.rating_label';
  static const String booking_feeLabel = 'booking.fee_label';
  static const String booking_nearestAvailable = 'booking.nearest_available';
  static const String booking_nearestAvailableLabel = 'booking.nearest_available_label';
  static const String booking_nextSlot = 'booking.next_slot';
  static const String booking_doctorProfileTitle = 'booking.doctor_profile_title';
  static const String booking_overallRatingFrom = 'booking.overall_rating_from';
  static const String booking_offerOnDoctor = 'booking.offer_on_doctor';
  static const String booking_reviewsTab = 'booking.reviews_tab';
  static const String booking_reviewsTitle = 'booking.reviews_title';
  static const String booking_viewAllReviews = 'booking.view_all_reviews';
  static const String booking_noReviews = 'booking.no_reviews';
  static const String booking_noClinics = 'booking.no_clinics';
  static const String booking_availableAppointments = 'booking.available_appointments';
  static const String booking_about = 'booking.about';
  static const String booking_clinicInfo = 'booking.clinic_info';
  static const String booking_clinics = 'booking.clinics';
  static const String booking_clinicsCount = 'booking.clinics_count';
  static const String booking_selectClinic = 'booking.select_clinic';
  static const String booking_appointmentsAction = 'booking.appointments_action';
  static const String booking_specializations = 'booking.specializations';
  static const String booking_subSpecializations = 'booking.sub_specializations';
  static const String booking_searchDoctorHint = 'booking.search_doctor_hint';
  static const String booking_searchSpecialtyHint = 'booking.search_specialty_hint';
  static const String booking_searchBranchHint = 'booking.search_branch_hint';
  static const String booking_sortClosestAvailable = 'booking.sort_closest_available';
  static const String booking_sortNearestDistance = 'booking.sort_nearest_distance';
  static const String booking_sortHighestRated = 'booking.sort_highest_rated';
  static const String booking_sortLowestPrice = 'booking.sort_lowest_price';
  static const String booking_locationUnavailable = 'booking.location_unavailable';
  static const String booking_byDoctor = 'booking.by_doctor';
  static const String booking_byDoctorSubtitle = 'booking.by_doctor_subtitle';
  static const String booking_branchesTitle = 'booking.branches_title';
  static const String booking_branchesCount = 'booking.branches_count';
  static const String booking_viewDoctors = 'booking.view_doctors';
  static const String booking_directions = 'booking.directions';
  static const String booking_favoritesTitle = 'booking.favorites_title';
  static const String booking_favoritesCount = 'booking.favorites_count';
  static const String booking_favoritesEmptyTitle = 'booking.favorites_empty_title';
  static const String booking_favoritesEmptyDesc = 'booking.favorites_empty_desc';
  static const String booking_chooseDateTime = 'booking.choose_date_time';
  static const String booking_calendarLegend = 'booking.calendar_legend';
  static const String booking_availableSlotsCount = 'booking.available_slots_count';
  static const String booking_noSlotsForDay = 'booking.no_slots_for_day';
  static const String booking_continueToPayment = 'booking.continue_to_payment';
  static const String booking_guestLoginTitle = 'booking.guest_login_title';
  static const String booking_guestLoginDescription = 'booking.guest_login_description';
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
  static const String booking_statusInProgress = 'booking.status_in_progress';
  static const String booking_statusAll = 'booking.status_all';
  static const String booking_orderIdLabel = 'booking.order_id_label';
  static const String booking_myBookingsTitle = 'booking.my_bookings_title';
  static const String booking_noBookingsTitle = 'booking.no_bookings_title';
  static const String booking_noBookingsDescription =
      'booking.no_bookings_description';
  static const String booking_prescriptionTitle = 'booking.prescription_title';
  static const String booking_attachedPrescription = 'booking.attached_prescription';
  static const String booking_dosageLabel = 'booking.dosage_label';
  static const String booking_durationLabel = 'booking.duration_label';
  static const String booking_testResultsTitle = 'booking.test_results_title';
  static const String booking_resultPending = 'booking.result_pending';
  static const String booking_resultReady = 'booking.result_ready';
  static const String booking_resultNormal = 'booking.result_normal';
  static const String booking_resultNotNormal = 'booking.result_not_normal';
  static const String booking_rescheduleAction = 'booking.reschedule_action';
  static const String booking_cancelAction = 'booking.cancel_action';
  static const String booking_bookAgainAction = 'booking.book_again_action';
  static const String booking_confirmReschedule = 'booking.confirm_reschedule';
  static const String booking_rescheduleSuccess = 'booking.reschedule_success';
  static const String booking_cancelDialogTitle = 'booking.cancel_dialog_title';
  static const String booking_cancelDialogMessage = 'booking.cancel_dialog_message';
  static const String booking_cancelDialogConfirm = 'booking.cancel_dialog_confirm';
  static const String booking_cancelSuccess = 'booking.cancel_success';
  static const String booking_rateAction = 'booking.rate_action';
  static const String booking_rateTitle = 'booking.rate_title';
  static const String booking_rateCommentHint = 'booking.rate_comment_hint';
  static const String booking_rateSubmit = 'booking.rate_submit';
  static const String booking_rateSuccess = 'booking.rate_success';
  static const String booking_yourRatingTitle = 'booking.your_rating_title';
  static const String booking_rateExcellent = 'booking.rate_excellent';
  static const String booking_rateVeryGood = 'booking.rate_very_good';
  static const String booking_rateGood = 'booking.rate_good';
  static const String booking_rateFair = 'booking.rate_fair';
  static const String booking_ratePoor = 'booking.rate_poor';
  static const String booking_discountAppliedTitle = 'booking.discount_applied_title';
  static const String booking_discountPromoLabel = 'booking.discount_promo_label';
  static const String booking_discountOfferLabel = 'booking.discount_offer_label';
  static const String booking_discountOriginalPrice = 'booking.discount_original_price';
  static const String booking_discountValueLabel = 'booking.discount_value_label';
  static const String booking_discountTotalAfter = 'booking.discount_total_after';
  static const String booking_discountSavedBadge = 'booking.discount_saved_badge';
  static const String booking_reportLabel = 'booking.report_label';
  static const String booking_descriptionLabel = 'booking.description_label';
  static const String booking_requestDateLabel = 'booking.request_date_label';
  static const String booking_resultDateLabel = 'booking.result_date_label';
  static const String booking_noResultYet = 'booking.no_result_yet';
  static const String booking_viewAppointmentAction = 'booking.view_appointment_action';
  static const String booking_testPriceLabel = 'booking.test_price_label';

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
  static const String common_today = 'common.today';
  static const String common_yesterday = 'common.yesterday';
  static const String common_tapToZoom = 'common.tap_to_zoom';
  static const String common_noDataTitle = 'common.no_data_title';
  static const String common_noDataDesc = 'common.no_data_desc';

  // ─── Coming Soon ──────────────────────────────────────────────────────────
  static const String comingSoon_badge = 'coming_soon.badge';
  static const String comingSoon_title = 'coming_soon.title';
  static const String comingSoon_whatsComing = 'coming_soon.whats_coming';
  static const String comingSoon_notifyMe = 'coming_soon.notify_me';
  static const String comingSoon_notifyDone = 'coming_soon.notify_done';
  static const String comingSoon_backHome = 'coming_soon.back_home';
  static const String comingSoon_telemedTitle = 'coming_soon.telemed_title';
  static const String comingSoon_telemedDescription =
      'coming_soon.telemed_description';
  static const String comingSoon_telemedHighlight1 =
      'coming_soon.telemed_highlight_1';
  static const String comingSoon_telemedHighlight2 =
      'coming_soon.telemed_highlight_2';
  static const String comingSoon_telemedHighlight3 =
      'coming_soon.telemed_highlight_3';

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
  static const String home_offers = 'home.offers';
  static const String home_offersSubtitle = 'home.offers_subtitle';
  static const String home_medicalRecord = 'home.medical_record';
  static const String home_bookings = 'home.bookings';
  static const String home_bookingsSubtitle = 'home.bookings_subtitle';
  static const String home_labResults = 'home.lab_results';
  static const String home_labResultsSubtitle = 'home.lab_results_subtitle';
  static const String home_labResultsBadge = 'home.lab_results_badge';
  static const String home_xray = 'home.xray';
  static const String home_xraySubtitle = 'home.xray_subtitle';
  static const String home_medications = 'home.medications';
  static const String home_medicationsSubtitle = 'home.medications_subtitle';
  static const String home_comingSoon = 'home.coming_soon';

  // ─── Lab ──────────────────────────────────────────────────────────────────
  static const String lab_resultsTitle = 'lab.results_title';
  static const String lab_xrayTitle = 'lab.xray_title';
  static const String lab_analysesEmptyTitle = 'lab.analyses_empty_title';
  static const String lab_analysesEmptyDescription = 'lab.analyses_empty_description';
  static const String lab_xrayEmptyTitle = 'lab.xray_empty_title';
  static const String lab_xrayEmptyDescription = 'lab.xray_empty_description';

  // ─── Medications ──────────────────────────────────────────────────────────
  static const String medications_title = 'medications.title';
  static const String medications_emptyTitle = 'medications.empty_title';
  static const String medications_emptyDescription = 'medications.empty_description';

  // ─── Notifications ────────────────────────────────────────────────────────
  static const String notifications_title = 'notifications.title';
  static const String notifications_emptyTitle = 'notifications.empty_title';
  static const String notifications_emptyDescription = 'notifications.empty_description';
  static const String notifications_markAllRead = 'notifications.mark_all_read';
  static const String notifications_bookingBookedManagerTitle =
      'notifications.booking.booked.manager.title';
  static const String notifications_bookingBookedManagerBody =
      'notifications.booking.booked.manager.body';
  static const String notifications_bookingAcceptedManagerTitle =
      'notifications.booking.accepted.manager.title';
  static const String notifications_bookingAcceptedManagerBody =
      'notifications.booking.accepted.manager.body';
  static const String notifications_bookingStartedManagerTitle =
      'notifications.booking.started.manager.title';
  static const String notifications_bookingStartedManagerBody =
      'notifications.booking.started.manager.body';
  static const String notifications_bookingCompletedManagerTitle =
      'notifications.booking.completed.manager.title';
  static const String notifications_bookingCompletedManagerBody =
      'notifications.booking.completed.manager.body';

  // ─── Chat ─────────────────────────────────────────────────────────────────
  static const String chat_online = 'chat.online';
  static const String chat_lastSeenToday = 'chat.last_seen_today';
  static const String chat_lastSeenDate = 'chat.last_seen_date';
  static const String chat_offline = 'chat.offline';
  static const String chat_inputHint = 'chat.input_hint';
  static const String chat_attachCamera = 'chat.attach_camera';
  static const String chat_attachGallery = 'chat.attach_gallery';
  static const String chat_attachLocation = 'chat.attach_location';
  static const String chat_locationMessageLabel = 'chat.location_message_label';
  static const String chat_emptyTitle = 'chat.empty_title';
  static const String chat_emptyDescription = 'chat.empty_description';
  static const String chat_selectedCount = 'chat.selected_count';
  static const String chat_deleteConfirmTitle = 'chat.delete_confirm_title';
  static const String chat_deleteConfirmMessage = 'chat.delete_confirm_message';
  static const String chat_deleteConfirmAction = 'chat.delete_confirm_action';

  // ─── Offers ───────────────────────────────────────────────────────────────
  static const String offers_title = 'offers.title';
  static const String offers_subtitle = 'offers.subtitle';
  static const String offers_endsOn = 'offers.ends_on';
  static const String offers_permanent = 'offers.permanent';
  static const String offers_bookNow = 'offers.book_now';
  static const String offers_bookWithDiscount = 'offers.book_with_discount';
  static const String offers_emptyTitle = 'offers.empty_title';
  static const String offers_emptyDescription = 'offers.empty_description';
  static const String offers_targetsPickDoctor = 'offers.targets_pick_doctor';
  static const String offers_targetsPickClinic = 'offers.targets_pick_clinic';
  static const String offers_targetsPickSpecialization = 'offers.targets_pick_specialization';
  static const String offers_targetsEmptyTitle = 'offers.targets_empty_title';
  static const String offers_targetsEmptyDescription = 'offers.targets_empty_description';

  // ─── Payments ─────────────────────────────────────────────────────────────
  static const String payments_title = 'payments.title';
  static const String payments_totalPaidLabel = 'payments.total_paid_label';
  static const String payments_invoicesTitle = 'payments.invoices_title';
  static const String payments_invoicesCount = 'payments.invoices_count';
  static const String payments_invoiceNumber = 'payments.invoice_number';
  static const String payments_forMember = 'payments.for_member';
  static const String payments_paid = 'payments.paid';
  static const String payments_payNow = 'payments.pay_now';
  static const String payments_emptyTitle = 'payments.empty_title';
  static const String payments_emptyDescription = 'payments.empty_description';
  static const String payments_checkoutTitle = 'payments.checkout_title';
  static const String payments_totalLabel = 'payments.total_label';
  static const String payments_payNowAction = 'payments.pay_now_action';
  static const String payments_promoCodeLabel = 'payments.promo_code_label';
  static const String payments_promoCodeHint = 'payments.promo_code_hint';
  static const String payments_promoApply = 'payments.promo_apply';
  static const String payments_promoInvalid = 'payments.promo_invalid';
  static const String payments_methodMada = 'payments.method_mada';
  static const String payments_methodWallet = 'payments.method_wallet';

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
  static const String settings_title = 'settings.title';
  static const String settings_sectionGeneral = 'settings.section_general';
  static const String settings_sectionAbout = 'settings.section_about';
  static const String settings_sectionAccount = 'settings.section_account';
  static const String settings_language = 'settings.language';
  static const String settings_changeLanguage = 'settings.change_language';
  static const String settings_changeLanguageSubtitle =
      'settings.change_language_subtitle';
  static const String settings_languageTitle = 'settings.language_title';
  static const String settings_arabic = 'settings.arabic';
  static const String settings_english = 'settings.english';
  static const String settings_terms = 'settings.terms';
  static const String settings_termsSubtitle = 'settings.terms_subtitle';
  static const String settings_privacy = 'settings.privacy';
  static const String settings_privacySubtitle = 'settings.privacy_subtitle';
  static const String settings_deleteAccount = 'settings.delete_account';
  static const String settings_deleteAccountSubtitle =
      'settings.delete_account_subtitle';
  static const String settings_deleteAccountMessage =
      'settings.delete_account_message';
  static const String settings_deleteAccountSent =
      'settings.delete_account_sent';
  static const String settings_logout = 'settings.logout';
  static const String settings_logoutSubtitle = 'settings.logout_subtitle';
  static const String settings_logoutDialogTitle =
      'settings.logout_dialog_title';
  static const String settings_logoutDialogMessage =
      'settings.logout_dialog_message';

  // ─── Contact ──────────────────────────────────────────────────────────────
  static const String contact_title = 'contact.title';
  static const String contact_subtitle = 'contact.subtitle';
  static const String contact_call = 'contact.call';
  static const String contact_whatsapp = 'contact.whatsapp';
  static const String contact_branches = 'contact.branches';
  static const String contact_channelsTitle = 'contact.channels_title';
  static const String contact_phoneLabel = 'contact.phone_label';
  static const String contact_whatsappLabel = 'contact.whatsapp_label';
  static const String contact_emailLabel = 'contact.email_label';
  static const String contact_formTitle = 'contact.form_title';
  static const String contact_name = 'contact.name';
  static const String contact_email = 'contact.email';
  static const String contact_subject = 'contact.subject';
  static const String contact_message = 'contact.message';
  static const String contact_send = 'contact.send';
  static const String contact_messageSent = 'contact.message_sent';

  // ─── Errors ───────────────────────────────────────────────────────────────
  static const String error_unauthorized = 'error.unauthorized';
  static const String error_notFound = 'error.not_found';
  static const String error_generic = 'error.generic';

  // ─── Vitals ───────────────────────────────────────────────────────────────
  static const String vitals_title = 'vitals.title';
  static const String vitals_description = 'vitals.description';
  static const String vitals_updatedOn = 'vitals.updated_on';
  static const String vitals_empty = 'vitals.empty';
  static const String vitals_pulse = 'vitals.pulse';
  static const String vitals_pulseUnit = 'vitals.pulse_unit';
  static const String vitals_bloodPressure = 'vitals.blood_pressure';
  static const String vitals_bloodPressureUnit = 'vitals.blood_pressure_unit';
  static const String vitals_temperature = 'vitals.temperature';
  static const String vitals_temperatureUnit = 'vitals.temperature_unit';
  static const String vitals_oxygen = 'vitals.oxygen';
  static const String vitals_oxygenUnit = 'vitals.oxygen_unit';
}
