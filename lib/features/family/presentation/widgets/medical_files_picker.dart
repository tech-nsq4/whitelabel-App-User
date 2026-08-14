import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_colors.dart';

/// Multi-image picker for the `medical_files[]` attachments on the
/// add-family-member form — a row of removable thumbnails plus an
/// "add photo" tile. Uses `readAsBytes`/`Image.memory` (not `dart:io File`)
/// so it works on web too.
class MedicalFilesPicker extends StatelessWidget {
  const MedicalFilesPicker({super.key, required this.files, required this.onChanged});

  final List<XFile> files;
  final ValueChanged<List<XFile>> onChanged;

  Future<void> _pick() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    onChanged([...files, ...picked]);
  }

  void _remove(int index) {
    final updated = [...files]..removeAt(index);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        for (var i = 0; i < files.length; i++) _Thumbnail(file: files[i], onRemove: () => _remove(i)),
        GestureDetector(
          onTap: _pick,
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.dividerColor.themeColor),
            ),
            child: Icon(Icons.add_a_photo_outlined, color: AppColors.mutedColor.themeColor, size: 22.sp),
          ),
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.file, required this.onRemove});

  final XFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: SizedBox(
            width: 64.r,
            height: 64.r,
            child: FutureBuilder<Uint8List>(
              future: file.readAsBytes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ColoredBox(color: AppColors.surfaceColor.themeColor);
                }
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              },
            ),
          ),
        ),
        Positioned(
          top: -6.r,
          right: -6.r,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(color: AppColors.errorColor.themeColor, shape: BoxShape.circle),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 13.sp),
            ),
          ),
        ),
      ],
    );
  }
}
