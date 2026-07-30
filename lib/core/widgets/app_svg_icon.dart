import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders one of the raw SVG strings in [AppSvgIcons] as a tintable icon.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.svg, {
    super.key,
    this.size = 22,
    this.color,
  });

  final String svg;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
