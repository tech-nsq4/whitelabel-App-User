import 'package:equatable/equatable.dart';

import 'invoice_model.dart';

class PaymentsSummaryModel extends Equatable {
  final double totalPaid;
  final List<InvoiceModel> invoices;

  const PaymentsSummaryModel({this.totalPaid = 0, this.invoices = const []});

  factory PaymentsSummaryModel.fromJson(Map<String, dynamic> json) => PaymentsSummaryModel(
        totalPaid: double.tryParse('${json['total_paid']}') ?? 0,
        invoices: (json['invoices'] as List<dynamic>? ?? [])
            .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [totalPaid, invoices];
}
