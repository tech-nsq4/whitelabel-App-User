import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;
  final TextOverflow? overflow;

  /// Use the display font (Readex Pro) instead of the body font — for
  /// headings, numbers, and buttons, matching the design's `.d1/.d2/.h/.num`
  /// text styles.
  final bool isHeading;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isHeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        height: height,
        fontFamily: isHeading ? AppFonts.headingFont : AppFonts.bodyFont,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? Colors.black,
      ),
    );
  }
}
