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
import '../logic/medications_cubit.dart';
import 'widgets/prescriptions_history_card.dart';

/// Prescription/medication history, backed by `GET /prescriptions/history`
/// — reached from `MedicalFileScreen`'s "الأدوية" row (and the same route
/// from the home screen).
class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  late final MedicationsCubit _cubit = getIt<MedicationsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getPrescriptions();
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
      child: BlocBuilder<MedicationsCubit, MedicationsState>(
        builder: (context, state) {
          final prescriptions = state is MedicationsSuccess ? state.prescriptions : const <PrescriptionModel>[];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.medications_title.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is MedicationsLoading || state is MedicationsInitial,
                        error: state is MedicationsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getPrescriptions(),
                        isEmpty: prescriptions.isEmpty,
                        noDataBuilder: (_) => EmptyStateView(
                          icon: AppSvgIcons.pill,
                          title: LocaleKeys.medications_emptyTitle.tr(),
                          description: LocaleKeys.medications_emptyDescription.tr(),
                        ),
                        builder: (context) => ListView(
                          padding: EdgeInsets.only(bottom: 24.h),
                          children: [PrescriptionsHistoryCard(prescriptions: prescriptions)],
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
