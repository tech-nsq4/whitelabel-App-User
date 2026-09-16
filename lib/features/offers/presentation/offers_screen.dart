import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import 'offer_navigation.dart';
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

  void _book(OfferModel offer) => openOfferBooking(context, offer);

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
