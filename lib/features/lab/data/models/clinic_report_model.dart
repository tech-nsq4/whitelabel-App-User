enum ReportType { lab, xray }

class ClinicReportModel {
  const ClinicReportModel({
    required this.number,
    required this.date,
    required this.doctor,
    required this.name,
    required this.status,
    required this.isReady,
    required this.body,
  });

  final String number;
  final String date;
  final String doctor;
  final String name;
  final String status;
  final bool isReady;
  final String body;
}
