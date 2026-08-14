import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';

/// A row of individually-boxed digit fields for entering the OTP code.
/// Auto-advances focus forward on input and backward on delete, and reports
/// the combined code via [onChanged] on every keystroke, calling
/// [onCompleted] once every box is filled.
class OtpInputBoxes extends StatefulWidget {
  const OtpInputBoxes({
    super.key,
    required this.length,
    required this.onChanged,
    this.onCompleted,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInputBoxes> createState() => OtpInputBoxesState();
}

class OtpInputBoxesState extends State<OtpInputBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Clears every box and refocuses the first one — used after a failed
  /// verification attempt or once a fresh code has been (re)sent.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged('');
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _code;
    widget.onChanged(code);
    if (code.length == widget.length) {
      FocusScope.of(context).unfocus();
      widget.onCompleted?.call(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Digits always read/type left-to-right, even inside an RTL (Arabic) layout.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: SizedBox(
              width: 56.w,
              height: 60.w,
              child: CustomTextField(
                hint: '',
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                autofocus: i == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                contentPadding: EdgeInsets.zero,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => _onDigitChanged(i, v),
                textStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
