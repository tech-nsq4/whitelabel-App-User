import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/primary_header.dart';

/// Shared brand header (logo over the primary-colour banner) used by both
/// the Login and Register screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: Center(
          child: Image.asset(
            AppImages.logo4,
            width: 220.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
