import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../family/data/models/family_member_model.dart';
import '../../../family/logic/family_cubit.dart';

/// "Book for" chip row inside `BookingSlotsSheet` — "Myself" (`null`) plus
/// every linked family member, fetched via [FamilyCubit].
class BookingFamilyMemberSelector extends StatelessWidget {
  const BookingFamilyMemberSelector({super.key, required this.selected, required this.onSelect});

  final FamilyMemberModel? selected;
  final ValueChanged<FamilyMemberModel?> onSelect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyCubit, FamilyState>(
      builder: (context, state) {
        final members = state is FamilySuccess ? state.members : const <FamilyMemberModel>[];
        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _MemberChip(
              label: LocaleKeys.booking_bookForSelf.tr(),
              isSelected: selected == null,
              onTap: () => onSelect(null),
            ),
            for (final member in members)
              _MemberChip(
                label: member.name,
                isSelected: selected?.id == member.id,
                onTap: () => onSelect(member),
              ),
          ],
        );
      },
    );
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? primary : AppColors.cardColor.themeColor,
          border: Border.all(color: isSelected ? Colors.transparent : AppColors.dividerColor.themeColor),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondaryColor.themeColor)),
      ),
    );
  }
}
