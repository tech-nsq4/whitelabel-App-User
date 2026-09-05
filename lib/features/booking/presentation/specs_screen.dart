import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/specialization_model.dart';
import '../logic/doctors_cubit.dart';
import '../logic/specializations_cubit.dart';
import 'widgets/doctor_search_list.dart';
import 'widgets/search_bar_field.dart';
import 'widgets/specs_screen_body.dart';
import 'widgets/specs_screen_header.dart';

/// Specialty → sub-specialty → doctor drill-down. The first two levels are
/// backed by `GET /specializations`; picking a leaf (sub-)specialty hands
/// off to [DoctorSearchList], which owns the `GET /doctors` search/filter
/// step from there. [initialSpecialty] (a specialization *title*) lets a
/// caller (e.g. the symptom checker) jump straight past the top-level list
/// once it's loaded.
class SpecsScreen extends StatefulWidget {
  const SpecsScreen({super.key, this.initialSpecialty});

  final String? initialSpecialty;

  @override
  State<SpecsScreen> createState() => _SpecsScreenState();
}

class _SpecsScreenState extends State<SpecsScreen> {
  late final SpecializationsCubit _specsCubit = getIt<SpecializationsCubit>();
  late final DoctorsCubit _doctorsCubit = getIt<DoctorsCubit>();
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  SpecializationModel? _specialization;
  SubSpecializationModel? _subSpecialization;
  bool _initialApplied = false;

  @override
  void initState() {
    super.initState();
    _fetchSpecializations();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _specsCubit.close();
    _doctorsCubit.close();
    super.dispose();
  }

  void _fetchSpecializations() {
    _specsCubit.getSpecializations(name: _searchController.text.trim());
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetchSpecializations);
  }

  /// Once the real list is in, resolve [SpecsScreen.initialSpecialty] (a
  /// title) against it — silently does nothing if there's no match.
  void _applyInitialSpecialty(List<SpecializationModel> specializations) {
    if (_initialApplied || widget.initialSpecialty == null) return;
    _initialApplied = true;
    for (final s in specializations) {
      if (s.title == widget.initialSpecialty) {
        setState(() => _specialization = s);
        break;
      }
    }
  }

  void _goBack() {
    setState(() {
      if (_subSpecialization != null) {
        _subSpecialization = null;
      } else {
        _specialization = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _specsCubit),
        BlocProvider.value(value: _doctorsCubit),
      ],
      child: BlocListener<SpecializationsCubit, SpecializationsState>(
        listener: (context, state) {
          if (state is SpecializationsSuccess) _applyInitialSpecialty(state.specializations);
        },
        child: BlocBuilder<SpecializationsCubit, SpecializationsState>(
          builder: (context, specsState) {
            final specializations =
                specsState is SpecializationsSuccess ? specsState.specializations : const <SpecializationModel>[];
            final specialization = _specialization;
            final onDoctorsLevel =
                specialization != null && (!specialization.hasSubSpecializations || _subSpecialization != null);
            final onSpecialtiesLevel = specialization == null;

            return BlocBuilder<DoctorsCubit, DoctorsState>(
              builder: (context, doctorsState) {
                final doctorsCount = doctorsState is DoctorsSuccess ? doctorsState.doctors.length : 0;

                return Scaffold(
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                      child: Column(
                        children: [
                          SpecsScreenHeader(
                            specialization: specialization,
                            subSpecialization: _subSpecialization,
                            doctorsCount: doctorsCount,
                            onBack: _goBack,
                          ),
                          Expanded(
                            child: onDoctorsLevel
                                ? DoctorSearchList(
                                    specializationId: _subSpecialization?.specializationId ?? specialization.id,
                                  )
                                : Column(
                                    children: [
                                      if (onSpecialtiesLevel) ...[
                                        SearchBarField(
                                          controller: _searchController,
                                          onChanged: _onSearchChanged,
                                          hint: LocaleKeys.booking_searchSpecialtyHint.tr(),
                                        ),
                                        12.height,
                                      ],
                                      Expanded(
                                        child: CustomScreenStateLayout(
                                          isLoading: specsState is SpecializationsLoading ||
                                              specsState is SpecializationsInitial,
                                          error: specsState is SpecializationsError
                                              ? ErrorModel(code: ErrorEnum.other, errorMessage: specsState.message)
                                              : null,
                                          onRetry: _fetchSpecializations,
                                          isEmpty: specsState is SpecializationsSuccess && specializations.isEmpty,
                                          builder: (context) => SpecsScreenBody(
                                            specializations: specializations,
                                            specialization: specialization,
                                            onSelectSpecialization: (s) => setState(() => _specialization = s),
                                            onSelectSubSpecialization: (sub) =>
                                                setState(() => _subSpecialization = sub),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
