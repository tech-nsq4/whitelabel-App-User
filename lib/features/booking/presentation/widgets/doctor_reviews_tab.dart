import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../data/models/doctor_review_model.dart';
import '../../logic/doctor_reviews_cubit.dart';
import 'doctor_rating_summary.dart';
import 'doctor_review_card.dart';

class DoctorReviewsTab extends StatefulWidget {
  const DoctorReviewsTab({super.key, required this.doctorId, this.avgRate});

  final int doctorId;
  final double? avgRate;

  @override
  State<DoctorReviewsTab> createState() => _DoctorReviewsTabState();
}

class _DoctorReviewsTabState extends State<DoctorReviewsTab> {
  static const int _previewCount = 3;

  late final DoctorReviewsCubit _cubit = getIt<DoctorReviewsCubit>();
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _cubit.getReviews(widget.doctorId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
        builder: (context, state) {
          final reviews =
              state is DoctorReviewsSuccess ? state.reviews : const <DoctorReviewModel>[];
          final showSummary = widget.avgRate != null || reviews.isNotEmpty;
          final rate = widget.avgRate ?? _averageOf(reviews);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showSummary) ...[
                DoctorRatingSummary(rate: rate, reviewsCount: reviews.length),
                14.height,
              ],
              ..._body(state, reviews),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _body(DoctorReviewsState state, List<DoctorReviewModel> reviews) {
    switch (state) {
      case DoctorReviewsInitial():
      case DoctorReviewsLoading():
        return [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CustomLoadingWidget(color: AppColors.primaryColor.themeColor, size: 32),
          ),
        ];
      case DoctorReviewsError(:final message):
        return [
          AppCard(
            child: Column(
              children: [
                AppText(
                  message,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                  color: AppColors.textSecondaryColor.themeColor,
                  height: 1.6,
                ),
                12.height,
                CustomButton(
                  title: LocaleKeys.common_retry.tr(),
                  isOutlined: true,
                  onTap: () => _cubit.getReviews(widget.doctorId),
                ),
              ],
            ),
          ),
        ];
      case DoctorReviewsSuccess():
        if (reviews.isEmpty) {
          return [
            AppCard(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Center(
                  child: AppText(
                    LocaleKeys.booking_noReviews.tr(),
                    fontSize: 12,
                    color: AppColors.mutedColor.themeColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ];
        }
        final showAll = _expanded || reviews.length <= _previewCount;
        final visible = showAll ? reviews : reviews.take(_previewCount).toList();
        return [
          for (final review in visible) ...[
            DoctorReviewCard(review: review),
            10.height,
          ],
          if (!showAll) ...[
            4.height,
            CustomButton(
              title: LocaleKeys.booking_viewAllReviews
                  .tr(namedArgs: {'count': '${reviews.length}'}),
              isOutlined: true,
              onTap: () => setState(() => _expanded = true),
            ),
          ],
        ];
    }
  }

  double _averageOf(List<DoctorReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (total, r) => total + r.rate);
    return sum / reviews.length;
  }
}
