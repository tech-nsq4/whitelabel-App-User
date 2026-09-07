import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

/// Read-only 5-star rating — each star is filled, half-filled or empty
/// according to [value] (0–[count]).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.count = 5,
    this.size = 12,
    this.color,
    this.spacing = 1,
  });

  final double value;
  final int count;
  final double size;
  final Color? color;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? AppColors.accentGold.themeColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= count; i++) ...[
          if (i > 1) SizedBox(width: spacing.w),
          Icon(_iconFor(value - (i - 1)), color: starColor, size: size.sp),
        ],
      ],
    );
  }

  IconData _iconFor(double fill) {
    if (fill >= 0.75) return Icons.star_rounded;
    if (fill >= 0.25) return Icons.star_half_rounded;
    return Icons.star_border_rounded;
  }
}
