import 'package:equatable/equatable.dart';

class ContactInfoModel extends Equatable {
  final String? phone;
  final String? whatsappNumber;
  final String? email;

  const ContactInfoModel({this.phone, this.whatsappNumber, this.email});

  bool get hasPhone => phone != null && phone!.isNotEmpty;
  bool get hasWhatsapp => whatsappNumber != null && whatsappNumber!.isNotEmpty;
  bool get hasEmail => email != null && email!.isNotEmpty;

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) => ContactInfoModel(
        phone: json['phone'] as String?,
        whatsappNumber: json['whatsapp_number'] as String?,
        email: json['email'] as String?,
      );

  @override
  List<Object?> get props => [phone, whatsappNumber, email];
}
