import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../booking/data/models/doctor_model.dart';

class LiveCallScreen extends StatefulWidget {
  const LiveCallScreen({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends State<LiveCallScreen> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _elapsed {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08120F),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: [const Color(0xFF123A32), const Color(0xFF08120F)],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 104.r,
                  height: 104.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.themeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primaryColor.themeColor
                              .withValues(alpha: 0.14),
                          blurRadius: 40,
                          spreadRadius: 12),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.doctor.avatarLetter,
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 38.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                16.height,
                Text(widget.doctor.name,
                    style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                4.height,
                Text(widget.doctor.specialty,
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Positioned(
            top: 56.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor.themeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text('مباشر',
                        style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  8.width,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(_elapsed,
                        style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ]),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _callBtn(Icons.mic_off_rounded, onTap: () {}),
                13.width,
                _callBtn(Icons.chat_bubble_outline_rounded, onTap: () {}),
                13.width,
                _callBtn(
                  Icons.call_end_rounded,
                  bg: AppColors.errorColor.themeColor,
                  large: true,
                  onTap: () => Navigator.pop(context),
                ),
                13.width,
                _callBtn(Icons.videocam_off_rounded, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _callBtn(IconData icon, {Color? bg, bool large = false, required VoidCallback onTap}) {
    final size = large ? 62.r : 50.r;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg ?? Colors.white.withValues(alpha: 0.11),
          shape: BoxShape.circle,
          border: bg == null ? Border.all(color: Colors.white.withValues(alpha: 0.14)) : null,
        ),
        child: Icon(icon, color: Colors.white, size: large ? 26 : 20),
      ),
    );
  }
}
