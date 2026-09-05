import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../booking/presentation/widgets/doctor_clinic_card.dart';
import '../../../booking/presentation/widgets/doctor_list_tile.dart';
import '../../../booking/presentation/widgets/specialty_option_tile.dart';
import '../../../booking/presentation/widgets/specialty_options_list.dart';
import '../../data/models/offer_model.dart';

class OfferTargetsList extends StatelessWidget {
  const OfferTargetsList({super.key, required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(top: 6.h, bottom: 24.h);
    final applied = offer.appliedOffer;

    switch (offer.scope) {
      case 'doctors':
        return SpecialtyOptionsList(
          padding: padding,
          itemCount: offer.doctors.length,
          itemBuilder: (context, i) {
            final doctor = offer.doctors[i];
            return DoctorListTile(
              doctor: doctor,
              offer: applied,
              onTap: () => Navigator.pushNamed(context, Routes.doctor, arguments: {
                'id': doctor.id,
                'appliedOffer': applied,
              }),
            );
          },
        );
      case 'clinics':
        return SpecialtyOptionsList(
          padding: padding,
          itemCount: offer.clinics.length,
          itemBuilder: (context, i) {
            final clinic = offer.clinics[i];
            return DoctorClinicCard(
              clinic: clinic,
              onBook: () => Navigator.pushNamed(context, Routes.doctorSearch, arguments: {
                'clinicId': clinic.id,
                'title': offer.name,
                'appliedOffer': applied,
              }),
            );
          },
        );
      case 'specializations':
        return SpecialtyOptionsList(
          padding: padding,
          itemCount: offer.specializations.length,
          itemBuilder: (context, i) {
            final specialization = offer.specializations[i];
            return SpecialtyOptionTile(
              title: specialization.title,
              description: specialization.description,
              onTap: () => Navigator.pushNamed(context, Routes.doctorSearch, arguments: {
                'specializationId': specialization.id,
                'title': specialization.title,
                'appliedOffer': applied,
              }),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
