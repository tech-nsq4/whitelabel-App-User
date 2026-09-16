import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/page_cubit.dart';
import 'widgets/page_article_view.dart';

class ContentPageScreen extends StatefulWidget {
  const ContentPageScreen({
    super.key,
    required this.slug,
    this.fallbackTitle,
    this.icon,
  });

  final String slug;
  final String? fallbackTitle;
  final String? icon;

  @override
  State<ContentPageScreen> createState() => _ContentPageScreenState();
}

class _ContentPageScreenState extends State<ContentPageScreen> {
  late final PageCubit _cubit = getIt<PageCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getPage(widget.slug);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<PageCubit, PageState>(
        builder: (context, state) {
          final page = state is PageSuccess ? state.page : null;
          final title = page?.localizedTitle(lang) ?? widget.fallbackTitle ?? '';
          final primary = AppColors.primaryColor.themeColor;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: title,

                    trailing:    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: AppSvgIcon( widget.icon ?? AppSvgIcons.document, size: 20.sp, color: primary),
                        ),
                      ),
                    ),
                    ),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading:
                            state is PageLoading || state is PageInitial,
                        error: state is PageError
                            ? ErrorModel(
                                code: ErrorEnum.other,
                                errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getPage(widget.slug),
                        builder: (context) => PageArticleView(
                          body: page!.localizedDescription(lang),
                          icon: widget.icon ?? AppSvgIcons.document,
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
