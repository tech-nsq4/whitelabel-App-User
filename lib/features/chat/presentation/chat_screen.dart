import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/chat_repo.dart';
import '../data/models/chat_message_model.dart';
import '../logic/chat_cubit.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/chat_selection_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    this.doctorImage,
  });

  final int doctorId;
  final String doctorName;
  final String? doctorImage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatCubit _cubit = getIt<ChatCubit>();
  late final String _chatId;
  late final int _userId;
  late final String _userName;
  String? _lastMarkedReadMessageId;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _userId = kUserModel!.id;
    _userName = kUserModel!.name?.trim().isNotEmpty ?? false ? kUserModel!.name!.trim() : kUserModel!.phone;
    _chatId = getIt<ChatRepo>().chatId(doctorId: widget.doctorId, userId: _userId);
    _cubit.watch(_chatId);
    getIt<ChatRepo>().markRead(chatId: _chatId, role: ChatSenderRole.user);
  }

  void _markReadIfNeeded(List<ChatMessageModel> messages) {
    if (messages.isEmpty) return;
    final latest = messages.first;
    if (latest.senderRole == ChatSenderRole.user) return;
    if (latest.id == _lastMarkedReadMessageId) return;
    _lastMarkedReadMessageId = latest.id;
    getIt<ChatRepo>().markRead(chatId: _chatId, role: ChatSenderRole.user);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _sendText(String text) {
    _cubit.sendText(
      chatId: _chatId,
      doctorId: widget.doctorId,
      userId: _userId,
      doctorName: widget.doctorName,
      doctorImage: widget.doctorImage,
      userName: _userName,
      userImage: null,
      senderRole: ChatSenderRole.user,
      text: text,
    );
  }

  Future<void> _sendImage(File file) {
    return _cubit.sendImage(
      chatId: _chatId,
      doctorId: widget.doctorId,
      userId: _userId,
      doctorName: widget.doctorName,
      doctorImage: widget.doctorImage,
      userName: _userName,
      userImage: null,
      senderRole: ChatSenderRole.user,
      file: file,
    );
  }

  Future<void> _sendLocation(double lat, double lng) {
    return _cubit.sendLocation(
      chatId: _chatId,
      doctorId: widget.doctorId,
      userId: _userId,
      doctorName: widget.doctorName,
      doctorImage: widget.doctorImage,
      userName: _userName,
      userImage: null,
      senderRole: ChatSenderRole.user,
      lat: lat,
      lng: lng,
    );
  }

  void _toggleSelected(String id) {
    setState(() {
      if (!_selectedIds.remove(id)) _selectedIds.add(id);
    });
  }

  void _startSelection(String id) {
    setState(() => _selectedIds.add(id));
  }

  void _clearSelection() {
    setState(_selectedIds.clear);
  }

  Future<void> _confirmDeleteSelected() async {
    final ids = Set<String>.from(_selectedIds);
    if (ids.isEmpty) return;

    final confirmed = await showConfirmDialog(
      context,
      icon: Icons.delete_outline_rounded,
      title: LocaleKeys.chat_deleteConfirmTitle.tr(),
      message: LocaleKeys.chat_deleteConfirmMessage.tr(namedArgs: {'count': '${ids.length}'}),
      confirmLabel: LocaleKeys.chat_deleteConfirmAction.tr(),
      cancelLabel: LocaleKeys.common_cancel.tr(),
    );
    if (!confirmed) return;

    await _cubit.deleteMessages(
      chatId: _chatId,
      messageIds: ids,
      myRole: ChatSenderRole.user,
    );
    if (mounted) _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final selectionMode = _selectedIds.isNotEmpty;

    return BlocProvider.value(
      value: _cubit,
      child: PopScope(
        canPop: !selectionMode,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _clearSelection();
        },
        child: Scaffold(
          body: Column(
            children: [
              selectionMode
                  ? ChatSelectionBar(
                      count: _selectedIds.length,
                      onClose: _clearSelection,
                      onDelete: _confirmDeleteSelected,
                    )
                  : ChatHeader(
                      name: widget.doctorName,
                      image: widget.doctorImage,
                      presenceRole: ChatSenderRole.doctor,
                      presenceId: widget.doctorId,
                    ),
              Expanded(
              child: StreamBuilder<ChatReadStateModel>(
                stream: getIt<ChatRepo>().watchReadState(_chatId),
                builder: (context, readSnapshot) {
                  final otherLastReadAt = (readSnapshot.data ?? const ChatReadStateModel())
                      .lastReadAtFor(ChatSenderRole.doctor);

                  return BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is ChatSuccess) _markReadIfNeeded(state.messages);
                    },
                    builder: (context, state) {
                      final messages = state is ChatSuccess ? state.messages : const <ChatMessageModel>[];

                      return CustomScreenStateLayout(
                        isLoading: state is ChatLoading || state is ChatInitial,
                        error: state is ChatError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.watch(_chatId),
                        isEmpty: state is ChatSuccess && messages.isEmpty,
                        noDataBuilder: (_) => CustomNoDataView(
                          title: LocaleKeys.chat_emptyTitle.tr(),
                          desc: LocaleKeys.chat_emptyDescription.tr(),
                        ),
                        builder: (context) => ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMine = message.senderRole == ChatSenderRole.user;
                            final isRead = isMine &&
                                message.createdAt != null &&
                                otherLastReadAt != null &&
                                !message.createdAt!.isAfter(otherLastReadAt);
                            return ChatMessageBubble(
                              message: message,
                              isMine: isMine,
                              isRead: isRead,
                              selectionMode: selectionMode,
                              selected: _selectedIds.contains(message.id),
                              onTap: isMine ? () => _toggleSelected(message.id) : null,
                              onLongPress: isMine ? () => _startSelection(message.id) : null,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
              if (!selectionMode)
                ChatInputBar(
                  onSendText: _sendText,
                  onSendImage: _sendImage,
                  onSendLocation: _sendLocation,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
