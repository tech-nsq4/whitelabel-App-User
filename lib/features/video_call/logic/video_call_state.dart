part of 'video_call_cubit.dart';

sealed class VideoCallState extends Equatable {
  const VideoCallState();

  @override
  List<Object?> get props => [];
}

final class VideoCallInitial extends VideoCallState {
  const VideoCallInitial();
}

final class VideoCallConnecting extends VideoCallState {
  const VideoCallConnecting();
}

final class VideoCallConnected extends VideoCallState {
  const VideoCallConnected({
    this.localView,
    this.remoteView,
    this.micOn = true,
    this.cameraOn = true,
    this.frontCamera = true,
  });

  final Widget? localView;
  final Widget? remoteView;
  final bool micOn;
  final bool cameraOn;
  final bool frontCamera;

  bool get remoteConnected => remoteView != null;

  @override
  List<Object?> get props =>
      [localView, remoteView, micOn, cameraOn, frontCamera];
}

final class VideoCallEnded extends VideoCallState {
  const VideoCallEnded();
}

final class VideoCallError extends VideoCallState {
  const VideoCallError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
