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
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../logic/doctors_cubit.dart';
import 'doctor_card.dart';
import 'doctor_sort.dart';
import 'search_bar_field.dart';
import 'specialty_options_list.dart';

/// Search + sort row, then the resulting doctors list, backed by
/// `GET /doctors`. Reused by `SpecsScreen` (scoped to one [specializationId],
/// optionally narrowed to a [subSpecializationId], with the specialty chip
/// rows dropped in via [belowSearch]) and `DoctorSearchScreen` (either "Search
/// by Doctor" — both filters null — or a specific clinic's doctors via
/// [clinicId]). Expects a [DoctorsCubit] already provided above it.
///
/// The search row and results carry [contentPadding] horizontally so
/// [belowSearch] can run edge to edge; the caller shouldn't pad this widget.
class DoctorSearchList extends StatefulWidget {
  const DoctorSearchList({
    super.key,
    this.specializationId,
    this.subSpecializationId,
    this.clinicId,
    this.offer,
    this.belowSearch,
    this.contentPadding,
  });

  final int? specializationId;
  final int? subSpecializationId;
  final int? clinicId;
  final AppliedOffer? offer;

  /// Rendered between the search row and the results — the specialty /
  /// sub-specialty chip rows on `SpecsScreen`.
  final Widget? belowSearch;

  /// Horizontal inset for the search row and the results list (default 20).
  final EdgeInsetsGeometry? contentPadding;

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
  void didUpdateWidget(covariant DoctorSearchList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.specializationId != widget.specializationId ||
        oldWidget.subSpecializationId != widget.subSpecializationId ||
        oldWidget.clinicId != widget.clinicId) {
      _fetch();
    }
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
          subSpecializationId: widget.subSpecializationId,
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

  Future<void> _openSortSheet() async {
    final result = await showDoctorSortSheet(context, current: _selectedSort);
    if (result == null || !mounted) return;
    final sort = result.sort;
    if (sort == null) {
      _clearSort();
    } else {
      await _applySort(sort);
    }
  }

  void _clearSort() {
    if (_selectedSort == null) return;
    setState(() {
      _selectedSort = null;
      _lat = null;
      _lng = null;
    });
    _fetch();
  }

  Future<void> _applySort(DoctorSort sort) async {
    if (sort == _selectedSort) return;

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
    } else {
      setState(() {
        _selectedSort = sort;
        _lat = null;
        _lng = null;
      });
    }
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      builder: (context, state) {
        final doctors = state is DoctorsSuccess ? state.doctors : const <DoctorProfileModel>[];

        final hPad = widget.contentPadding ?? EdgeInsetsDirectional.only(start: 20.w, end: 20.w);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: hPad,
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hint: LocaleKeys.booking_searchDoctorHint.tr(),
                    ),
                  ),
                  10.width,
                  DoctorSortButton(active: _selectedSort != null, onTap: _openSortSheet),
                ],
              ),
            ),
            12.height,
            if (widget.belowSearch != null) widget.belowSearch!,
            Expanded(
              child: Padding(
                padding: hPad,
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
                      return DoctorCard(
                        doctor: doc,
                        offer: widget.offer,
                        onTap: () => Navigator.pushNamed(context, Routes.doctor, arguments: {
                          'id': doc.id,
                          if (widget.offer != null) 'appliedOffer': widget.offer,
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
