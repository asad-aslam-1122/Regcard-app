import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/heights_widths.dart';

class LogoutBottomSheet extends StatelessWidget {
  final String title;
  final VoidCallback onRightBtnPressed;
  final double? height;

  const LogoutBottomSheet(
      {super.key,
      required this.title,
      required this.onRightBtnPressed,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: R.colors.bottomSheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.symmetric(
            horizontal: 7.w,
          ) +
          EdgeInsets.only(top: 2.5.h),
      child: Column(
        children: [
          Text(
            title.L(),
            textAlign: TextAlign.center,
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600),
          ),
          h1,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${"are_your_sure_you_want_to_logout".L()} ?",
              textAlign: TextAlign.center,
              style: R.textStyles.inter(
                  color: R.colors.black.withOpacity(0.7),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          h3,
          Row(
            children: [
              Expanded(
                  child: AppButton(
                onTap: () {
                  Get.back();
                },
                buttonTitle: "no",
                textSize: 10.sp,
                fontWeight: FontWeight.w500,
                textColor: R.colors.white,
                color: R.colors.black,
                borderRadius: 25,
                borderColor: R.colors.black,
                textPadding: 0,
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AppButton(
                  onTap: onRightBtnPressed,
                  buttonTitle: "yes",
                  textSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  textColor: R.colors.white,
                  color: R.colors.black,
                  borderRadius: 25,
                  borderColor: R.colors.black,
                  textPadding: 0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
