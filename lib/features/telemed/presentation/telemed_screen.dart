import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../booking/data/doctors_mock_data.dart';
import '../../booking/data/models/doctor_model.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/telemed_specialty_mock_data.dart';
import 'live_call_screen.dart';
import 'widgets/telemed_mode_card.dart';
import 'widgets/telemed_slot_sheet.dart';

class TelemedScreen extends StatefulWidget {
  const TelemedScreen({super.key});

  @override
  State<TelemedScreen> createState() => _TelemedScreenState();
}

class _TelemedScreenState extends State<TelemedScreen> {
  String? _specialty;
  String _mode = 'فورية';
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startCall(DoctorModel doctor) async {
    final slot = await showTelemedSlotSheet(context, doctor);
    if (slot == null || !mounted) return;
    final paid = await showPaymentSheet(
      context,
      title: 'استشارة فيديو',
      detail: '${doctor.name} · $slot',
      amountLabel: '${doctor.telemedPrice} ريال',
    );
    if (paid != true || !mounted) return;
    if (slot == 'الآن') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LiveCallScreen(doctor: doctor)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الدفع — جلستك مؤكدة $slot')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final specialty = _specialty;
    final specialties = _query.isEmpty
        ? TelemedSpecialtyMockData.all
        : TelemedSpecialtyMockData.all
            .where((s) => s.name.contains(_query))
            .toList();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: specialty ?? 'استشارة عن بعد',
              subtitle: specialty == null
                  ? 'أطباؤنا معك بالفيديو خلال دقائق'
                  : 'أطباء متاحون الآن',
              onBack: specialty == null
                  ? null
                  : () => setState(() => _specialty = null),
            ),
            if (specialty == null) ...[
              Row(
                children: [
                  Expanded(
                    child: TelemedModeCard(
                      icon: AppSvgIcons.clock,
                      title: 'مجدولة',
                      subtitle: 'تختار وقتك',
                      price: '80 ريال',
                      selected: _mode == 'مجدولة',
                      onTap: () => setState(() => _mode = 'مجدولة'),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: TelemedModeCard(
                      icon: AppSvgIcons.heartbeat,
                      title: 'فورية',
                      subtitle: 'تبدأ خلال دقائق',
                      price: '100 ريال',
                      selected: _mode == 'فورية',
                      onTap: () => setState(() => _mode = 'فورية'),
                    ),
                  ),
                ],
              ),
              18.height,
              CustomTextField(
                controller: _searchController,
                hint: 'ابحث عن تخصص',
                fillColor: AppColors.cardColor.themeColor,
                borderColor: AppColors.dividerColor.themeColor,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.r),
                  child: AppSvgIcon(
                    AppSvgIcons.search,
                    size: 18.sp,
                    color: AppColors.hintColor.themeColor,
                  ),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              18.height,
              const SectionHeader(title: 'التخصصات'),
              10.height,
              AppCard(
                padding: EdgeInsets.symmetric(horizontal: 15.r),
                child: Column(
                  children: [
                    for (final info in specialties)
                      ListRowTile(
                        icon: info.icon,
                        title: info.name,
                        subtitle: info.availabilityLabel,
                        showDivider: info != specialties.last,
                        onTap: () => setState(() => _specialty = info.name),
                      ),
                  ],
                ),
              ),
            ] else
              for (final doc in DoctorsMockData.bySpecialty[specialty] ?? const <DoctorModel>[])
                AppCard(
                  margin: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      Container(
                        width: 46.r,
                        height: 46.r,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor.themeColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(doc.avatarLetter,
                            style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor.themeColor)),
                      ),
                      12.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(doc.name,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryColor.themeColor),
                            2.height,
                            AppText('${doc.specialty} · ${doc.rating}',
                                fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                            3.height,
                            AppText(
                              doc.isAvailableNow ? 'متاح الآن' : doc.nextSlotLabel,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: doc.isAvailableNow
                                  ? AppColors.primaryColor.themeColor
                                  : AppColors.mutedColor.themeColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 74.w,
                        child: CustomButton(
                          title: doc.isAvailableNow ? 'ابدأ' : 'احجز',
                          height: 34,
                          fontSize: 11.5,
                          onTap: () => _startCall(doc),
                        ),
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
