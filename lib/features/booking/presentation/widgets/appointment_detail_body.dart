import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/doctor_profile_model.dart';
import 'appointment_status_badge.dart';
import 'booking_slots_sheet.dart' show formatBookingDayLabel;
import 'booking_summary_card.dart';
import 'doctor_clinic_card.dart';
import 'doctor_profile_header.dart';

/// Scrollable content for `AppointmentDetailScreen`, once
/// `GET /appointments/{id}` has loaded. Reuses the same doctor/clinic
/// widgets `DoctorScreen` shows, plus [BookingSummaryCard] for the
/// date/time/patient/price recap.
class AppointmentDetailBody extends StatelessWidget {
  const AppointmentDetailBody({super.key, required this.appointment});

  final AppointmentModel appointment;

  Future<void> _openDirections(DoctorClinicModel clinic) async {
    try {
      await HelperMethods.openGoogleMaps(lat: clinic.lat!, lng: clinic.lng!);
    } catch (_) {
      AppOverlay.showError(LocaleKeys.error_generic.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final doctor = appointment.doctor;
    final clinic = doctor?.clinic;
    final date = appointment.date;
    final whenLabel = date == null ? '—' : '${formatBookingDayLabel(date, locale)} · ${appointment.timeLabel}';
    final hasCoordinates = clinic?.lat != null && clinic?.lng != null;

    return ListView(
      padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppointmentStatusBadge(status: appointment.status),
        ),
        14.height,
        if (doctor != null) DoctorProfileHeader(doctor: doctor),
        BookingSummaryCard(
          doctorName: doctor?.name ?? '',
          patientName: appointment.familyMember?.name,
          whenLabel: whenLabel,
          clinicName: clinic?.name,
          priceLabel:
              doctor == null ? '—' : '${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
        ),
        if (clinic != null) ...[
          14.height,
          Text(LocaleKeys.booking_clinicInfo.tr(),
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.mutedColor.themeColor)),
          10.height,
          DoctorClinicCard(clinic: clinic),
          if (hasCoordinates)
            CustomButton(
              title: LocaleKeys.booking_directions.tr(),
              isOutlined: true,
              onTap: () => _openDirections(clinic),
            ),
        ],
      ],
    );
  }
}
