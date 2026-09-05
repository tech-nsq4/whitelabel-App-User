import 'package:equatable/equatable.dart';

class AppliedOffer extends Equatable {
  const AppliedOffer({
    required this.id,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
  });

  final int id;
  final String discountType;
  final double discountValue;
  final double? maxDiscountAmount;

  bool get isPercentage => discountType == 'percentage';
  bool get isFixed => discountType == 'fixed';
  bool get isSpecialPrice => discountType == 'special_price';

  bool get hasClientDiscount =>
      discountValue > 0 && (isPercentage || isFixed || isSpecialPrice);

  double discountAmountFor(double price) {
    if (price <= 0) return 0;
    switch (discountType) {
      case 'percentage':
        var amount = price * discountValue / 100;
        final cap = maxDiscountAmount;
        if (cap != null && amount > cap) amount = cap;
        return amount.clamp(0, price).toDouble();
      case 'fixed':
        return discountValue.clamp(0, price).toDouble();
      case 'special_price':
        return (price - discountValue).clamp(0, price).toDouble();
      default:
        return 0;
    }
  }

  double finalPriceFor(double price) => price - discountAmountFor(price);

  @override
  List<Object?> get props => [id, discountType, discountValue, maxDiscountAmount];
}
