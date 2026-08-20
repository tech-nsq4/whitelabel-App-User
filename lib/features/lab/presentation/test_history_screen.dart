import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../booking/data/models/appointment_model.dart';
import '../../booking/presentation/widgets/test_results_card.dart';
import '../logic/test_history_cubit.dart';

/// Lab-analysis / x-ray history, backed by `GET /analyses/history` or
/// `GET /xrays/history` depending on [type] — reached from
/// `MedicalFileScreen`'s "نتائج المختبر"/"الأشعة" rows (and the same routes
/// from the home screen and services grid). Each row opens
/// `TestResultDetailScreen` for its full detail.
class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({super.key, required this.type});

  final TestHistoryType type;

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  late final TestHistoryCubit _cubit = getIt<TestHistoryCubit>();

  bool get _isXray => widget.type == TestHistoryType.xray;

  @override
  void initState() {
    super.initState();
    _cubit.getHistory(widget.type);
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
      child: BlocBuilder<TestHistoryCubit, TestHistoryState>(
        builder: (context, state) {
          final items = state is TestHistorySuccess ? state.items : const <TestRequestModel>[];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(
                      title: (_isXray ? LocaleKeys.lab_xrayTitle : LocaleKeys.lab_resultsTitle).tr(),
                    ),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is TestHistoryLoading || state is TestHistoryInitial,
                        error: state is TestHistoryError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getHistory(widget.type),
                        isEmpty: items.isEmpty,
                        noDataBuilder: (_) => EmptyStateView(
                          icon: _isXray ? AppSvgIcons.xray : AppSvgIcons.flask,
                          title: (_isXray ? LocaleKeys.lab_xrayEmptyTitle : LocaleKeys.lab_analysesEmptyTitle).tr(),
                          description: (_isXray
                                  ? LocaleKeys.lab_xrayEmptyDescription
                                  : LocaleKeys.lab_analysesEmptyDescription)
                              .tr(),
                        ),
                        builder: (context) => ListView(
                          padding: EdgeInsets.only(bottom: 24.h),
                          children: [TestResultsCard(requests: items)],
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
