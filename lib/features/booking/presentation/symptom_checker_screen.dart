import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import 'specs_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final _controller = TextEditingController();
  String? _selectedSymptom;

  static const _symptoms = ['ألم في المعدة', 'صداع مستمر', 'طفح جلدي', 'ألم أسنان', 'حرارة'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'دليل الأعراض', subtitle: 'يرشدك للتخصص المناسب في دقيقة'),
            AppCard(
              color: AppColors.surfaceColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 18.h),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: primary, size: 17.sp),
                  10.width,
                  Expanded(
                    child: AppText(
                      'هذه إرشادات أولية لاختيار التخصص — ليست تشخيصًا. في الحالات الطارئة اتصل بـ 997.',
                      fontSize: 11,
                      color: AppColors.textSecondaryColor.themeColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            AppCard(
              margin: EdgeInsets.only(bottom: 12.h),
              child: TextField(
                controller: _controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'مثال: ألم في المعدة بعد الأكل منذ ثلاثة أيام مع غثيان',
                ),
              ),
            ),
            Wrap(
              spacing: 7.w,
              runSpacing: 8.h,
              children: [
                for (final s in _symptoms)
                  GestureDetector(
                    onTap: () => setState(() {
                      _selectedSymptom = s;
                      _controller.text = s;
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        color: _selectedSymptom == s ? primary : AppColors.cardColor.themeColor,
                        border: Border.all(
                            color: _selectedSymptom == s
                                ? Colors.transparent
                                : AppColors.dividerColor.themeColor),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(s,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: _selectedSymptom == s
                                  ? Colors.white
                                  : AppColors.textSecondaryColor.themeColor)),
                    ),
                  ),
              ],
            ),
            22.height,
            CustomButton(
              title: 'اعرض التخصص المناسب',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const SpecsScreen(initialSpecialty: 'باطنة عامة'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
