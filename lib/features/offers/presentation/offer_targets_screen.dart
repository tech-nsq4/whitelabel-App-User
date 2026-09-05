import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/models/offer_model.dart';
import 'widgets/offer_targets_list.dart';

class OfferTargetsScreen extends StatelessWidget {
  const OfferTargetsScreen({super.key, required this.offer});

  final OfferModel offer;

  String get _subtitleKey {
    switch (offer.scope) {
      case 'clinics':
        return LocaleKeys.offers_targetsPickClinic;
      case 'specializations':
        return LocaleKeys.offers_targetsPickSpecialization;
      default:
        return LocaleKeys.offers_targetsPickDoctor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
          child: Column(
            children: [
              ScreenHeader(title: offer.name, subtitle: _subtitleKey.tr()),
              Expanded(child: OfferTargetsList(offer: offer)),
            ],
          ),
        ),
      ),
    );
  }
}
