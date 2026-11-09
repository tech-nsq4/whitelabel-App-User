import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../booking/data/models/specialization_model.dart';
import '../../../booking/logic/specializations_cubit.dart';
import '../../../booking/presentation/widgets/specialty_chips.dart';

class HomeVisitSpecialtyChips extends StatelessWidget {
  const HomeVisitSpecialtyChips({
    super.key,
    required this.selected,
    required this.selectedSubId,
    required this.onSelectSpecialty,
    required this.onSelectSub,
  });

  final SpecializationModel? selected;
  final int? selectedSubId;
  final ValueChanged<SpecializationModel?> onSelectSpecialty;
  final ValueChanged<int?> onSelectSub;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecializationsCubit, SpecializationsState>(
      builder: (context, state) {
        final specializations =
            state is SpecializationsSuccess ? state.specializations : const <SpecializationModel>[];
        if (specializations.isEmpty) return const SizedBox.shrink();

        final subs = selected?.subSpecializations ?? const <SubSpecializationModel>[];
        final edgeInsets = EdgeInsetsDirectional.only(start: 20.w, end: 20.w);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SpecialtyChips(
              padding: edgeInsets,
              items: [
                SpecialtyChipItem(id: null, label: LocaleKeys.booking_filterAll.tr()),
                for (final s in specializations) SpecialtyChipItem(id: s.id, label: s.title),
              ],
              selectedId: selected?.id,
              onSelect: (id) {
                SpecializationModel? match;
                for (final s in specializations) {
                  if (s.id == id) match = s;
                }
                onSelectSpecialty(match);
              },
            ),
            if (subs.isNotEmpty) ...[
              8.height,
              SpecialtyChips(
                style: SpecialtyChipStyle.secondary,
                padding: edgeInsets,
                items: [
                  SpecialtyChipItem(id: null, label: LocaleKeys.booking_filterAll.tr()),
                  for (final sub in subs) SpecialtyChipItem(id: sub.id, label: sub.title),
                ],
                selectedId: selectedSubId,
                onSelect: onSelectSub,
              ),
            ],
            12.height,
          ],
        );
      },
    );
  }
}
