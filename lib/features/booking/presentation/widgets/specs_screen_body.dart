import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../data/models/specialization_model.dart';
import 'specialty_option_tile.dart';
import 'specialty_options_list.dart';

/// The scrollable list for the first two drill-down levels on [SpecsScreen]:
/// top-level specialties, or (when [specialization] is set) that specialty's
/// sub-specialties. Once a leaf (sub-)specialty is chosen, `SpecsScreen`
/// switches to `DoctorSearchList` instead of this widget.
class SpecsScreenBody extends StatelessWidget {
  const SpecsScreenBody({
    super.key,
    required this.specializations,
    required this.specialization,
    required this.onSelectSpecialization,
    required this.onSelectSubSpecialization,
  });

  final List<SpecializationModel> specializations;
  final SpecializationModel? specialization;
  final ValueChanged<SpecializationModel> onSelectSpecialization;
  final ValueChanged<SubSpecializationModel> onSelectSubSpecialization;

  static final _listPadding = EdgeInsets.only(top: 6.h, bottom: 24.h);

  @override
  Widget build(BuildContext context) {
    final specialization = this.specialization;

    if (specialization == null) {
      return SpecialtyOptionsList(
        padding: _listPadding,
        itemCount: specializations.length,
        itemBuilder: (context, i) {
          final s = specializations[i];
          return SpecialtyOptionTile(
            title: s.title,
            description: s.description,
            countLabel: s.hasSubSpecializations
                ? LocaleKeys.booking_subSpecialtiesCount
                    .tr(namedArgs: {'count': '${s.subSpecializations.length}'})
                : null,
            onTap: () => onSelectSpecialization(s),
          );
        },
      );
    }

    final subs = specialization.subSpecializations;
    return SpecialtyOptionsList(
      padding: _listPadding,
      itemCount: subs.length,
      itemBuilder: (context, i) {
        final sub = subs[i];
        return SpecialtyOptionTile(
          title: sub.title,
          description: sub.description,
          onTap: () => onSelectSubSpecialization(sub),
        );
      },
    );
  }
}
