import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class AskDoctorScreen extends StatefulWidget {
  const AskDoctorScreen({super.key});

  @override
  State<AskDoctorScreen> createState() => _AskDoctorScreenState();
}

class _AskDoctorScreenState extends State<AskDoctorScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    _controller.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('أُرسل سؤالك — يصلك الرد خلال 24 ساعة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(
                title: 'اسأل طبيبك', subtitle: 'استفسار مجاني · رد خلال 24 ساعة'),
            AppCard(
              margin: EdgeInsets.only(bottom: 12.h),
              child: TextField(
                controller: _controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'اكتب استفسارك الطبي',
                ),
              ),
            ),
            CustomButton(title: 'أرسل السؤال', onTap: _send),
            20.height,
            Text('أسئلتي السابقة',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText('هل المضاد الحيوي يتعارض مع فيتامين د؟',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                      ),
                      AppChip(label: 'ردّ عليك'),
                    ],
                  ),
                  10.height,
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor.themeColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AppText(
                      'د. خالد: لا تعارض. افصل بينهما بساعتين لأفضل امتصاص.',
                      fontSize: 11,
                      color: AppColors.textSecondaryColor.themeColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: AppText('أفضل وقت لقياس السكر الصائم؟',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                  ),
                  AppChip(
                    label: 'بانتظار الرد',
                    background: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                    color: AppColors.warningColor.themeColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
