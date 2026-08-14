import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/screen_header.dart';
import '../../data/models/specialization_model.dart';

/// [ScreenHeader] variant for [SpecsScreen] — title/subtitle/back-behaviour
/// change with the current drill-down level (specialties → sub-specialties
/// → doctors).
class SpecsScreenHeader extends StatelessWidget {
  const SpecsScreenHeader({
    super.key,
    required this.specialization,
    required this.subSpecialization,
    required this.doctorsCount,
    required this.onBack,
  });

  final SpecializationModel? specialization;
  final SubSpecializationModel? subSpecialization;
  final int doctorsCount;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final specialization = this.specialization;

    if (specialization == null) {
      return ScreenHeader(title: LocaleKeys.booking_chooseSpecialty.tr());
    }

    if (specialization.hasSubSpecializations && subSpecialization == null) {
      return ScreenHeader(
        title: specialization.title,
        subtitle: LocaleKeys.booking_subSpecialtiesCount
            .tr(namedArgs: {'count': '${specialization.subSpecializations.length}'}),
        onBack: onBack,
      );
    }

    final title = subSpecialization?.title ?? specialization.title;
    return ScreenHeader(
      title: title,
      subtitle: LocaleKeys.booking_doctorsCount.tr(namedArgs: {'count': '$doctorsCount'}),
      onBack: onBack,
    );
  }
}
