import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallLocalPreview extends StatelessWidget {
  const CallLocalPreview({super.key, this.view, required this.cameraOn});

  final Widget? view;
  final bool cameraOn;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 16.h,
      end: 16.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 110.w,
          height: 160.h,
          color: Colors.black26,
          child: view != null && cameraOn
              ? view
              : Center(
                  child: Icon(Icons.person, color: Colors.white54, size: 32.sp),
                ),
        ),
      ),
    );
  }
}
