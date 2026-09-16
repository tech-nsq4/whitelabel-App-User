import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/favorites_cubit.dart';
import 'widgets/branch_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesCubit _cubit = getIt<FavoritesCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: _cubit,
            builder: (context, state) {
              final branches =
                  state is FavoritesSuccess ? state.branches : const <DoctorClinicModel>[];

              return Column(
                children: [
                  ScreenHeader(
                    title: LocaleKeys.booking_favoritesTitle.tr(),
                    subtitle: state is FavoritesSuccess
                        ? LocaleKeys.booking_favoritesCount
                            .tr(namedArgs: {'count': '${branches.length}'})
                        : null,
                  ),
                  Expanded(
                    child: CustomScreenStateLayout(
                      isLoading: state is FavoritesLoading || state is FavoritesInitial,
                      error: state is FavoritesError
                          ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                          : null,
                      onRetry: () => _cubit.load(),
                      onRefresh: () => _cubit.load(),
                      isEmpty: state is FavoritesSuccess && branches.isEmpty,
                      noDataBuilder: (_) => CustomNoDataView(
                        title: LocaleKeys.booking_favoritesEmptyTitle.tr(),
                        desc: LocaleKeys.booking_favoritesEmptyDesc.tr(),
                      ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
