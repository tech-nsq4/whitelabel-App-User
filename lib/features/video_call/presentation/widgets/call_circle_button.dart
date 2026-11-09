import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_tap_effect.dart';

class CallCircleButton extends StatelessWidget {
  const CallCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = true,
    this.background,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background ??
              (active ? Colors.white24 : Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 26.sp),
      ),
    );
  }
}
