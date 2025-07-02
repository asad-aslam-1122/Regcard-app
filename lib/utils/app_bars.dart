import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../resources/resources.dart';

AppBar titleAppBar({
  VoidCallback? onTap,
  String? title,
  Color? color,
  bool? titleCenter,
  Color? titleColor,
  IconData? icon,
  List<Widget>? actions,
  bool isTranslated = true,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: color ?? (R.colors.white),
    centerTitle: titleCenter ?? true,
    title: Text(
      isTranslated ? title?.L() ?? "" : title ?? '',
      style: R.textStyles.inter(
          fontSize: 13.sp,
          color: titleColor ?? R.colors.black,
          fontWeight: FontWeight.w600,
          letterSpacing: 0),
    ),
    leading: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          if (onTap == null) {
            Get.back();
          } else {
            onTap();
          }
        },
        // ()=>onTap??Get.back(),
        child: Icon(
          icon ?? Icons.arrow_back_ios_sharp,
          color: titleColor ?? R.colors.black,
          size: 25,
        )),
    actions: actions,
  );
}
