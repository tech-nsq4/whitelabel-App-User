import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import 'widgets/offer_card.dart';
import '../data/models/offer_model.dart';
import '../logic/offers_cubit.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late final OffersCubit _cubit = getIt<OffersCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getOffers();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _book(OfferModel offer) {
    final target = offer.booking;

    switch (offer.scope) {
      case 'doctors':
        {
          final doctors = offer.doctors;
          if (doctors.length > 1) {
            _openTargets(offer);
          } else if (doctors.length == 1) {
            _openDoctor(offer, doctors.first.id);
          } else if (target.doctorId != null) {
            _openDoctor(offer, target.doctorId!);
          } else {
            _openSearch(offer);
          }
        }
      case 'clinics':
        {
          final clinics = offer.clinics;
          if (clinics.length > 1) {
            _openTargets(offer);
          } else if (clinics.length == 1) {
            _openSearch(offer, clinicId: clinics.first.id);
          } else if (target.clinicId != null) {
            _openSearch(offer, clinicId: target.clinicId);
          } else {
            _openSearch(offer);
          }
        }
      case 'specializations':
        {
          final specializations = offer.specializations;
          if (specializations.length > 1) {
            _openTargets(offer);
          } else if (specializations.length == 1) {
            _openSearch(offer, specializationId: specializations.first.id);
          } else if (target.specializationId != null) {
            _openSearch(offer, specializationId: target.specializationId);
          } else {
            _openSearch(offer);
          }
        }
      default:
        _openSearch(offer);
    }
  }

  void _openTargets(OfferModel offer) {
    Navigator.pushNamed(context, Routes.offerTargets, arguments: {'offer': offer});
  }

  void _openDoctor(OfferModel offer, int doctorId) {
    Navigator.pushNamed(context, Routes.doctor, arguments: {
      'id': doctorId,
      'appliedOffer': offer.appliedOffer,
    });
  }

  void _openSearch(OfferModel offer, {int? clinicId, int? specializationId}) {
    Navigator.pushNamed(context, Routes.doctorSearch, arguments: {
      if (clinicId != null) 'clinicId': clinicId,
      if (specializationId != null) 'specializationId': specializationId,
      'title': offer.name,
      'appliedOffer': offer.appliedOffer,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: Column(
              children: [
                ScreenHeader(
                  title: LocaleKeys.offers_title.tr(),
                  subtitle: LocaleKeys.offers_subtitle.tr(),
                ),
                Expanded(
                  child: BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, state) {
                      final offers = state is OffersSuccess ? state.offers : const <OfferModel>[];

                      return CustomScreenStateLayout(
                        isLoading: state is OffersLoading || state is OffersInitial,
                        error: state is OffersError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getOffers(),
                        isEmpty: state is OffersSuccess && offers.isEmpty,
                        noDataBuilder: (_) => CustomNoDataView(
                          title: LocaleKeys.offers_emptyTitle.tr(),
                          desc: LocaleKeys.offers_emptyDescription.tr(),
                        ),
                        builder: (context) => ListView.builder(
                          padding: EdgeInsets.only(bottom: 24.h),
                          itemCount: offers.length,
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return OfferCard(offer: offer, onBook: () => _book(offer));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
