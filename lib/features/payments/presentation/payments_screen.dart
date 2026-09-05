import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/invoice_model.dart';
import '../logic/payments_cubit.dart';
import 'widgets/invoice_card.dart';
import 'widgets/payments_summary_card.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late final PaymentsCubit _cubit = getIt<PaymentsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getPayments();
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
      child: BlocBuilder<PaymentsCubit, PaymentsState>(
        builder: (context, state) {
          final summary = state is PaymentsSuccess ? state.summary : null;
          final invoices = summary?.invoices ?? const <InvoiceModel>[];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(
                      title: LocaleKeys.payments_title.tr(),
                      subtitle: summary == null
                          ? null
                          : LocaleKeys.payments_invoicesCount.tr(namedArgs: {'count': '${invoices.length}'}),
                    ),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is PaymentsLoading || state is PaymentsInitial,
                        error: state is PaymentsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: _cubit.getPayments,
                        isEmpty: state is PaymentsSuccess && invoices.isEmpty,
                        noDataBuilder: (_) => EmptyStateView(
                          icon: AppSvgIcons.wallet,
                          title: LocaleKeys.payments_emptyTitle.tr(),
                          description: LocaleKeys.payments_emptyDescription.tr(),
                        ),
                        builder: (context) => ListView(
                          padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
                          children: [
                            PaymentsSummaryCard(totalPaid: summary!.totalPaid),
                            18.height,
                            AppText(
                              LocaleKeys.payments_invoicesTitle.tr(),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mutedColor.themeColor,
                            ),
                            10.height,
                            for (final invoice in invoices) InvoiceCard(invoice: invoice),
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
