import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/utils/locale_keys.dart';
import 'package:vivacare_white_label/core/widgets/app_text.dart';
import 'package:vivacare_white_label/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';

class CustomScreenStateLayout extends StatelessWidget {
  final bool _isEmpty;
  final bool _isLoading;
  final ErrorModel? _error;
  final WidgetBuilder? _errorBuilder;
  final WidgetBuilder? _loadingBuilder;
  final VoidCallback? _onRetry;
  final WidgetBuilder _builder;
  final WidgetBuilder? _noDataBuilder;
  final Future<void> Function()? _onRefresh;
  const CustomScreenStateLayout({
    super.key,
    required WidgetBuilder builder,
    bool isEmpty = false,
    ErrorModel? error,
    bool isLoading = false,
    WidgetBuilder? errorBuilder,
    WidgetBuilder? loadingBuilder,
    WidgetBuilder? noDataBuilder,
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  })  : _isEmpty = isEmpty,
        _isLoading = isLoading,
        _error = error,
        _errorBuilder = errorBuilder,
        _loadingBuilder = loadingBuilder,
        _onRefresh = onRefresh,
        _noDataBuilder = noDataBuilder,
        _builder = builder,
        _onRetry = onRetry;

  @override
  Widget build(BuildContext context) {
    return _buildView(context);
  }

  Widget _buildView(BuildContext context) {
    if (_isLoading) {
      return _loadingBuilder != null
          ? _loadingBuilder(context)
          : Center(
              child: CustomLoadingWidget(
              color: AppColors.primaryColor.themeColor,
              size: 40,
            ));
    } else if (_error != null) {
      return _errorBuilder != null
          ? _errorBuilder(context)
          : CustomErrorView(
              errorModel: _error,
              onRetry: _onRetry,
            );
    } else if (_isEmpty) {
      return _noDataBuilder != null
          ? _noDataBuilder(context)
          : CustomNoDataView(
              onRefresh: _onRefresh,
            );
    } else {
      if (_onRefresh != null) {
        return RefreshIndicator(
            onRefresh: _onRefresh, child: _builder(context));
      } else {
        return _builder(context);
      }
    }
  }
}

class CustomNoDataView extends StatelessWidget {
  final String? _title;
  final String? _desc;
  final String? _image;
  final double _padding;
  final Future<void> Function()? _onRefresh;

  const CustomNoDataView({
    super.key,
    String? title,
    String? desc,
    String? image,
    double padding = 24,
    Future<void> Function()? onRefresh,
  })  : _title = title,
        _padding = padding,
        _onRefresh = onRefresh,
        _desc = desc,
        _image = image;

  @override
  Widget build(BuildContext context) {
    final onRefresh = _onRefresh;
    final scrollable = LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: onRefresh != null
            ? const AlwaysScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
          ),
          child: Padding(
            padding: EdgeInsets.all(_padding.r),
            child: Center(child: _body(context)),
          ),
        ),
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh, child: scrollable);
    }
    return scrollable;
  }

  Widget _body(BuildContext context) {
    final desc = _desc;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmptyStateIllustration(image: _image),
          20.height,
          AppText(
            _title ?? tr(LocaleKeys.common_noDataTitle),
            isHeading: true,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          8.height,
          AppText(
            desc != null && desc.isNotEmpty ? desc : tr(LocaleKeys.common_noDataDesc),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            height: 1.6,
            color: AppColors.mutedColor.themeColor,
          ),
        ],
      ),
    );
  }
}

class _EmptyStateIllustration extends StatelessWidget {
  const _EmptyStateIllustration({this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.primaryColor.themeColor;
    final image = this.image;
    return SizedBox(
      width: 132.w,
      height: 132.w,
      child: image != null
          ? Center(child: Image.asset(image, width: 100.w, height: 100.w))
          : CustomPaint(painter: _EmptyBoxPainter(color: accent)),
    );
  }
}

class _EmptyBoxPainter extends CustomPainter {
  _EmptyBoxPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Offset p(double fx, double fy) => Offset(w * fx, h * fy);
    Paint fill(double opacity) => Paint()..color = color.withValues(alpha: opacity);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(
      Rect.fromCenter(center: p(0.5, 0.9), width: w * 0.6, height: h * 0.085),
      fill(0.10),
    );

    final fl = p(0.24, 0.44);
    final fr = p(0.76, 0.44);
    final bkL = p(0.34, 0.34);
    final bkR = p(0.66, 0.34);

    final leftFlap = Path()
      ..moveTo(fl.dx, fl.dy)
      ..lineTo(w * 0.07, h * 0.40)
      ..lineTo(w * 0.14, h * 0.22)
      ..lineTo(bkL.dx, bkL.dy)
      ..close();
    final rightFlap = Path()
      ..moveTo(fr.dx, fr.dy)
      ..lineTo(w * 0.93, h * 0.40)
      ..lineTo(w * 0.86, h * 0.22)
      ..lineTo(bkR.dx, bkR.dy)
      ..close();
    for (final flap in [leftFlap, rightFlap]) {
      canvas.drawPath(flap, fill(0.05));
      canvas.drawPath(flap, stroke);
    }

    final mouth = Path()
      ..moveTo(fl.dx, fl.dy)
      ..lineTo(bkL.dx, bkL.dy)
      ..lineTo(bkR.dx, bkR.dy)
      ..lineTo(fr.dx, fr.dy)
      ..close();
    canvas.drawPath(mouth, fill(0.20));
    canvas.drawPath(mouth, stroke);

    final body = Path()
      ..moveTo(fl.dx, fl.dy)
      ..lineTo(fr.dx, fr.dy)
      ..lineTo(w * 0.72, h * 0.84)
      ..lineTo(w * 0.28, h * 0.84)
      ..close();
    canvas.drawPath(body, fill(0.10));
    canvas.drawPath(body, stroke);

    final dot = fill(0.5);
    canvas.drawCircle(p(0.5, 0.11), w * 0.023, dot);
    canvas.drawCircle(p(0.33, 0.18), w * 0.016, dot);
    canvas.drawCircle(p(0.67, 0.16), w * 0.016, dot);
  }

  @override
  bool shouldRepaint(_EmptyBoxPainter oldDelegate) => oldDelegate.color != color;
}

class CustomErrorView extends StatelessWidget {
  final ErrorModel? _errorModel;
  final VoidCallback? _onRetry;
  final String? _image;
  final String _imageSvg;

  const CustomErrorView({
    super.key,
    ErrorModel? errorModel,
    VoidCallback? onRetry,
    String? image,
    String imageSvg = AppImages.imagesErrorImage,
  })  : _errorModel = errorModel,
        _onRetry = onRetry,
        _image = image,
        _imageSvg = imageSvg;

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      message: _errorModel?.errorMessage ?? 'Error',
      onRetry: _onRetry,
      imageSvg: _imageSvg,
      image: _image,
    );
  }
}

class ErrorView extends StatelessWidget {
  final String? _message;
  final VoidCallback? _onRetry;
  final String? _image;
  final String _imageSvg;

  const ErrorView({
    super.key,
    String? message,
    VoidCallback? onRetry,
    String? image,
    String imageSvg = AppImages.imagesErrorImage,
  })  : _message = message,
        _onRetry = onRetry,
        _image = image,
        _imageSvg = imageSvg;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (_image != null)
                      ? Image.asset(_image)
                      : SvgPicture.asset(_imageSvg,
                          width: 200.w, height: 200.h, fit: BoxFit.fill),
                  AppText(
                    _message ?? '',
                    fontSize: 16.sp,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (_onRetry != null)
                    TextButton(
                      onPressed: _onRetry,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey)),
                      ),
                      child: Text(
                        tr(LocaleKeys.common_retry),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            )));
  }
}

class ErrorModel {
  final ErrorEnum code;
  final String errorMessage;
  final String? image;

  const ErrorModel({
    required this.code,
    required this.errorMessage,
    this.image,
  });

  @override
  String toString() {
    return 'ErrorModel{code: $code, errorMessage: $errorMessage, image: $image}';
  }
}

enum ErrorEnum {
  /// It occurs when url is opened timeout.
  connectTimeout,

  /// It occurs when url is sent timeout.
  sendTimeout,

  ///It occurs when receiving timeout.
  receiveTimeout,

  /// When the server response, but with a incorrect status, such as 404, 503...
  response,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// Default error type, Some other Error. In this case, you can
  /// use the DioError.error if it is not null.
  other,

  auth,
  server,
  verify,

  otherError
}
