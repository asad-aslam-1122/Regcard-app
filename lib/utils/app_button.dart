import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';
import '../../resources/resources.dart';
import 'heights_widths.dart';

class AppButton extends StatefulWidget {
  final String buttonTitle;
  final GestureTapCallback onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double? textSize;
  final double? borderRadius;
  final double? borderWidth;
  final double? letterSpacing;
  final double? textPadding;
  final double? elevation;
  final FontWeight? fontWeight;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? horizontalMargin;
  final double? verticalMargin;

  final double? horizentalPadding;

  const AppButton({
    Key? key,
    required this.buttonTitle,
    required this.onTap,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.textColor,
    this.borderWidth,
    this.textSize,
    this.letterSpacing,
    this.fontWeight,
    this.textPadding,
    this.elevation,
    this.shadowColor,
    this.buttonWidth,
    this.buttonHeight,
    this.horizentalPadding,
    this.horizontalMargin,
    this.verticalMargin
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.horizontalMargin ?? 0, vertical: widget.verticalMargin ?? 0),
      height: widget.buttonHeight,width: widget.buttonWidth,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          elevation: widget.elevation ?? 0,
          padding: EdgeInsets.zero,
          side: BorderSide(
              color: widget.borderColor ?? R.colors.transparent, width: widget.borderWidth ?? 1),
          backgroundColor: widget.color ?? R.colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 28),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.textPadding ?? 11.sp, horizontal: widget.horizentalPadding ?? 0),
          child: Text(
            widget.buttonTitle.L(),
            textAlign: TextAlign.center,
            style: R.textStyles.inter(
                fontSize: widget.textSize ?? 12.sp,
                fontWeight: widget.fontWeight ?? FontWeight.w500,
                color: widget.textColor ?? R.colors.white,
                letterSpacing: widget.letterSpacing ?? 0.44),
          ),
        ),
      ),
    );
  }
}

////////////////////// 2nd button //////////////////
// ignore: must_be_immutable
class AppIconButton extends StatefulWidget {
  final String buttonTitle;
  final String image;
  final GestureTapCallback onTap;
  final Color? color;
  final Color? imageColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double? textSize;
  final double? borderRadius;
  final double? borderWidth;
  final double? letterSpacing;
  final double? textPadding;
  final double? elevation;
  final FontWeight? fontWeight;
  final double? buttonWidth;
  bool showInCenter;

  AppIconButton({
    Key? key,
    required this.buttonTitle,
    required this.onTap,
    required this.image,
    this.borderRadius,
    this.imageColor,
    this.color,
    this.borderColor,
    this.textColor,
    this.borderWidth,
    this.textSize,
    this.letterSpacing,
    this.fontWeight,
    this.textPadding,
    this.elevation,
    this.shadowColor,
    this.buttonWidth,
    this.showInCenter = false,
  }) : super(key: key);

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth ?? Get.width,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          elevation: widget.elevation ?? 0,
          padding: EdgeInsets.zero,
          side: BorderSide(
              color: widget.borderColor ?? R.colors.transparent, width: widget.borderWidth ?? 1.2),
          backgroundColor: widget.color ?? R.colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 28),
          ),
        ),
        child: widget.showInCenter == true
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: widget.textPadding ?? 12.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(widget.image, height: 8.sp, width: 8.sp, color: widget.imageColor),
                    w2,
                    Text(
                      widget.buttonTitle.L(),
                      textAlign: TextAlign.center,
                      style: R.textStyles.inter(
                          fontSize: widget.textSize ?? 12.sp,
                          fontWeight: widget.fontWeight ?? FontWeight.w500,
                          color: widget.textColor ?? R.colors.white,
                          letterSpacing: widget.letterSpacing ?? 0.44),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: widget.textPadding ?? 12.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    w1,
                    Image.asset(widget.image,
                        height: 18.sp, width: 18.sp, color: widget.imageColor),
                    w1,
                    Text(
                      widget.buttonTitle.L(),
                      textAlign: TextAlign.center,
                      style: R.textStyles.inter(
                          fontSize: widget.textSize ?? 11.sp,
                          fontWeight: widget.fontWeight ?? FontWeight.w500,
                          color: widget.textColor ?? R.colors.white,
                          letterSpacing: widget.letterSpacing ?? 0.44),
                    ),
                    w1,
                    Image.asset(
                      widget.image,
                      height: 18.sp,
                      width: 18.sp,
                      color: R.colors.transparent,
                    ),
                    w1,
                  ],
                ),
              ),
      ),
    );
  }
}
