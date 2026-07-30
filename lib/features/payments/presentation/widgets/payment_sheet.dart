import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

/// Generic "pay for X" bottom sheet — used from bookings, telemed,
/// home-care, invoices, anywhere a checkout step is needed.
Future<bool?> showPaymentSheet(
  BuildContext context, {
  required String title,
  required String detail,
  required String amountLabel,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => PaymentSheet(title: title, detail: detail, amountLabel: amountLabel),
  );
}

class PaymentSheet extends StatefulWidget {
  const PaymentSheet({
    super.key,
    required this.title,
    required this.detail,
    required this.amountLabel,
  });

  final String title;
  final String detail;
  final String amountLabel;

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final options = [
      ('Apple Pay', Icons.apple),
      ('مدى', Icons.credit_card),
      ('محفظتي', Icons.account_balance_wallet_outlined),
    ];

    return Container(
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
          AppText('الدفع',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          16.height,
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(widget.title,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                4.height,
                AppText(widget.detail,
                    fontSize: 11, color: AppColors.mutedColor.themeColor),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('الإجمالي',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    AppText(widget.amountLabel,
                        isHeading: true,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor.themeColor),
                  ],
                ),
              ],
            ),
          ),
          16.height,
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    color: _selected == i
                        ? AppColors.textPrimaryColor.themeColor
                        : AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                        color: _selected == i
                            ? Colors.transparent
                            : AppColors.dividerColor.themeColor),
                  ),
                  child: Row(
                    children: [
                      Icon(options[i].$2,
                          size: 20.sp,
                          color: _selected == i
                              ? Colors.white
                              : AppColors.textPrimaryColor.themeColor),
                      10.width,
                      AppText(options[i].$1,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selected == i
                              ? Colors.white
                              : AppColors.textPrimaryColor.themeColor),
                      const Spacer(),
                      if (_selected == i)
                        const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          8.height,
          CustomButton(
            title: 'ادفع الآن',
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
