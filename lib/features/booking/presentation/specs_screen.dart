import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/models/specialization_model.dart';
import '../logic/doctors_cubit.dart';
import '../logic/specializations_cubit.dart';
import 'widgets/doctor_search_list.dart';
import 'widgets/specialty_chips.dart';

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

/// Doctors list with a horizontal specialty chip row on top — the first chip,
/// "الكل", clears the specialty filter and shows every doctor; picking a
/// specialty that has sub-specialties adds a second (smaller) chip row for
/// those. The search / sort / results below are owned by [DoctorSearchList].
///
/// Reached from [BookScreen] with a [specialization] already picked, or from
/// the symptom checker with an [initialSpecialty] title to resolve once the
/// list loads (falls back to "الكل" when it doesn't match).
class SpecsScreen extends StatefulWidget {
  const SpecsScreen({super.key, this.specialization, this.initialSpecialty});

  final SpecializationModel? specialization;
  final String? initialSpecialty;

  @override
  State<SpecsScreen> createState() => _SpecsScreenState();
}

class _SpecsScreenState extends State<SpecsScreen> {
  late final SpecializationsCubit _specsCubit = getIt<SpecializationsCubit>();
  late final DoctorsCubit _doctorsCubit = getIt<DoctorsCubit>();

  SpecializationModel? _selected;
  SubSpecializationModel? _subSpecialization;

  /// `true` once we know what to show — either a specialty came in via the
  /// route, or the specializations list has loaded and the initial selection
  /// was resolved (possibly to "الكل", i.e. `_selected == null`).
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.specialization;
    _ready = widget.specialization != null;
    _specsCubit.getSpecializations();
  }

  @override
  void dispose() {
    _specsCubit.close();
    _doctorsCubit.close();
    super.dispose();
  }

  void _resolveSelection(List<SpecializationModel> specializations) {
    final current = _selected;
    if (current != null) {
      final match = _firstWhereOrNull(specializations, (s) => s.id == current.id);
      if (match != null && match != current) setState(() => _selected = match);
      if (!_ready) setState(() => _ready = true);
      return;
    }

    // Already resolved — the user is (or was defaulted) on "الكل"; leave it.
    if (_ready) return;

    SpecializationModel? resolved;
    if (widget.initialSpecialty != null && specializations.isNotEmpty) {
      resolved = _firstWhereOrNull(specializations, (s) => s.title == widget.initialSpecialty);
    }
    setState(() {
      _selected = resolved;
      _ready = true;
    });
  }

  void _onSelectSpecialty(int? id, List<SpecializationModel> specializations) {
    if (id == null) {
      if (_selected == null) return;
      setState(() {
        _selected = null;
        _subSpecialization = null;
      });
      return;
    }
    final next = _firstWhereOrNull(specializations, (s) => s.id == id);
    if (next == null || next.id == _selected?.id) return;
    setState(() {
      _selected = next;
      _subSpecialization = null;
    });
  }

  void _onSelectSub(int? id) {
    final subs = _selected?.subSpecializations ?? const <SubSpecializationModel>[];
    setState(() => _subSpecialization = _firstWhereOrNull(subs, (s) => s.id == id));
  }

  /// The specialty ("الكل" + each specialty) and, when a specialty with
  /// sub-specialties is active, the sub-specialty chip rows — handed to
  /// [DoctorSearchList] so they render below its search row.
  Widget? _chipRows(
    List<SpecializationModel> specializations,
    List<SubSpecializationModel> subs,
  ) {
    if (specializations.isEmpty && subs.isEmpty) return null;

    final edgeInsets = EdgeInsetsDirectional.only(start: 20.w, end: 20.w);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (specializations.isNotEmpty) ...[
          SpecialtyChips(
            padding: edgeInsets,
            items: [
              SpecialtyChipItem(id: null, label: LocaleKeys.booking_filterAll.tr()),
              for (final s in specializations) SpecialtyChipItem(id: s.id, label: s.title),
            ],
            selectedId: _selected?.id,
            onSelect: (id) => _onSelectSpecialty(id, specializations),
          ),
          if (subs.isNotEmpty) 8.height,
        ],
        if (subs.isNotEmpty)
          SpecialtyChips(
            style: SpecialtyChipStyle.secondary,
            padding: edgeInsets,
            items: [
              SpecialtyChipItem(id: null, label: LocaleKeys.booking_filterAll.tr()),
              for (final sub in subs) SpecialtyChipItem(id: sub.id, label: sub.title),
            ],
            selectedId: _subSpecialization?.id,
            onSelect: _onSelectSub,
          ),
        12.height,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _specsCubit),
        BlocProvider.value(value: _doctorsCubit),
      ],
      child: BlocConsumer<SpecializationsCubit, SpecializationsState>(
        listener: (context, state) {
          if (state is SpecializationsSuccess) {
            _resolveSelection(state.specializations);
          } else if (state is SpecializationsError && !_ready) {
            setState(() => _ready = true);
          }
        },
        builder: (context, specsState) {
          final specializations = specsState is SpecializationsSuccess
              ? specsState.specializations
              : const <SpecializationModel>[];
          final selected = _selected;
          final subs = selected?.subSpecializations ?? const <SubSpecializationModel>[];

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
                    child: BlocBuilder<DoctorsCubit, DoctorsState>(
                      builder: (context, doctorsState) {
                        return ScreenHeader(
                          title: selected?.title ?? LocaleKeys.booking_allDoctors.tr(),
                          subtitle: doctorsState is DoctorsSuccess
                              ? LocaleKeys.booking_doctorsCount
                                  .tr(namedArgs: {'count': '${doctorsState.doctors.length}'})
                              : null,
                          onBack: () => Navigator.of(context).maybePop(),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: !_ready
                        ? Center(
                            child: CustomLoadingWidget(
                              color: AppColors.primaryColor.themeColor,
                              size: 40,
                            ),
                          )
                        : DoctorSearchList(
                            key: ValueKey('spec-${selected?.id ?? 'all'}'),
                            specializationId: selected?.id,
                            subSpecializationId: _subSpecialization?.id,
                            belowSearch: _chipRows(specializations, subs),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
