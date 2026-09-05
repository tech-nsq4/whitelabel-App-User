import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/location_helper.dart';
import '../../../../core/widgets/screen_state_layout.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../logic/doctors_cubit.dart';
import 'doctor_filter_chips.dart';
import 'doctor_list_tile.dart';
import 'search_bar_field.dart';
import 'specialty_options_list.dart';

/// Search bar + filter chips + the resulting doctors list, backed by
/// `GET /doctors`. Reused by `SpecsScreen` (scoped to one [specializationId])
/// and `DoctorSearchScreen` (either "Search by Doctor" — both filters null —
/// or a specific clinic's doctors via [clinicId]). Expects a [DoctorsCubit]
/// already provided above it.
class DoctorSearchList extends StatefulWidget {
  const DoctorSearchList({super.key, this.specializationId, this.clinicId});

  final int? specializationId;
  final int? clinicId;

  @override
  State<DoctorSearchList> createState() => _DoctorSearchListState();
}

class _DoctorSearchListState extends State<DoctorSearchList> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  DoctorSort? _selectedSort;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _fetch() {
    context.read<DoctorsCubit>().getDoctors(
          specializationId: widget.specializationId,
          clinicId: widget.clinicId,
          name: _searchController.text.trim(),
          sort: _selectedSort?.value,
          lat: _lat,
          lng: _lng,
        );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), _fetch);
  }

  Future<void> _onSortSelected(DoctorSort sort) async {
    if (_selectedSort == sort) {
      setState(() {
        _selectedSort = null;
        _lat = null;
        _lng = null;
      });
      _fetch();
      return;
    }

    if (sort.needsLocation) {
      final position = await LocationHelper.getCurrentPosition();
      if (!mounted) return;
      if (position == null) {
        AppOverlay.showError(LocaleKeys.booking_locationUnavailable.tr());
        return;
      }
      setState(() {
        _selectedSort = sort;
        _lat = position.latitude;
        _lng = position.longitude;
      });
      _fetch();
      return;
    }

    setState(() {
      _selectedSort = sort;
      _lat = null;
      _lng = null;
    });
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        final doctors = state is DoctorsSuccess ? state.doctors : const <DoctorProfileModel>[];

        return Column(
          children: [
            SearchBarField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hint: LocaleKeys.booking_searchDoctorHint.tr(),
            ),
            12.height,
            DoctorFilterChips(selected: _selectedSort, onSelect: _onSortSelected),
            Expanded(
              child: CustomScreenStateLayout(
                isLoading: state is DoctorsLoading || state is DoctorsInitial,
                error: state is DoctorsError
                    ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                    : null,
                onRetry: _fetch,
                isEmpty: state is DoctorsSuccess && doctors.isEmpty,
                builder: (context) => SpecialtyOptionsList(
                  padding: EdgeInsets.only(top: 6.h, bottom: 24.h),
                  itemCount: doctors.length,
                  itemBuilder: (context, i) {
                    final doc = doctors[i];
                    return DoctorListTile(
                      doctor: doc,
                      onTap: () => Navigator.pushNamed(context, Routes.doctor, arguments: {'id': doc.id}),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
