import 'package:flutter/material.dart';

class NotificationModel {
  const NotificationModel({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.accentColor,
    this.isRead = false,
  });

  final String icon;
  final String title;
  final String body;
  final String time;
  final Color? accentColor;
  final bool isRead;

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        icon: icon,
        title: title,
        body: body,
        time: time,
        accentColor: accentColor,
        isRead: isRead ?? this.isRead,
      );
}
