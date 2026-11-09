enum ConsultationType {
  clinic(timeTableValue: 'clinic', appointmentValue: 'offline'),
  online(timeTableValue: 'online', appointmentValue: 'online'),
  homeVisit(timeTableValue: 'home_visit', appointmentValue: 'home_visit');

  const ConsultationType({
    required this.timeTableValue,
    required this.appointmentValue,
  });

  final String timeTableValue;
  final String appointmentValue;

  bool get isOnline => this == ConsultationType.online;

  bool get isHomeVisit => this == ConsultationType.homeVisit;

  bool get isClinic => this == ConsultationType.clinic;

  static ConsultationType fromAppointmentValue(String? value) => switch (value) {
        'online' => ConsultationType.online,
        'home_visit' => ConsultationType.homeVisit,
        _ => ConsultationType.clinic,
      };
}
