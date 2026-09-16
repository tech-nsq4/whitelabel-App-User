import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../data/chat_repo.dart';
import '../data/models/chat_message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repo) : super(const ChatInitial());

  final ChatRepo _repo;
  StreamSubscription<List<ChatMessageModel>>? _subscription;

  void watch(String chatId) {
    emit(const ChatLoading());
    _subscription?.cancel();
    _subscription = _repo.watchMessages(chatId).listen(
          (messages) => emit(ChatSuccess(messages)),
          onError: (Object error) => emit(ChatError('$error')),
        );
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
    try {
      await _repo.sendText(
        chatId: chatId,
        doctorId: doctorId,
        userId: userId,
        doctorName: doctorName,
        doctorImage: doctorImage,
        userName: userName,
        userImage: userImage,
        senderRole: senderRole,
        text: text,
      );
    } catch (e) {
      AppOverlay.showError('$e');
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
    try {
      await _repo.sendImage(
        chatId: chatId,
        doctorId: doctorId,
        userId: userId,
        doctorName: doctorName,
        doctorImage: doctorImage,
        userName: userName,
        userImage: userImage,
        senderRole: senderRole,
        file: file,
      );
    } catch (e) {
      AppOverlay.showError('$e');
    }
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
    try {
      await _repo.sendLocation(
        chatId: chatId,
        doctorId: doctorId,
        userId: userId,
        doctorName: doctorName,
        doctorImage: doctorImage,
        userName: userName,
        userImage: userImage,
        senderRole: senderRole,
        lat: lat,
        lng: lng,
      );
    } catch (e) {
      AppOverlay.showError('$e');
    }
  }

  Future<void> deleteMessages({
    required String chatId,
    required Set<String> messageIds,
    required ChatSenderRole myRole,
  }) async {
    final current = state;
    if (current is! ChatSuccess) return;

    final ownIds = current.messages
        .where((message) => messageIds.contains(message.id) && message.senderRole == myRole)
        .map((message) => message.id)
        .toList();
    if (ownIds.isEmpty) return;

    try {
      await _repo.deleteMessages(chatId: chatId, messageIds: ownIds);
      final remaining = current.messages.where((message) => !ownIds.contains(message.id)).toList();
      await _repo.refreshLastMessage(
        chatId: chatId,
        latest: remaining.isEmpty ? null : remaining.first,
      );
    } catch (e) {
      AppOverlay.showError('$e');
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
