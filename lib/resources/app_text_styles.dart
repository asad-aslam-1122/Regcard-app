import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'resources.dart';

class AppTextStyles {
  TextStyle inter({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontStyle: fontStyle ?? null,
      fontSize: fontSize ?? 12.sp,
      color: color ?? R.colors.black,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0.48,
      height: height,
    );
  }

  TextStyle poppins(
      {TextDecoration? textDecoration,
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? letterSpacing,
      bool? needNoSpacing}) {
    return GoogleFonts.poppins(
      wordSpacing: (needNoSpacing ?? false) ? -5 : 0,
      fontSize: fontSize ?? 12.sp,
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0,
      decoration: textDecoration ?? TextDecoration.none,
    );
  }
}
