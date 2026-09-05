import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/logic/profile_cubit.dart';

class HomeGreeting extends StatefulWidget {
  const HomeGreeting({super.key});

  @override
  State<HomeGreeting> createState() => _HomeGreetingState();
}

class _HomeGreetingState extends State<HomeGreeting> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _waveController;
  late final AnimationController _shimmerController;

  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _nameScale;
  late final Animation<double> _wave;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.32), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic));
    _nameScale = Tween<double>(begin: 0.85, end: 1)
        .animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack));

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _wave = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.35), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.35, end: -0.18), weight: 5),
      TweenSequenceItem(tween: Tween(begin: -0.18, end: 0.3), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.0), weight: 5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeInOut));

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _entranceController.forward();
    _waveController.repeat();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _waveController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final resolved = state is ProfileSuccess ? state.user.name : kUserModel?.name;
        return _content(resolved?.trim() ?? '');
      },
    );
  }

  Widget _content(String name) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  LocaleKeys.home_greetingMorning.tr(),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedColor.themeColor,
                ),
                4.width,
                AnimatedBuilder(
                  animation: _wave,
                  builder: (_, child) => Transform.rotate(
                    angle: _wave.value,
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                  child: Text('👋', style: TextStyle(fontSize: 13.sp)),
                ),
              ],
            ),
            // 3.height,
            if (name.isNotEmpty)
              ScaleTransition(
                scale: _nameScale,
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (_, child) => ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: _shineShader,
                    child: child,
                  ),
                  child: AppText(
                    name,
                    isHeading: true,
                    fontSize: 25,
                    height: 0.9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            else
              AppText(
                LocaleKeys.home_welcome.tr(),
                isHeading: true,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Shader _shineShader(Rect bounds) {
    final base = AppColors.primaryColor.themeColor;
    final shine = AppColors.accentGold.themeColor;
    final progress = (_shimmerController.value / 0.42).clamp(0.0, 1.0);
    final center = -0.25 + 1.5 * progress;

    return LinearGradient(
      colors: [base, base, shine, base, base],
      stops: [
        0.0,
        (center - 0.09).clamp(0.0, 1.0),
        center.clamp(0.0, 1.0),
        (center + 0.09).clamp(0.0, 1.0),
        1.0,
      ],
    ).createShader(bounds);
  }
}
