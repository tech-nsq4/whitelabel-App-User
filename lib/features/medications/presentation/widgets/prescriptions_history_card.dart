import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/list_row_tile.dart';
import '../../../booking/data/models/appointment_model.dart';

/// One row per [PrescriptionModel] on `MedicationsScreen` — same look as
/// the booking feature's `PrescriptionCard`, plus the date on the trailing
/// side since this list spans every appointment, not just one.
class PrescriptionsHistoryCard extends StatelessWidget {
  const PrescriptionsHistoryCard({super.key, required this.prescriptions});

  final List<PrescriptionModel> prescriptions;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return AppCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          for (var i = 0; i < prescriptions.length; i++)
            ListRowTile(
              icon: AppSvgIcons.pill,
              title: prescriptions[i].drugName,
              subtitle: '${LocaleKeys.booking_dosageLabel.tr()}: ${prescriptions[i].dosage} · '
                  '${LocaleKeys.booking_durationLabel.tr()}: ${prescriptions[i].duration}',
              showChevron: false,
              showDivider: i != prescriptions.length - 1,
              trailing: prescriptions[i].date == null
                  ? null
                  : AppText(
                      DateFormat('d MMM', locale).format(prescriptions[i].date!),
                      fontSize: 10,
                      color: AppColors.mutedColor.themeColor,
                    ),
            ),
        ],
      ),
    );
  }
}
