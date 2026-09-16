import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../data/models/offer_model.dart';
import '../data/offers_repo.dart';

/// Fetches the offer by id (blocking loader) then routes into its booking
/// flow. Shared by promo banners and offer notifications.
Future<void> openOfferById(BuildContext context, int offerId) async {
  final loaderNavigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (_) => Center(
      child: CustomLoadingWidget(
          color: AppColors.primaryColor.themeColor, size: 40),
    ),
  );

  try {
    final offer = await getIt<OffersRepo>().getOffer(offerId);
    loaderNavigator.pop();
    if (!context.mounted) return;
    openOfferBooking(context, offer);
  } catch (e) {
    loaderNavigator.pop();
    AppOverlay.showError(
        e is NetworkException ? e.message : LocaleKeys.error_generic.tr());
  }
}

void openOfferBooking(BuildContext context, OfferModel offer) {
  final target = offer.booking;

  switch (offer.scope) {
    case 'doctors':
      {
        final doctors = offer.doctors;
        if (doctors.length > 1) {
          _openTargets(context, offer);
        } else if (doctors.length == 1) {
          _openDoctor(context, offer, doctors.first.id);
        } else if (target.doctorId != null) {
          _openDoctor(context, offer, target.doctorId!);
        } else {
          _openSearch(context, offer);
        }
      }
    case 'clinics':
      {
        final clinics = offer.clinics;
        if (clinics.length > 1) {
          _openTargets(context, offer);
        } else if (clinics.length == 1) {
          _openSearch(context, offer, clinicId: clinics.first.id);
        } else if (target.clinicId != null) {
          _openSearch(context, offer, clinicId: target.clinicId);
        } else {
          _openSearch(context, offer);
        }
      }
    case 'specializations':
      {
        final specializations = offer.specializations;
        if (specializations.length > 1) {
          _openTargets(context, offer);
        } else if (specializations.length == 1) {
          _openSearch(context, offer, specializationId: specializations.first.id);
        } else if (target.specializationId != null) {
          _openSearch(context, offer, specializationId: target.specializationId);
        } else {
          _openSearch(context, offer);
        }
      }
    default:
      _openSearch(context, offer);
  }
}

void _openTargets(BuildContext context, OfferModel offer) {
  Navigator.pushNamed(context, Routes.offerTargets, arguments: {'offer': offer});
}

void _openDoctor(BuildContext context, OfferModel offer, int doctorId) {
  Navigator.pushNamed(context, Routes.doctor, arguments: {
    'id': doctorId,
    'appliedOffer': offer.appliedOffer,
  });
}

void _openSearch(BuildContext context, OfferModel offer, {int? clinicId, int? specializationId}) {
  Navigator.pushNamed(context, Routes.doctorSearch, arguments: {
    if (clinicId != null) 'clinicId': clinicId,
    if (specializationId != null) 'specializationId': specializationId,
    'title': offer.name,
    'appliedOffer': offer.appliedOffer,
  });
}
