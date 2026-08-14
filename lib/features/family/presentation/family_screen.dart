import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/guest_prompt.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/family_member_model.dart';
import '../logic/family_cubit.dart';
import 'widgets/add_family_member_sheet.dart';
import 'widgets/family_member_card.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  late final FamilyCubit _cubit = getIt<FamilyCubit>();

  @override
  void initState() {
    super.initState();
    // A guest has no `/family-members` to fetch — skip the (unauthenticated,
    // guaranteed-to-401) call entirely and show the sign-in prompt instead.
    if (!kIsGuest) _cubit.getFamilyMembers();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsGuest) {
      return Scaffold(
        body: SafeArea(
          child: GuestPrompt(
            title: LocaleKeys.family_guestTitle.tr(),
            description: LocaleKeys.family_guestDescription.tr(),
          ),
        ),
      );
    }

    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<FamilyCubit, FamilyState>(
        builder: (context, state) {
          final members = state is FamilySuccess ? state.members : const <FamilyMemberModel>[];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocaleKeys.family_title.tr(),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                      color: AppColors.mutedColor.themeColor)),
                              3.height,
                              AppText(
                                  LocaleKeys.family_membersCount.tr(namedArgs: {'count': '${members.length}'}),
                                  isHeading: true,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryColor.themeColor),
                            ],
                          ),
                        ),
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: AppColors.cardColor.themeColor,
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(color: AppColors.dividerColor.themeColor),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => showAddFamilyMemberSheet(context, cubit: _cubit),
                            icon: Icon(Icons.add_rounded, color: primary),
                          ),
                        ),
                      ],
                    ),
                    22.height,
                    Expanded(
                      child: CustomScreenStateLayout(
                        onRefresh:_cubit.getFamilyMembers,
                        isLoading: state is FamilyLoading || state is FamilyInitial,
                        error: state is FamilyError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: _cubit.getFamilyMembers,
                        builder: (context) => ListView(
                          padding: EdgeInsets.only(bottom: 110.h),
                          children: [
                            for (final m in members)
                              FamilyMemberCard(
                                member: m,
                                onTap: () => Navigator.pushNamed(context, Routes.member,
                                    arguments: {'member': m, 'cubit': _cubit}),
                              ),
                            AppCard(
                              onTap: () => showAddFamilyMemberSheet(context, cubit: _cubit),
                              borderColor: AppColors.dividerColor.themeColor,
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.add_rounded, color: AppColors.mutedColor.themeColor, size: 22.sp),
                                    6.height,
                                    AppText(LocaleKeys.family_addMember.tr(),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondaryColor.themeColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
