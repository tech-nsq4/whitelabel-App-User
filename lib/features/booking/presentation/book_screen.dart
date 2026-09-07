import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/specialization_model.dart';
import '../logic/specializations_cubit.dart';
import 'widgets/search_bar_field.dart';
import 'widgets/specialty_grid.dart';
import 'widgets/symptom_prompt_banner.dart';

/// Booking entry point — the specialty grid. `GET /specializations` backs it;
/// picking a tile hands off to [SpecsScreen] (the doctors list, scoped to
/// that specialty). The old "how do you want to book" chooser lives on at
/// [Routes.bookOptions].
class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late final SpecializationsCubit _cubit = getIt<SpecializationsCubit>();
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _fetch() {
    _cubit.getSpecializations(name: _searchController.text.trim());
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetch);
  }

  void _openSpecialty(SpecializationModel specialization) {
    Navigator.pushNamed(context, Routes.specs, arguments: {
      'specialization': specialization,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: Column(
              children: [
                ScreenHeader(
                  title: LocaleKeys.booking_bookTitle.tr(),
                  subtitle: LocaleKeys.booking_chooseSpecialty.tr(),
                ),
                SearchBarField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  hint: LocaleKeys.booking_searchSpecialtyHint.tr(),
                ),
                12.height,
                SymptomPromptBanner(
                  onTap: () => Navigator.pushNamed(context, Routes.symptomChecker),
                ),
                14.height,
                Expanded(
                  child: BlocBuilder<SpecializationsCubit, SpecializationsState>(
                    builder: (context, state) {
                      final specializations = state is SpecializationsSuccess
                          ? state.specializations
                          : const <SpecializationModel>[];
                      return CustomScreenStateLayout(
                        isLoading:
                            state is SpecializationsLoading || state is SpecializationsInitial,
                        error: state is SpecializationsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: _fetch,
                        isEmpty: state is SpecializationsSuccess && specializations.isEmpty,
                        builder: (context) => SpecialtyGrid(
                          specializations: specializations,
                          onSelect: _openSpecialty,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
