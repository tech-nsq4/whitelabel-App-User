import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../booking/data/models/specialization_model.dart';
import '../../booking/logic/doctors_cubit.dart';
import '../../booking/logic/specializations_cubit.dart';
import '../../booking/presentation/widgets/doctor_search_list.dart';
import '../data/models/home_visit_area_model.dart';
import '../data/models/home_visit_city_model.dart';
import '../logic/home_visit_areas_cubit.dart';
import '../logic/home_visit_cities_cubit.dart';
import 'widgets/home_visit_filters.dart';
import 'widgets/home_visit_specialty_chips.dart';

class HomeVisitScreen extends StatefulWidget {
  const HomeVisitScreen({super.key});

  @override
  State<HomeVisitScreen> createState() => _HomeVisitScreenState();
}

class _HomeVisitScreenState extends State<HomeVisitScreen> {
  late final HomeVisitCitiesCubit _citiesCubit = getIt<HomeVisitCitiesCubit>();
  late final HomeVisitAreasCubit _areasCubit = getIt<HomeVisitAreasCubit>();
  late final SpecializationsCubit _specsCubit = getIt<SpecializationsCubit>();
  late final DoctorsCubit _doctorsCubit = getIt<DoctorsCubit>();
  HomeVisitCityModel? _selectedCity;
  HomeVisitAreaModel? _selectedArea;
  SpecializationModel? _selectedSpecialty;
  int? _selectedSubId;

  @override
  void initState() {
    super.initState();
    _citiesCubit.getCities();
    _specsCubit.getSpecializations();
  }

  @override
  void dispose() {
    _citiesCubit.close();
    _areasCubit.close();
    _specsCubit.close();
    _doctorsCubit.close();
    super.dispose();
  }

  void _onSelectCity(HomeVisitCityModel city) {
    final deselect = city.id == _selectedCity?.id;
    setState(() {
      _selectedCity = deselect ? null : city;
      _selectedArea = null;
    });
    if (deselect) {
      _areasCubit.reset();
    } else {
      _areasCubit.getAreas(city.id);
    }
  }

  void _onSelectArea(HomeVisitAreaModel area) {
    setState(() => _selectedArea = area.id == _selectedArea?.id ? null : area);
  }

  void _retryAreas() {
    final city = _selectedCity;
    if (city != null) _areasCubit.getAreas(city.id);
  }

  void _onSelectSpecialty(SpecializationModel? specialty) {
    setState(() {
      _selectedSpecialty = specialty;
      _selectedSubId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _citiesCubit),
        BlocProvider.value(value: _areasCubit),
        BlocProvider.value(value: _specsCubit),
        BlocProvider.value(value: _doctorsCubit),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenHeader(
                      title: LocaleKeys.homeVisit_title.tr(),
                      subtitle: LocaleKeys.homeVisit_screenSubtitle.tr(),
                    ),
                    HomeVisitFilters(
                      selectedCity: _selectedCity,
                      selectedArea: _selectedArea,
                      onSelectCity: _onSelectCity,
                      onSelectArea: _onSelectArea,
                      onRetryCities: _citiesCubit.getCities,
                      onRetryAreas: _retryAreas,
                    ),
                  ],
                ),
              ),
              12.height,
              Expanded(
                child: DoctorSearchList(
                  key: ValueKey('home-visit-${_selectedSpecialty?.id ?? 'all'}'),
                  homeVisitOnly: true,
                  homeVisitCityId: _selectedCity?.id,
                  homeVisitArea: _selectedArea,
                  specializationId: _selectedSpecialty?.id,
                  subSpecializationId: _selectedSubId,
                  belowSearch: HomeVisitSpecialtyChips(
                    selected: _selectedSpecialty,
                    selectedSubId: _selectedSubId,
                    onSelectSpecialty: _onSelectSpecialty,
                    onSelectSub: (id) => setState(() => _selectedSubId = id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
