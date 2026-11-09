import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/home_visit_area_model.dart';
import 'home_visit_choice_chip.dart';

class HomeVisitAreaSelector extends StatelessWidget {
  const HomeVisitAreaSelector({
    super.key,
    required this.areas,
    required this.selectedId,
    required this.onSelect,
    this.showCost = false,
  });

  final List<HomeVisitAreaModel> areas;
  final int? selectedId;
  final ValueChanged<HomeVisitAreaModel> onSelect;
  final bool showCost;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final area in areas)
          HomeVisitChoiceChip(
            label: area.name,
            trailing: showCost && area.hasCost ? area.costValue : null,
            selected: area.id == selectedId,
            onTap: () => onSelect(area),
          ),
      ],
    );
  }
}
