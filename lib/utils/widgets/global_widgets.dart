import 'package:flutter/material.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../resources/resources.dart';

class GlobalWidgets {
  static Widget titleEmojiText(String text, String img,
      {double? fontSize, TextAlign? textAlign}) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: text.L(),
            style: R.textStyles.inter(
              fontSize: fontSize ?? 16.sp,
              color: R.colors.black,
            ),
          ),
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Image.asset(
                img,
                scale: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static labelText({required String title}) {
    return Text(title.L(),
        style:
            R.textStyles.inter(fontWeight: FontWeight.w500, fontSize: 11.sp));
  }
}
