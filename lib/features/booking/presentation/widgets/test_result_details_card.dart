import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/appointment_model.dart';

/// The description/report/dates block on `TestResultDetailScreen`, below
/// the result image — everything [TestRequestModel] carries besides the
/// image itself and its status chip (shown separately, above this card).
class TestResultDetailsCard extends StatelessWidget {
  const TestResultDetailsCard({super.key, required this.request});

  final TestRequestModel request;

  Widget _paragraph(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: AppColors.mutedColor.themeColor)),
          4.height,
          AppText(value, fontSize: 12.5, color: AppColors.textPrimaryColor.themeColor, height: 1.7),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.mutedColor.themeColor)),
          Text(value,
              style: TextStyle(
                  fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final description = request.test?.description;
    final hasDescription = description != null && description.isNotEmpty;
    final hasNote = request.note != null && request.note!.isNotEmpty;
    final requestedAt = request.createdAt;
    final resultedAt = request.resultedAt;
    final dateTimeFormat = DateFormat('d MMMM y · h:mm a', locale);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDescription) _paragraph(LocaleKeys.booking_descriptionLabel.tr(), description),
          if (hasNote) _paragraph(LocaleKeys.booking_reportLabel.tr(), request.note!),
          if (requestedAt != null) _row(LocaleKeys.booking_requestDateLabel.tr(), dateTimeFormat.format(requestedAt)),
          if (resultedAt != null) _row(LocaleKeys.booking_resultDateLabel.tr(), dateTimeFormat.format(resultedAt)),
          if ((request.test?.price ?? 0) > 0)
            _row(
              LocaleKeys.booking_testPriceLabel.tr(),
              '${request.test!.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
            ),
        ],
      ),
    );
  }
}
