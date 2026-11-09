import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../logic/video_call_cubit.dart';
import 'widgets/call_controls.dart';
import 'widgets/call_local_preview.dart';
import 'widgets/call_remote_view.dart';
import 'widgets/call_status_view.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.roomId,
    required this.userId,
    required this.userName,
    this.appointmentId,
  });

  final String roomId;
  final String userId;
  final String userName;
  final int? appointmentId;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final _cubit = getIt<VideoCallCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _waitForPushTransition();
      if (!mounted) return;
      _cubit.join(
        roomId: widget.roomId,
        userId: widget.userId,
        userName: widget.userName,
        appointmentId: widget.appointmentId,
      );
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _waitForPushTransition() async {
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      return;
    }
    final completer = Completer<void>();
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        if (!completer.isCompleted) completer.complete();
      }
    }

    animation.addStatusListener(listener);
    await completer.future;
  }

  void _closeAfterCallEnded() {
    AppOverlay.showSuccess(LocaleKeys.videoCall_endedByDoctor.tr());
    final navigator = Navigator.of(context);
    final callRoute = ModalRoute.of(context);
    navigator.popUntil((route) => route == callRoute);
    navigator.pop();
  }

  Future<void> _onLeavePressed() async {
    final confirmed = await showConfirmDialog(
      context,
      icon: Icons.call_end_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.videoCall_leaveConfirmTitle.tr(),
      message: LocaleKeys.videoCall_leaveConfirmMessage.tr(),
      confirmLabel: LocaleKeys.videoCall_leave.tr(),
      cancelLabel: LocaleKeys.common_cancel.tr(),
      confirmColor: AppColors.errorColor.themeColor,
    );
    if (confirmed && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.callBackgroundColor.themeColor,
      body: SafeArea(
        child: BlocConsumer<VideoCallCubit, VideoCallState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is VideoCallEnded) _closeAfterCallEnded();
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CallRemoteView(
                    view: state is VideoCallConnected ? state.remoteView : null,
                    showWaiting: state is VideoCallConnected,
                  ),
                ),
                if (state is VideoCallConnected)
                  CallLocalPreview(
                      view: state.localView, cameraOn: state.cameraOn),
                if (state is VideoCallInitial || state is VideoCallConnecting)
                  const CallStatusView.connecting(),
                if (state is VideoCallError)
                  CallStatusView.error(
                    errorMessage: state.message,
                    onClose: () => Navigator.pop(context),
                  ),
                if (state is VideoCallConnected)
                  CallControls(
                    micOn: state.micOn,
                    cameraOn: state.cameraOn,
                    onToggleMic: _cubit.toggleMic,
                    onToggleCamera: _cubit.toggleCamera,
                    onSwitchCamera: _cubit.switchCamera,
                    onEndCall: _onLeavePressed,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
