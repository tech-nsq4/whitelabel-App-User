import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/locale_keys.dart';

String formatPriceLabel(double amount) {
  final isWhole = amount.truncateToDouble() == amount;
  return '${amount.toStringAsFixed(isWhole ? 0 : 2)} ${LocaleKeys.common_currency.tr()}';
}

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.amount,
    this.strikeAmount,
    this.fontSize = 12,
    this.strikeFontSize,
    this.color,
    this.strikeColor,
    this.fontWeight = FontWeight.w700,
    this.isHeading = false,
    this.maxLines = 1,
    this.textAlign,
  });

  final double amount;
  final double? strikeAmount;
  final double fontSize;
  final double? strikeFontSize;
  final Color? color;
  final Color? strikeColor;
  final FontWeight fontWeight;
  final bool isHeading;
  final int maxLines;
  final TextAlign? textAlign;

  bool get _showStrike => strikeAmount != null && strikeAmount! > amount;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primaryColor.themeColor;
    final fontFamily = isHeading ? AppFonts.headingFont : AppFonts.bodyFont;

    final activeSpan = TextSpan(
      text: formatPriceLabel(amount),
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: activeColor,
      ),
    );

    if (!_showStrike) {
      return Text.rich(activeSpan,
          maxLines: maxLines, overflow: TextOverflow.ellipsis, textAlign: textAlign);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${formatPriceLabel(strikeAmount!)}  ',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: (strikeFontSize ?? fontSize - 1.5).sp,
              fontWeight: FontWeight.w600,
              color: strikeColor ?? AppColors.mutedColor.themeColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          activeSpan,
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}
