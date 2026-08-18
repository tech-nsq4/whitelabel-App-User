import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/image/custom_image.dart' show openBottomSheet;
import '../../../../core/widgets/list_row_tile.dart';
import '../../data/models/appointment_model.dart';
import 'booking_slots_sheet.dart' show formatBookingDayLabel;

/// The prescription attached to a completed appointment on
/// `AppointmentDetailScreen` — the optional scanned/signed file
/// (`prescription_image`/`prescription_date`) plus the itemized medications
/// list (`prescriptions`), both from `GET /appointments/{id}`. Callers only
/// build this when at least one of the two is present.
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final image = appointment.prescriptionImage;
    final date = appointment.prescriptionDate;
    final hasImage = image != null && image.isNotEmpty;
    final drugs = appointment.prescriptions;

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          if (hasImage)
            ListRowTile(
              icon: AppSvgIcons.document,
              title: LocaleKeys.booking_attachedPrescription.tr(),
              subtitle: date == null ? null : formatBookingDayLabel(date, locale),
              showDivider: drugs.isNotEmpty,
              onTap: () => openBottomSheet(context, NetworkImage(image)),
            ),
          for (var i = 0; i < drugs.length; i++)
            ListRowTile(
              icon: AppSvgIcons.pill,
              title: drugs[i].drugName,
              subtitle: '${LocaleKeys.booking_dosageLabel.tr()}: ${drugs[i].dosage} · '
                  '${LocaleKeys.booking_durationLabel.tr()}: ${drugs[i].duration}',
              showChevron: false,
              showDivider: i != drugs.length - 1,
            ),
        ],
      ),
    );
  }
}
