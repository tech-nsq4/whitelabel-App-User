import 'package:flutter/material.dart';

enum VisitItemStatus { done, pending, active }

class VisitItemModel {
  const VisitItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.statusKind = VisitItemStatus.done,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String status;
  final VisitItemStatus statusKind;
}

class VisitModel {
  const VisitModel({
    required this.id,
    required this.date,
    required this.doctor,
    required this.branch,
    required this.type,
    required this.status,
    required this.diagnosis,
    this.items = const [],
  });

  final String id;
  final String date;
  final String doctor;
  final String branch;
  final String type;
  final String status;
  final String diagnosis;
  final List<VisitItemModel> items;
}

class ClinicSummary {
  const ClinicSummary({
    required this.name,
    required this.icon,
    required this.lastVisitLabel,
    required this.count,
  });

  final String name;
  final String icon;
  final String lastVisitLabel;
  final int count;
}

Color visitItemStatusColor(VisitItemStatus status) {
  switch (status) {
    case VisitItemStatus.pending:
      return const Color(0xFFA97612);
    case VisitItemStatus.active:
    case VisitItemStatus.done:
      return const Color(0xFF0F6B5C);
  }
}
