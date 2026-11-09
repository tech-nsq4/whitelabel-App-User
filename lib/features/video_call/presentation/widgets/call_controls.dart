import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import 'call_circle_button.dart';

class CallControls extends StatelessWidget {
  const CallControls({
    super.key,
    required this.micOn,
    required this.cameraOn,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onSwitchCamera,
    required this.onEndCall,
  });

  final bool micOn;
  final bool cameraOn;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final VoidCallback onSwitchCamera;
  final VoidCallback onEndCall;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: 32.paddingBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CallCircleButton(
              icon: micOn ? Icons.mic : Icons.mic_off,
              active: micOn,
              onTap: onToggleMic,
            ),
            18.width,
            CallCircleButton(
              icon: cameraOn ? Icons.videocam : Icons.videocam_off,
              active: cameraOn,
              onTap: onToggleCamera,
            ),
            18.width,
            CallCircleButton(icon: Icons.cameraswitch, onTap: onSwitchCamera),
            18.width,
            CallCircleButton(
              icon: Icons.call_end,
              background: AppColors.errorColor.themeColor,
              onTap: onEndCall,
            ),
          ],
        ),
      ),
    );
  }
}
