import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image/custom_image.dart';

/// Read-only thumbnails of a member's already-uploaded `medical_files` URLs
/// — shown on the edit form above [MedicalFilesPicker] (there's no
/// delete-attachment endpoint yet, so these aren't removable here).
class ExistingMedicalFiles extends StatelessWidget {
  const ExistingMedicalFiles({super.key, required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        for (final url in urls) CustomImage(image: url, width: 64.r, height: 64.r, radius: 14.r),
      ],
    );
  }
}
