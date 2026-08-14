import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text_field.dart';

/// Read-only text field that opens a native date picker — used for
/// date-of-birth fields across the profile-completion and family-member
/// forms.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primaryColor.themeColor,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint,
      controller:
          TextEditingController(text: value != null ? _format(value!) : ''),
      readOnly: true,
      onTap: () => _pick(context),
      suffixIcon: Icon(
        Icons.calendar_month_rounded,
        color: AppColors.mutedColor.themeColor,
        size: 20,
      ),
    );
  }
}
