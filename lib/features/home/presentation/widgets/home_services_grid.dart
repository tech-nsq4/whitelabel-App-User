import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import 'home_service_tile.dart';

class HomeServicesGrid extends StatefulWidget {
  const HomeServicesGrid({
    super.key,
    this.onBookTap,
    this.onTelemedTap,
    this.onOffersTap,
    this.onHomeVisitTap,
  });

  final VoidCallback? onBookTap;
  final VoidCallback? onTelemedTap;
  final VoidCallback? onOffersTap;
  final VoidCallback? onHomeVisitTap;

  @override
  State<HomeServicesGrid> createState() => _HomeServicesGridState();
}

class _HomeServicesGridState extends State<HomeServicesGrid> {
  int _selected = 0;

  void _onTap(int index, VoidCallback? action) {
    if (_selected != index) setState(() => _selected = index);
    action?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        AppSvgIcons.calendar,
        LocaleKeys.home_bookAppointment.tr(),
        LocaleKeys.home_bookAppointmentSubtitle.tr(),
        widget.onBookTap,
        false,
      ),
      (
        AppSvgIcons.videoCam,
        LocaleKeys.home_consultation.tr(),
        LocaleKeys.home_consultationSubtitle.tr(),
        widget.onTelemedTap,
        false,
      ),
      (
        AppSvgIcons.giftBox,
        LocaleKeys.home_offers.tr(),
        LocaleKeys.home_offersSubtitle.tr(),
        widget.onOffersTap,
        false,
      ),
      (
        AppSvgIcons.home2,
        LocaleKeys.homeVisit_title.tr(),
        LocaleKeys.homeVisit_subtitle.tr(),
        widget.onHomeVisitTap,
        false,
      ),
    ];

    return Column(
      children: [
        for (var row = 0; row < tiles.length; row += 2) ...[
          if (row > 0) 10.height,
          Row(
            children: [
              for (var i = row; i < row + 2 && i < tiles.length; i++) ...[
                if (i > row) 10.width,
                Expanded(
                  child: HomeServiceTile(
                    icon: tiles[i].$1,
                    label: tiles[i].$2,
                    subLabel: tiles[i].$3,
                    selected: _selected == i,
                    comingSoon: tiles[i].$5,
                    onTap: () => _onTap(i, tiles[i].$4),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
