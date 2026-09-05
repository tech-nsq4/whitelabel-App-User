import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../offers/data/models/applied_offer.dart';
import '../logic/doctors_cubit.dart';
import 'widgets/doctor_search_list.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key, this.clinicId, this.specializationId, this.title, this.offer});

  final int? clinicId;
  final int? specializationId;
  final String? title;
  final AppliedOffer? offer;

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
                Expanded(
                  child: DoctorSearchList(
                    clinicId: widget.clinicId,
                    specializationId: widget.specializationId,
                    offer: widget.offer,
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
