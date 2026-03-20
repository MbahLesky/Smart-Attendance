import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoWordmark,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AppIconLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const AppIconLogo({
    super.key,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}
