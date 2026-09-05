import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

class PaymentSheetResult {
  const PaymentSheetResult({this.promoCode});

  final String? promoCode;
}

Future<PaymentSheetResult?> showPaymentSheet(
  BuildContext context, {
  required String title,
  required String detail,
  required String amountLabel,
  String? strikeAmountLabel,
  bool promoCodeEnabled = false,
}) {
  return showModalBottomSheet<PaymentSheetResult>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => PaymentSheet(
      title: title,
      detail: detail,
      amountLabel: amountLabel,
      strikeAmountLabel: strikeAmountLabel,
      promoCodeEnabled: promoCodeEnabled,
    ),
  );
}

class PaymentSheet extends StatefulWidget {
  const PaymentSheet({
    super.key,
    required this.title,
    required this.detail,
    required this.amountLabel,
    this.strikeAmountLabel,
    this.promoCodeEnabled = false,
  });

  final String title;
  final String detail;
  final String amountLabel;
  final String? strikeAmountLabel;
  final bool promoCodeEnabled;

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  int _selected = 0;
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      ('Apple Pay', Icons.apple),
      (LocaleKeys.payments_methodMada.tr(), Icons.credit_card),
      (LocaleKeys.payments_methodWallet.tr(), Icons.account_balance_wallet_outlined),
    ];

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
            AppText(LocaleKeys.payments_checkoutTitle.tr(),
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
                      AppText(LocaleKeys.payments_totalLabel.tr(),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      _TotalAmount(
                        amountLabel: widget.amountLabel,
                        strikeAmountLabel: widget.strikeAmountLabel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.promoCodeEnabled) ...[
              16.height,
              AppText(LocaleKeys.payments_promoCodeLabel.tr(),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor),
              8.height,
              CustomTextField(
                controller: _promoController,
                hint: LocaleKeys.payments_promoCodeHint.tr(),
              ),
            ],
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
              title: LocaleKeys.payments_payNowAction.tr(),
              onTap: () {
                final code = _promoController.text.trim();
                Navigator.pop(
                  context,
                  PaymentSheetResult(promoCode: code.isEmpty ? null : code),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalAmount extends StatelessWidget {
  const _TotalAmount({required this.amountLabel, this.strikeAmountLabel});

  final String amountLabel;
  final String? strikeAmountLabel;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    final activeSpan = TextSpan(
      text: amountLabel,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: primary),
    );

    if (strikeAmountLabel == null) {
      return Text.rich(activeSpan);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$strikeAmountLabel  ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          activeSpan,
        ],
      ),
    );
  }
}
