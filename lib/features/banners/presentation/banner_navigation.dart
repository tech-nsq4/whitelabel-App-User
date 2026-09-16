import 'package:flutter/material.dart';

import '../../../app/router/routes.dart';
import '../../offers/presentation/offer_navigation.dart';
import '../data/models/banner_model.dart';

Future<void> openBannerTarget(BuildContext context, BannerModel banner) async {
  if (banner.targetId==null) return;
  final id = banner.targetId!;
  //
  // switch (banner.type) {
  //   case BannerTargetType.doctor:
  //     Navigator.pushNamed(context, Routes.doctor, arguments: {'id': id});
  //   case BannerTargetType.clinic:
  //     Navigator.pushNamed(context, Routes.doctorSearch, arguments: {
  //       'clinicId': id,
  //       'title': banner.title,
  //     });
  //   case BannerTargetType.offer:
  //     await openOfferById(context, id);
  //   case BannerTargetType.none:
  //     break;
  // }
  await openOfferById(context, id);

}
