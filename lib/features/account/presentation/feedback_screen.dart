import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accentGold.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'رأيك يهمنا', subtitle: 'قيّم آخر زيارة'),
            AppCard(
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  AppText('زيارتك مع', fontSize: 11.5, color: AppColors.mutedColor.themeColor),
                  6.height,
                  AppText('د. خالد العتيبي',
                      isHeading: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () => setState(() => _rating = i),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Icon(
                              i <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                              color: gold,
                              size: 30.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            AppCard(
              margin: EdgeInsets.only(bottom: 16.h),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'ما الذي يمكننا تحسينه؟'),
              ),
            ),
            CustomButton(
              title: 'إرسال التقييم',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('شكرًا لك — وصلنا تقييمك')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
