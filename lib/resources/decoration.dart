import 'package:flutter/material.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

class AppDecoration {
  InputDecoration dropDownDecoration(
      {Widget? preIcon,
      Widget? suffixIcon,
      double? radius,
      double? horizontalPadding,
      double? verticalPadding,
      double? iconMinWidth,
      Color? fillColor,
      Color? borderColor,
      FocusNode? focusNode,
      bool showCounter = false}) {
    return InputDecoration(
      counterText: showCounter ? null : '',
      prefixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 16, vertical: verticalPadding ?? 12),
      fillColor: fillColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
      prefixIcon: preIcon,
      suffixIcon: suffixIcon != null ? Container(child: suffixIcon) : null,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(
          color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      filled: true,
    );
  }

  InputDecoration fieldDecoration(
      {Widget? preIcon,
      required String hintText,
      Color? hintTextColor,
      String? labelText,
      Widget? suffixIcon,
      double? radius,
      double? horizontalPadding,
      double? verticalPadding,
      double? iconMinWidth,
      Color? fillColor,
      Color? borderColor,
      FocusNode? focusNode,
      TextStyle? hintTextStyle,
      bool showCounter = false}) {
    return InputDecoration(
      counterText: showCounter ? null : '',
      prefixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 16, vertical: verticalPadding ?? 12),
      fillColor: fillColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
      hintText: hintText.L(),
      hintStyle: hintTextStyle ??
          R.textStyles.inter(
            fontWeight: FontWeight.w300,
            color: hintTextColor ?? R.colors.black,
            fontSize: 10.sp,
          ),
      labelText: labelText,
      labelStyle: R.textStyles.inter(
        color: R.colors.black,
        fontSize: 8.sp,
      ),
      prefixIcon: preIcon,
      suffixIcon: suffixIcon != null ? Container(child: suffixIcon) : null,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(
          color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide:
            BorderSide(color: R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      filled: true,
    );
  }

  InputDecoration fieldBorderDecoration({
    Widget? preIcon,
    required String hintText,
    String? labelText,
    Widget? suffixIcon,
    double? radius,
    double? horizontalPadding,
    double? verticalPadding,
    double? iconMinWidth,
    Color? fillColor,
    Color? borderColor,
    Color? hintTextColor,
    FocusNode? focusNode,
    TextStyle? hintTextStyle,
  }) {
    return InputDecoration(
      prefixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: iconMinWidth ?? 42,
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 16, vertical: verticalPadding ?? 10),
      fillColor: fillColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
      hintText: hintText,
      hintStyle: hintTextStyle ??
          R.textStyles.inter(
            color: hintTextColor ?? R.colors.black,
            fontSize: 12.sp,
          ),
      labelText: labelText,
      labelStyle: R.textStyles.inter(
        color: R.colors.black,
        fontSize: 12.sp,
      ),
      prefixIcon: preIcon,
      suffixIcon: suffixIcon != null ? suffixIcon : null,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(
          color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(
            color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(
            color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(
            color: borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.red),
      ),
      filled: true,
    );
  }

  BoxDecoration boxDecoration(
      {double? radius,
      Color? backgroundColor,
      bool? useBorder,
      bool? giveShadow,
      Color? borderColor}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius ?? 10),
      color: backgroundColor ?? R.colors.white,
      border: (useBorder ?? false)
          ? Border.all(
              color:
                  borderColor ?? R.colors.textFieldFillColor.withOpacity(0.4),
              width: 1)
          : null,
      boxShadow: [
        giveShadow ?? false
            ? BoxShadow(
                color: R.colors.black.withOpacity(0.08),
                offset: const Offset(10.0, 0),
                blurRadius: 35.0,
              )
            : BoxShadow(),
      ],
    );
  }

  BoxDecoration boxDecorationCircular({double? radius, Color? color}) {
    return BoxDecoration(
      color: color ?? R.colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? 30.sp),
        topRight: Radius.circular(radius ?? 30.sp),
      ),
    );
  }
}
