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
import '../logic/branches_cubit.dart';
import 'widgets/branch_card.dart';
import 'widgets/search_bar_field.dart';

/// Clinics list, backed by `GET /branches` — tapping one goes to
/// [DoctorSearchScreen] scoped to that clinic's doctors (`clinic_id` filter).
class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late final _cubit = getIt<BranchesCubit>();
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
    _cubit.getBranches(name: _searchController.text.trim());
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetch);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<BranchesCubit, BranchesState>(
        builder: (context, state) {
          final branches = state is BranchesSuccess ? state.branches : const [];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(
                      title: LocaleKeys.booking_branchesTitle.tr(),
                      subtitle: state is BranchesSuccess
                          ? LocaleKeys.booking_branchesCount.tr(namedArgs: {'count': '${branches.length}'})
                          : null,
                    ),
                    SearchBarField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hint: LocaleKeys.booking_searchBranchHint.tr(),
                    ),
                    12.height,
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is BranchesLoading || state is BranchesInitial,
                        error: state is BranchesError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: _fetch,
                        isEmpty: state is BranchesSuccess && branches.isEmpty,
                        builder: (context) => ListView(
                          padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
                          children: [
                            for (final b in branches)
                              BranchCard(
                                branch: b,
                                onViewDoctors: () => Navigator.pushNamed(
                                  context,
                                  Routes.doctorSearch,
                                  arguments: {'clinicId': b.id, 'title': b.name},
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
