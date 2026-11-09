import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/home_visit_area_model.dart';
import '../../data/models/home_visit_city_model.dart';
import '../../logic/home_visit_areas_cubit.dart';
import '../../logic/home_visit_cities_cubit.dart';
import 'home_visit_chips_row.dart';

class HomeVisitFilters extends StatelessWidget {
  const HomeVisitFilters({
    super.key,
    required this.selectedCity,
    required this.selectedArea,
    required this.onSelectCity,
    required this.onSelectArea,
    required this.onRetryCities,
    required this.onRetryAreas,
  });

  final HomeVisitCityModel? selectedCity;
  final HomeVisitAreaModel? selectedArea;
  final ValueChanged<HomeVisitCityModel> onSelectCity;
  final ValueChanged<HomeVisitAreaModel> onSelectArea;
  final VoidCallback onRetryCities;
  final VoidCallback onRetryAreas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(LocaleKeys.homeVisit_selectCity.tr(),
            fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimaryColor.themeColor),
        8.height,
        BlocBuilder<HomeVisitCitiesCubit, HomeVisitCitiesState>(
          builder: (context, state) => HomeVisitChipsRow<HomeVisitCityModel>(
            items: state is HomeVisitCitiesSuccess ? state.cities : const [],
            labelOf: (city) => city.name,
            idOf: (city) => city.id,
            selectedId: selectedCity?.id,
            onSelect: onSelectCity,
            emptyLabel: LocaleKeys.common_noDataTitle.tr(),
            onRetry: onRetryCities,
            isLoading: state is HomeVisitCitiesLoading || state is HomeVisitCitiesInitial,
            errorMessage: state is HomeVisitCitiesError ? state.message : null,
          ),
        ),
        if (selectedCity != null) ...[
          14.height,
          AppText(LocaleKeys.homeVisit_selectArea.tr(),
              fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimaryColor.themeColor),
          8.height,
          BlocBuilder<HomeVisitAreasCubit, HomeVisitAreasState>(
            builder: (context, state) => HomeVisitChipsRow<HomeVisitAreaModel>(
              items: state is HomeVisitAreasSuccess ? state.areas : const [],
              labelOf: (area) => area.name,
              idOf: (area) => area.id,
              selectedId: selectedArea?.id,
              onSelect: onSelectArea,
              emptyLabel: LocaleKeys.homeVisit_noAreas.tr(),
              onRetry: onRetryAreas,
              isLoading: state is HomeVisitAreasLoading || state is HomeVisitAreasInitial,
              errorMessage: state is HomeVisitAreasError ? state.message : null,
            ),
          ),
        ],
      ],
    );
  }
}
