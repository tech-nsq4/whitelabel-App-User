import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/screen_state_layout.dart';
import 'home_visit_choice_chip.dart';
import 'home_visit_inline_error.dart';

class HomeVisitChipsRow<T> extends StatelessWidget {
  const HomeVisitChipsRow({
    super.key,
    required this.items,
    required this.labelOf,
    required this.idOf,
    required this.selectedId,
    required this.onSelect,
    required this.emptyLabel,
    required this.onRetry,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<T> items;
  final String Function(T item) labelOf;
  final int Function(T item) idOf;
  final int? selectedId;
  final ValueChanged<T> onSelect;
  final String emptyLabel;
  final VoidCallback onRetry;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage;

    return SizedBox(
      height: 40.h,
      child: CustomScreenStateLayout(
        isLoading: isLoading,
        error: message == null ? null : ErrorModel(code: ErrorEnum.other, errorMessage: message),
        isEmpty: items.isEmpty,
        loadingBuilder: (_) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: CustomLoadingWidget(color: AppColors.primaryColor.themeColor, size: 24),
        ),
        errorBuilder: (_) => HomeVisitInlineError(message: message ?? '', onRetry: onRetry),
        noDataBuilder: (_) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppText(emptyLabel, fontSize: 11.5, color: AppColors.mutedColor.themeColor),
        ),
        builder: (_) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => 8.width,
          itemBuilder: (_, i) {
            final item = items[i];
            return Center(
              child: HomeVisitChoiceChip(
                label: labelOf(item),
                selected: idOf(item) == selectedId,
                onTap: () => onSelect(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
