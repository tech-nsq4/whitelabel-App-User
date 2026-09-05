import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ChatSenderRole {
  user,
  doctor;

  static ChatSenderRole fromName(String? name) =>
      name == doctor.name ? ChatSenderRole.doctor : ChatSenderRole.user;
}

enum ChatMessageType {
  text,
  image,
  location;

  static ChatMessageType fromName(String? name) => ChatMessageType.values.firstWhere(
        (type) => type.name == name,
        orElse: () => ChatMessageType.text,
      );
}

class ChatMessageModel extends Equatable {
  const ChatMessageModel({
    required this.id,
    required this.senderRole,
    required this.type,
    this.text,
    this.imageUrl,
    this.lat,
    this.lng,
    this.createdAt,
  });

  final String id;
  final ChatSenderRole senderRole;
  final ChatMessageType type;
  final String? text;
  final String? imageUrl;
  final double? lat;
  final double? lng;
  final DateTime? createdAt;

  factory ChatMessageModel.fromDoc(String id, Map<String, dynamic> json) => ChatMessageModel(
        id: id,
        senderRole: ChatSenderRole.fromName(json['sender_role'] as String?),
        type: ChatMessageType.fromName(json['type'] as String?),
        text: json['text'] as String?,
        imageUrl: json['image_url'] as String?,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      );

  @override
  List<Object?> get props => [id, senderRole, type, text, imageUrl, lat, lng, createdAt];
}

class ChatReadStateModel extends Equatable {
  const ChatReadStateModel({this.doctorLastReadAt, this.userLastReadAt});

  final DateTime? doctorLastReadAt;
  final DateTime? userLastReadAt;

  DateTime? lastReadAtFor(ChatSenderRole role) =>
      role == ChatSenderRole.doctor ? doctorLastReadAt : userLastReadAt;

  factory ChatReadStateModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChatReadStateModel();
    return ChatReadStateModel(
      doctorLastReadAt: (json['doctor_last_read_at'] as Timestamp?)?.toDate(),
      userLastReadAt: (json['user_last_read_at'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => [doctorLastReadAt, userLastReadAt];
}

class ChatPresenceModel extends Equatable {
  const ChatPresenceModel({this.online = false, this.lastSeen});

  final bool online;
  final DateTime? lastSeen;

  factory ChatPresenceModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChatPresenceModel();
    return ChatPresenceModel(
      online: json['online'] as bool? ?? false,
      lastSeen: (json['last_seen'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => [online, lastSeen];
}
