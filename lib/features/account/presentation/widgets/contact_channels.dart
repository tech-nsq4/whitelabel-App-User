import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/grid_action_tile.dart';
import '../../data/models/contact_info_model.dart';

class ContactChannels extends StatelessWidget {
  const ContactChannels({
    super.key,
    required this.info,
    required this.hasError,
    required this.onRetry,
    required this.onCall,
    required this.onWhatsApp,
    required this.onBranches,
  });

  final ContactInfoModel? info;
  final bool hasError;
  final VoidCallback onRetry;
  final ValueChanged<String> onCall;
  final ValueChanged<String> onWhatsApp;
  final VoidCallback onBranches;

  @override
  Widget build(BuildContext context) {
    final data = info;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: GridActionTile(
                icon: AppSvgIcons.phoneCall,
                label: LocaleKeys.contact_call.tr(),
                filled: true,
                onTap: data != null && data.hasPhone ? () => onCall(data.phone!) : null,
              ),
            ),
            10.width,
            Expanded(
              child: GridActionTile(
                icon: AppSvgIcons.chatBubble,
                label: LocaleKeys.contact_whatsapp.tr(),
                onTap: data != null && data.hasWhatsapp
                    ? () => onWhatsApp(data.whatsappNumber!)
                    : null,
              ),
            ),
            10.width,
            Expanded(
              child: GridActionTile(
                icon: AppSvgIcons.mapPin,
                label: LocaleKeys.contact_branches.tr(),
                onTap: onBranches,
              ),
            ),
          ],
        ),
        if (hasError) ...[
          10.height,
          TextButton(
            onPressed: onRetry,
            child: AppText(LocaleKeys.common_retry.tr(),
                fontSize: 12.5, color: AppColors.primaryColor.themeColor),
          ),
        ],
      ],
    );
  }
}
