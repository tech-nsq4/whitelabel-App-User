import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../logic/doctors_cubit.dart';
import 'widgets/doctor_search_list.dart';

/// Doctors search/browse entry point, backed by `GET /doctors` (no
/// specialization filter at all — unlike the specialty drill-down on
/// [SpecsScreen]). Doubles as two entry points:
/// - `BookScreen` → "حسب الطبيب": [clinicId]/[title] both null, browses
///   every doctor.
/// - `BranchesScreen` → tapping a clinic: [clinicId] set and [title] is
///   that clinic's name, scoping the list to its doctors.
class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key, this.clinicId, this.title});

  final int? clinicId;
  final String? title;

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  late final DoctorsCubit _cubit = getIt<DoctorsCubit>();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
                ScreenHeader(title: widget.title ?? LocaleKeys.booking_byDoctor.tr()),
                Expanded(child: DoctorSearchList(clinicId: widget.clinicId)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
