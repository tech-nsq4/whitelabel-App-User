import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/chat_message_model.dart';

class ChatRepo {
  ChatRepo({required DioClient dio, FirebaseFirestore? firestore})
      : _dio = dio,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final DioClient _dio;
  final FirebaseFirestore _firestore;

  String chatId({required int doctorId, required int userId}) => 'd${doctorId}_u$userId';

  String _presenceDocId(ChatSenderRole role, int id) => '${role.name}_$id';

  DocumentReference<Map<String, dynamic>> _chatDoc(String chatId) => _firestore.collection('chats').doc(chatId);

  CollectionReference<Map<String, dynamic>> _messagesCol(String chatId) => _chatDoc(chatId).collection('messages');

  Stream<List<ChatMessageModel>> watchMessages(String chatId) {
    return _messagesCol(chatId).orderBy('created_at', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => ChatMessageModel.fromDoc(doc.id, doc.data())).toList(),
        );
  }

  Stream<ChatPresenceModel> watchPresence({required ChatSenderRole role, required int id}) {
    return _firestore
        .collection('presence')
        .doc(_presenceDocId(role, id))
        .snapshots()
        .map((snapshot) => ChatPresenceModel.fromJson(snapshot.data()));
  }

  Stream<ChatReadStateModel> watchReadState(String chatId) {
    return _chatDoc(chatId).snapshots().map((snapshot) => ChatReadStateModel.fromJson(snapshot.data()));
  }

  Future<void> markRead({required String chatId, required ChatSenderRole role}) {
    return _chatDoc(chatId).set({
      '${role.name}_last_read_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setOnline({required ChatSenderRole role, required int id}) async {
    await _firestore.collection('presence').doc(_presenceDocId(role, id)).set({
      'online': true,
      'last_seen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setOffline({required ChatSenderRole role, required int id}) async {
    await _firestore.collection('presence').doc(_presenceDocId(role, id)).set({
      'online': false,
      'last_seen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _touchChat({
    required String chatId,
    required int doctorId,
    required int userId,
    required String doctorName,
    required String? doctorImage,
    required String userName,
    required String? userImage,
    required ChatSenderRole senderRole,
    required ChatMessageType lastMessageType,
    String? lastMessageText,
  }) {
    return _chatDoc(chatId).set({
      'doctor_id': doctorId,
      'user_id': userId,
      'doctor_name': doctorName,
      'doctor_image': doctorImage,
      'user_name': userName,
      'user_image': userImage,
      'last_message_type': lastMessageType.name,
      'last_message_text': lastMessageText,
      'last_sender_role': senderRole.name,
      'last_message_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> sendText({
    required String chatId,
    required int doctorId,
    required int userId,
    required String doctorName,
    required String? doctorImage,
    required String userName,
    required String? userImage,
    required ChatSenderRole senderRole,
    required String text,
  }) async {
    await _messagesCol(chatId).add({
      'sender_role': senderRole.name,
      'type': ChatMessageType.text.name,
      'text': text,
      'created_at': FieldValue.serverTimestamp(),
    });
    await _touchChat(
      chatId: chatId,
      doctorId: doctorId,
      userId: userId,
      doctorName: doctorName,
      doctorImage: doctorImage,
      userName: userName,
      userImage: userImage,
      senderRole: senderRole,
      lastMessageType: ChatMessageType.text,
      lastMessageText: text,
    );
  }

  Future<String> uploadImage(File file) async {
    try {
      final form = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });
      final response = await _dio.postForm(ApiEndpoints.chatImageUpload, form);
      return response.data['data']['url'] as String;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> sendImage({
    required String chatId,
    required int doctorId,
    required int userId,
    required String doctorName,
    required String? doctorImage,
    required String userName,
    required String? userImage,
    required ChatSenderRole senderRole,
    required File file,
  }) async {
    final url = await uploadImage(file);
    await _messagesCol(chatId).add({
      'sender_role': senderRole.name,
      'type': ChatMessageType.image.name,
      'image_url': url,
      'created_at': FieldValue.serverTimestamp(),
    });
    await _touchChat(
      chatId: chatId,
      doctorId: doctorId,
      userId: userId,
      doctorName: doctorName,
      doctorImage: doctorImage,
      userName: userName,
      userImage: userImage,
      senderRole: senderRole,
      lastMessageType: ChatMessageType.image,
    );
  }

  Future<void> sendLocation({
    required String chatId,
    required int doctorId,
    required int userId,
    required String doctorName,
    required String? doctorImage,
    required String userName,
    required String? userImage,
    required ChatSenderRole senderRole,
    required double lat,
    required double lng,
  }) async {
    await _messagesCol(chatId).add({
      'sender_role': senderRole.name,
      'type': ChatMessageType.location.name,
      'lat': lat,
      'lng': lng,
      'created_at': FieldValue.serverTimestamp(),
    });
    await _touchChat(
      chatId: chatId,
      doctorId: doctorId,
      userId: userId,
      doctorName: doctorName,
      doctorImage: doctorImage,
      userName: userName,
      userImage: userImage,
      senderRole: senderRole,
      lastMessageType: ChatMessageType.location,
    );
  }
}
