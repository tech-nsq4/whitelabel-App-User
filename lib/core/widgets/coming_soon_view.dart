import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

class ComingSoonView extends StatefulWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.rocket_launch_rounded,
    this.highlights = const [],
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  @override
  State<ComingSoonView> createState() => _ComingSoonViewState();
}

class _ComingSoonViewState extends State<ComingSoonView>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTapEffect(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(13.r),
                    border:
                        Border.all(color: AppColors.dividerColor.themeColor),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 18.sp,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              10.height,
                              _Medallion(icon: widget.icon, pulse: _pulse),
                              18.height,
                              const _Badge(),
                              14.height,
                              AppText(
                                widget.title,
                                isHeading: true,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                                color: AppColors.textPrimaryColor.themeColor,
                              ),
                              10.height,
                              AppText(
                                widget.description,
                                fontSize: 12.5,
                                height: 1.7,
                                textAlign: TextAlign.center,
                                color:
                                    AppColors.textSecondaryColor.themeColor,
                              ),
                              if (widget.highlights.isNotEmpty) ...[
                                18.height,
                                _HighlightsCard(items: widget.highlights),
                              ],
                              14.height,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              8.height,
              CustomButton(
                onTap: () => Navigator.of(context).maybePop(),
                title: LocaleKeys.comingSoon_backHome.tr(),
                fontSize: 13,
              ),
              4.height,
            ],
          ),
        ),
      ),
    );
  }
}

class _Medallion extends StatelessWidget {
  const _Medallion({required this.icon, required this.pulse});

  final IconData icon;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final secondary = AppColors.secondaryColor.themeColor;

    return SizedBox(
      width: 168.r,
      height: 168.r,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: pulse,
            builder: (_, child) => Transform.scale(
              scale: 0.94 + 0.06 * pulse.value,
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 168.r,
                  height: 168.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        secondary.withValues(alpha: 0.18),
                        primary.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 128.r,
                  height: 128.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: primary.withValues(alpha: 0.10), width: 1.2),
                  ),
                ),
                Container(
                  width: 102.r,
                  height: 102.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: primary.withValues(alpha: 0.18), width: 1.2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 33.sp, color: Colors.white),
          ),
          PositionedDirectional(
            top: 20.r,
            end: 16.r,
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: AppColors.accentGold.themeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.themeColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(Icons.auto_awesome_rounded,
                  size: 12.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.secondaryColor.themeColor;
    return Container(
      padding: EdgeInsetsDirectional.only(
          start: 10.w, end: 13.w, top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 13.sp, color: secondary),
          6.width,
          AppText(
            LocaleKeys.comingSoon_badge.tr(),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: secondary,
          ),
        ],
      ),
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  const _HighlightsCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return AppCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            LocaleKeys.comingSoon_whatsComing.tr(),
            isHeading: true,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedColor.themeColor,
          ),
          12.height,
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) 10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.check_rounded, size: 14.sp, color: primary),
                ),
                10.width,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: AppText(
                      items[i],
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
