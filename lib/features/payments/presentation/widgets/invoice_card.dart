import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/list_row_tile.dart';
import '../../data/models/invoice_model.dart';
import 'payment_sheet.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.invoice});

  final InvoiceModel invoice;

  String _title(BuildContext context) =>
      invoice.doctor?.name ?? LocaleKeys.payments_invoiceNumber.tr(namedArgs: {'id': '${invoice.id}'});

  String _subtitle(BuildContext context) {
    final locale = context.locale.languageCode;
    final date = invoice.date;
    return [
      if (date != null) DateFormat('d MMMM yyyy', locale).format(date),
      if (invoice.time.isNotEmpty) invoice.timeLabel,
    ].join(' · ');
  }

  String get _amountLabel => '${invoice.amount.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}';

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitle(context);
    final clinicName = invoice.clinic?.name;
    final member = invoice.familyMember;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  _title(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  3.height,
                  AppText(subtitle, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                ],
                if (clinicName != null && clinicName.isNotEmpty) ...[
                  2.height,
                  AppText(
                    clinicName,
                    fontSize: 10.5,
                    color: AppColors.mutedColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (member != null) ...[
                  4.height,
                  AppText(
                    LocaleKeys.payments_forMember.tr(namedArgs: {'name': member.name}),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.themeColor,
                  ),
                ],
              ],
            ),
          ),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                _amountLabel,
                isHeading: true,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
              6.height,
              if (invoice.isPaid)
                AppChip(label: LocaleKeys.payments_paid.tr())
              else
                SizedBox(
                  width: 92.w,
                  child: CustomButton(
                    title: LocaleKeys.payments_payNow.tr(),
                    height: 34,
                    fontSize: 11,
                    onTap: () => showPaymentSheet(
                      context,
                      title: _title(context),
                      detail: subtitle,
                      amountLabel: _amountLabel,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
