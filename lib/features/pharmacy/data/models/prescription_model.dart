class PrescriptionModel {
  const PrescriptionModel({
    required this.number,
    required this.date,
    required this.doctor,
    required this.status,
    required this.isActive,
    required this.medications,
    required this.refillable,
  });

  final String number;
  final String date;
  final String doctor;
  final String status;
  final bool isActive;
  final List<String> medications;
  final bool refillable;
}
