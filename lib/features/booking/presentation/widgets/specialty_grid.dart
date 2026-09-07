import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/specialization_model.dart';
import 'specialty_grid_tile.dart';

/// Two-column grid of [SpecialtyGridTile]s — the top level of the booking
/// flow on [BookScreen].
class SpecialtyGrid extends StatelessWidget {
  const SpecialtyGrid({
    super.key,
    required this.specializations,
    required this.onSelect,
  });

  final List<SpecializationModel> specializations;
  final ValueChanged<SpecializationModel> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
      itemCount: specializations.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        mainAxisExtent: 138.h,
      ),
      itemBuilder: (context, i) {
        final specialization = specializations[i];
        return SpecialtyGridTile(
          specialization: specialization,
          index: i,
          onTap: () => onSelect(specialization),
        );
      },
    );
  }
}
