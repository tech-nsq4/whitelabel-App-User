import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import '../../../core/config/zego_config.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/video_call_repo.dart';

part 'video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  VideoCallCubit(this._repo) : super(const VideoCallInitial());

  static const _callStatusPollInterval = Duration(seconds: 10);

  final VideoCallRepo _repo;
  Timer? _callStatusPoll;

  String? _roomId;
  bool _engineCreated = false;

  int? _localViewId;
  int? _remoteViewId;
  String? _remoteStreamId;
  Widget? _localView;
  Widget? _remoteView;

  bool _micOn = true;
  bool _cameraOn = true;
  bool _frontCamera = true;

  Future<void> join({
    required String roomId,
    required String userId,
    required String userName,
    int? appointmentId,
  }) async {
    if (state is! VideoCallInitial) return;
    emit(const VideoCallConnecting());

    if (!ZegoConfig.isConfigured) {
      emit(VideoCallError(LocaleKeys.videoCall_notConfigured.tr()));
      return;
    }

    if (!await _ensurePermissions()) {
      if (!isClosed) {
        emit(VideoCallError(LocaleKeys.videoCall_permissionsDenied.tr()));
      }
      return;
    }
    if (isClosed) return;

    try {
      await ZegoExpressEngine.createEngineWithProfile(
        ZegoEngineProfile(
          ZegoConfig.appID,
          ZegoScenario.StandardVideoCall,
          appSign: ZegoConfig.appSign,
        ),
      );
      _engineCreated = true;

      ZegoExpressEngine.onRoomStreamUpdate =
          (_, updateType, streamList, __) =>
              _onRemoteStreamUpdated(updateType, streamList);

      _localView = await ZegoExpressEngine.instance.createCanvasView((viewId) {
        _localViewId = viewId;
        ZegoExpressEngine.instance.startPreview(canvas: ZegoCanvas.view(viewId));
      });

      final result = await ZegoExpressEngine.instance.loginRoom(
        roomId,
        ZegoUser(userId, userName),
        config: ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true,
      );
      if (result.errorCode != 0) {
        throw Exception('loginRoom failed: ${result.errorCode}');
      }
      _roomId = roomId;

      await ZegoExpressEngine.instance
          .startPublishingStream('${roomId}_${userId}_main');

      _emitConnected();
      if (appointmentId != null) _watchCallStatus(appointmentId);
    } catch (e) {
      debugPrint('VideoCallCubit.join: $e');
      if (!isClosed) emit(VideoCallError(LocaleKeys.videoCall_failed.tr()));
    }
  }

  void _watchCallStatus(int appointmentId) {
    _callStatusPoll = Timer.periodic(
      _callStatusPollInterval,
      (_) => _checkCallStatus(appointmentId),
    );
  }

  Future<void> _checkCallStatus(int appointmentId) async {
    try {
      final call = await _repo.getCall(appointmentId);
      if (isClosed || state is! VideoCallConnected) return;
      if (call?.isFinished ?? false) {
        _callStatusPoll?.cancel();
        emit(const VideoCallEnded());
      }
    } catch (e) {
      debugPrint('VideoCallCubit._checkCallStatus: $e');
    }
  }

  Future<void> _onRemoteStreamUpdated(
      ZegoUpdateType updateType, List<ZegoStream> streamList) async {
    if (isClosed || streamList.isEmpty) return;

    if (updateType == ZegoUpdateType.Add) {
      if (_remoteStreamId != null) return;
      final streamId = streamList.first.streamID;
      _remoteStreamId = streamId;
      _remoteView = await ZegoExpressEngine.instance.createCanvasView((viewId) {
        _remoteViewId = viewId;
        ZegoExpressEngine.instance
            .startPlayingStream(streamId, canvas: ZegoCanvas.view(viewId));
      });
    } else {
      final streamId = _remoteStreamId;
      if (streamId == null ||
          streamList.every((stream) => stream.streamID != streamId)) {
        return;
      }
      await _stopRemoteStream();
    }

    if (state is VideoCallConnected) _emitConnected();
  }

  Future<void> _stopRemoteStream() async {
    final streamId = _remoteStreamId;
    if (streamId != null) {
      await ZegoExpressEngine.instance.stopPlayingStream(streamId);
    }
    if (_remoteViewId != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(_remoteViewId!);
    }
    _remoteStreamId = null;
    _remoteViewId = null;
    _remoteView = null;
  }

  Future<void> toggleMic() async {
    if (state is! VideoCallConnected) return;
    _micOn = !_micOn;
    await ZegoExpressEngine.instance.muteMicrophone(!_micOn);
    _emitConnected();
  }

  Future<void> toggleCamera() async {
    if (state is! VideoCallConnected) return;
    _cameraOn = !_cameraOn;
    await ZegoExpressEngine.instance.enableCamera(_cameraOn);
    _emitConnected();
  }

  Future<void> switchCamera() async {
    if (state is! VideoCallConnected) return;
    _frontCamera = !_frontCamera;
    await ZegoExpressEngine.instance.useFrontCamera(_frontCamera);
    _emitConnected();
  }

  void _emitConnected() {
    if (isClosed) return;
    emit(VideoCallConnected(
      localView: _localView,
      remoteView: _remoteView,
      micOn: _micOn,
      cameraOn: _cameraOn,
      frontCamera: _frontCamera,
    ));
  }

  Future<bool> _ensurePermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> _leave() async {
    ZegoExpressEngine.onRoomStreamUpdate = null;
    if (!_engineCreated) return;
    try {
      await ZegoExpressEngine.instance.stopPublishingStream();
      await ZegoExpressEngine.instance.stopPreview();
      await _stopRemoteStream();
      if (_roomId != null) {
        await ZegoExpressEngine.instance.logoutRoom(_roomId);
      }
      if (_localViewId != null) {
        await ZegoExpressEngine.instance.destroyCanvasView(_localViewId!);
      }
      await ZegoExpressEngine.destroyEngine();
    } catch (e) {
      debugPrint('VideoCallCubit._leave: $e');
    }
  }

  @override
  Future<void> close() async {
    _callStatusPoll?.cancel();
    await _leave();
    return super.close();
  }
}
