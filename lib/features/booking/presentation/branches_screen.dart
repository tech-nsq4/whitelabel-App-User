import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/branches_cubit.dart';
import 'widgets/branch_card.dart';

/// Clinics list, backed by `GET /branches` — tapping one goes to
/// [DoctorSearchScreen] scoped to that clinic's doctors (`clinic_id` filter).
class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  late final _cubit = getIt<BranchesCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getBranches();
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
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is BranchesLoading || state is BranchesInitial,
                        error: state is BranchesError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: _cubit.getBranches,
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
