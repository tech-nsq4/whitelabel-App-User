import 'package:equatable/equatable.dart';

class AppointmentQuoteModel extends Equatable {
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;
  final int? offerId;
  final int? promoCodeId;
  final String? promoCode;

  const AppointmentQuoteModel({
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    this.offerId,
    this.promoCodeId,
    this.promoCode,
  });

  bool get hasDiscount => discountAmount > 0 && finalPrice < originalPrice;

  int? get discountPercent {
    if (originalPrice <= 0 || discountAmount <= 0) return null;
    return (discountAmount / originalPrice * 100).round();
  }

  factory AppointmentQuoteModel.fromJson(Map<String, dynamic> json) {
    final offer = json['offer'] as Map<String, dynamic>?;
    final promo = json['promo_code'] as Map<String, dynamic>?;
    return AppointmentQuoteModel(
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      finalPrice: (json['final_price'] as num?)?.toDouble() ?? 0,
      offerId: (offer?['id'] as num?)?.toInt(),
      promoCodeId: (promo?['id'] as num?)?.toInt(),
      promoCode: promo?['code'] as String?,
    );
  }

  @override
  List<Object?> get props =>
      [originalPrice, discountAmount, finalPrice, offerId, promoCodeId, promoCode];
}
