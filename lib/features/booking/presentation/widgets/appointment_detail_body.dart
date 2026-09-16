import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/price_text.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_discount_card.dart';
import 'appointment_status_badge.dart';
import 'booking_slots_sheet.dart' show formatBookingDayLabel;
import 'booking_summary_card.dart';
import 'doctor_clinic_card.dart';
import 'doctor_profile_header.dart';
import 'prescription_card.dart';
import 'rating_summary_card.dart';
import 'test_results_card.dart';

/// Scrollable content for `AppointmentDetailScreen`, once
/// `GET /appointments/{id}` has loaded. Reuses the same doctor/clinic
/// widgets `DoctorScreen` shows, plus [BookingSummaryCard] for the
/// date/time/patient/price recap.
class AppointmentDetailBody extends StatelessWidget {
  const AppointmentDetailBody({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final doctor = appointment.doctor;
    final clinic = doctor?.clinic;
    final date = appointment.date;
    final whenLabel = date == null ? '—' : '${formatBookingDayLabel(date, locale)} · ${appointment.timeLabel}';
    final priceLabel = appointment.finalPrice != null
        ? formatPriceLabel(appointment.finalPrice!)
        : doctor == null
            ? '—'
            : formatPriceLabel(doctor.price);
    final strikePriceLabel = appointment.hasDiscount && appointment.originalPrice != null
        ? formatPriceLabel(appointment.originalPrice!)
        : null;

    return ListView(
      padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppointmentStatusBadge(status: appointment.status),
        ),
        14.height,
        if (doctor != null)
          DoctorProfileHeader(
            doctor: doctor,
            paidPrice: appointment.finalPrice,
            onChatTap: () => Navigator.pushNamed(context, Routes.chat, arguments: {
              'doctorId': doctor.id,
              'doctorName': doctor.name,
              'doctorImage': doctor.image,
            }),
          ),
        BookingSummaryCard(
          orderId: appointment.id,
          doctorName: doctor?.name ?? '',
          patientName: appointment.familyMember?.name,
          whenLabel: whenLabel,
          clinicName: clinic?.name,
          priceLabel: priceLabel,
          strikePriceLabel: strikePriceLabel,
        ),
        if (appointment.hasDiscount) ...[
          14.height,
          AppointmentDiscountCard(appointment: appointment),
        ],
        if (clinic != null) ...[
          14.height,
          Text(LocaleKeys.booking_clinicInfo.tr(),
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.mutedColor.themeColor)),
          10.height,
          DoctorClinicCard(clinic: clinic, showFavorite: false),
        ],
        if (appointment.status == 'completed') ...[
          if (appointment.prescriptionImage != null || appointment.prescriptions.isNotEmpty) ...[
            14.height,
            Text(LocaleKeys.booking_prescriptionTitle.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            PrescriptionCard(appointment: appointment),
          ],
          if (appointment.testRequests.isNotEmpty) ...[
            14.height,
            Text(LocaleKeys.booking_testResultsTitle.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            TestResultsCard(requests: appointment.testRequests),
          ],
          if (appointment.isRated) ...[
            14.height,
            Text(LocaleKeys.booking_yourRatingTitle.tr(),
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            RatingSummaryCard(rate: appointment.rate!, comment: appointment.comment),
          ],
        ],
      ],
    );
  }
}
