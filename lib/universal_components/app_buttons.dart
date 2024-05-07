import 'package:flutter/material.dart';
import 'package:foap/helper/extension.dart';

import '../components/custom_texts.dart';
import '../theme/theme_icon.dart';
import '../util/app_config_constants.dart';
import 'package:get/get.dart';

class AppThemeBackButton extends StatelessWidget {
  const AppThemeBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      color: AppColorConstants.cardColor,
      child: ThemeIconWidget(ThemeIcon.backArrow).lP8,
    ).round(10).shadowWithBorder(borderWidth: 0).ripple(() {
      Get.back();
    });
  }
}

class AppThemeButton extends StatelessWidget {
  final String? text;
  final double? height;
  final double? width;
  final double? cornerRadius;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;

  final VoidCallback? onPress;

  const AppThemeButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.height,
    this.width,
    this.cornerRadius,
    this.leading,
    this.trailing,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 45,
      color: backgroundColor ?? AppColorConstants.themeColor.darken(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading != null ? leading!.hP8 : Container(),
          Center(
            child: BodyMediumText(
              text!,
              color: Colors.white,
              // style: TextStyle(
              //     fontSize: FontSizes.b3,
              //     fontWeight: TextWeight.medium,
              //     color: Colors.white),
            ).hP8,
          ),
          trailing != null ? trailing!.hP4 : Container()
        ],
      ),
    ).round(cornerRadius ?? 100).ripple(() {
      onPress!();
    });
  }
}

class AppThemeBorderButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPress;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final double? cornerRadius;
  final TextStyle? textStyle;
  final double? width;

  const AppThemeBorderButton(
      {Key? key,
      required this.text,
      required this.onPress,
      this.height,
      this.width,
      this.cornerRadius,
      this.borderColor,
      this.backgroundColor,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 50,
      color: backgroundColor,
      child: Center(
        child: Text(
          text!,
          style: textStyle ??
              TextStyle(
                  fontSize: FontSizes.b2,
                  fontWeight: TextWeight.medium,
                  color: AppColorConstants.mainTextColor),
        ).hP8,
      ),
    )
        .borderWithRadius(
            value: 1,
            radius: 100,
            color: borderColor ?? AppColorConstants.dividerColor)
        .ripple(onPress!);
  }
}
