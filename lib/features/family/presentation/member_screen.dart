import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/models/family_member_model.dart';
import '../logic/family_cubit.dart';
import 'widgets/add_family_member_sheet.dart';
import 'widgets/member_info_row.dart';
import 'widgets/member_stat_card.dart';

/// There's no `GET /family-members/{id}` endpoint yet, so [member] is the
/// exact record from the `FamilyScreen` list — carried through navigation
/// instead of being re-fetched here. [cubit] is the *same* instance
/// `FamilyScreen` owns, passed through explicitly (a pushed route doesn't
/// inherit a locally-scoped `BlocProvider`) so editing here refreshes the
/// list underneath once we pop back.
class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key, required this.member, required this.cubit});

  final FamilyMemberModel member;
  final FamilyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<FamilyCubit, FamilyState>(
        builder: (context, state) {
          final current = state is FamilySuccess
              ? state.members.firstWhere((m) => m.id == member.id, orElse: () => member)
              : member;
          final age = current.age;

          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                children: [
                  ScreenHeader(
                    title: current.name,
                    subtitle: (current.phone != null && current.phone!.isNotEmpty) ? current.phone : null,
                    trailing: IconButton(
                      tooltip: LocaleKeys.family_editMember.tr(),
                      onPressed: () => showAddFamilyMemberSheet(context, cubit: cubit, initial: current),
                      icon: Icon(Icons.edit_outlined, color: AppColors.primaryColor.themeColor),
                    ),
                  ),
                  Row(children: [
                    if (age != null) ...[
                      Expanded(child: MemberStatCard(value: '$age', label: LocaleKeys.family_ageLabel.tr())),
                      8.width,
                    ],
                    Expanded(
                      child: MemberStatCard(
                          value: '${current.medicalFiles.length}', label: LocaleKeys.family_medicalFiles.tr()),
                    ),
                  ]),
                  18.height,
                  AppCard(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    child: Column(
                      children: [
                        MemberInfoRow(label: LocaleKeys.family_idNumber.tr(), value: current.idNumber ?? '—'),
                        MemberInfoRow(
                          label: LocaleKeys.profile_dateOfBirth.tr(),
                          value: current.dateOfBirth ?? '—',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
