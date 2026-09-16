import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

class PageArticleView extends StatelessWidget {
  const PageArticleView({
    super.key,
    required this.body,
    required this.icon,
  });

  final String body;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final paragraphs = body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return ListView(
      padding: EdgeInsets.only(top: 4.h, bottom: 32.h),
      children: [


        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) 14.height,
          AppText(
            paragraphs[i],
            fontSize: 13.5,
            height: 1.95,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ],
      ],
    );
  }
}
