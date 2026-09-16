import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/coming_soon_view.dart';

class TelemedComingSoonScreen extends StatelessWidget {
  const TelemedComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ComingSoonView(
      icon: Icons.video_camera_front_rounded,
      title: LocaleKeys.comingSoon_telemedTitle.tr(),
      description: LocaleKeys.comingSoon_telemedDescription.tr(),
      highlights: [
        LocaleKeys.comingSoon_telemedHighlight1.tr(),
        LocaleKeys.comingSoon_telemedHighlight2.tr(),
        LocaleKeys.comingSoon_telemedHighlight3.tr(),
      ],
    );
  }
}
