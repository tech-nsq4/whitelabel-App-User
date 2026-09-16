import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/image/custom_image_slider.dart';
import '../../../banners/logic/banners_cubit.dart';
import '../../../banners/presentation/banner_navigation.dart';

class HomeBannersSlider extends StatefulWidget {
  const HomeBannersSlider({super.key});

  @override
  State<HomeBannersSlider> createState() => _HomeBannersSliderState();
}

class _HomeBannersSliderState extends State<HomeBannersSlider> {
  late final BannersCubit _cubit = getIt<BannersCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getBanners();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<BannersCubit, BannersState>(
        builder: (context, state) {
          if (state is! BannersSuccess || state.banners.isEmpty) {
            return const SizedBox.shrink();
          }

          final banners = state.banners;
          return Column(
            children: [
              CustomImageSlider(
                sliders: banners.map((b) => b.image).toList(),
                height: 140.h,
                radius: 18,
                viewportFraction: 0.9,
                onTap: (index) => openBannerTarget(context, banners[index]),
              ),
              22.height,
            ],
          );
        },
      ),
    );
  }
}
