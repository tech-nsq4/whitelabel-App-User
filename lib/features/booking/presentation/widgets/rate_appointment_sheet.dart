import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

/// The 1-5 stars + optional comment picked on [RateAppointmentSheet].
class RateResult {
  const RateResult({required this.rate, this.comment});

  final int rate;
  final String? comment;
}

/// "Rate your appointment" bottom sheet — `POST /appointments/{id}/rate`'s
/// two fields, star-picker styled the same way as the (still mock)
/// `FeedbackScreen`. Resolves `null` if dismissed without submitting.
Future<RateResult?> showRateAppointmentSheet(BuildContext context, {String? doctorName}) {
  return showModalBottomSheet<RateResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => RateAppointmentSheet(doctorName: doctorName),
  );
}

class RateAppointmentSheet extends StatefulWidget {
  const RateAppointmentSheet({super.key, this.doctorName});

  final String? doctorName;

  @override
  State<RateAppointmentSheet> createState() => _RateAppointmentSheetState();
}

class _RateAppointmentSheetState extends State<RateAppointmentSheet> {
  int _rate = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accentGold.themeColor;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 18.h),
                decoration: BoxDecoration(
                  color: AppColors.hintColor.themeColor,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            AppText(LocaleKeys.booking_rateTitle.tr(),
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            if (widget.doctorName != null && widget.doctorName!.isNotEmpty) ...[
              4.height,
              AppText(widget.doctorName!, fontSize: 11.5, color: AppColors.mutedColor.themeColor),
            ],
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () => setState(() => _rate = i),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Icon(
                        i <= _rate ? Icons.star_rounded : Icons.star_border_rounded,
                        color: gold,
                        size: 34.sp,
                      ),
                    ),
                  ),
              ],
            ),
            20.height,
            CustomTextField(
              hint: LocaleKeys.booking_rateCommentHint.tr(),
              controller: _commentController,
              maxLines: 4,
            ),
            20.height,
            CustomButton(
              title: LocaleKeys.booking_rateSubmit.tr(),
              color: _rate == 0 ? AppColors.hintColor.themeColor : null,
              onTap: _rate == 0
                  ? () {}
                  : () {
                      final comment = _commentController.text.trim();
                      Navigator.pop(
                        context,
                        RateResult(rate: _rate, comment: comment.isEmpty ? null : comment),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
