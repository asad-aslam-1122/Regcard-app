import 'package:flutter/material.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../resources/resources.dart';
import 'app_button.dart';
import 'heights_widths.dart';

class CommonBottomSheet extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? firstButtonTitle;
  final String? secondButtonTitle;
  final VoidCallback? firstButtonOnTap;
  final VoidCallback? secondButtonOnTap;
  final bool? showFirstButton;
  final bool? showSecondButton;
  final bool willPop;
  final Widget? commonWidget;

  const CommonBottomSheet(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.showFirstButton,
      required this.showSecondButton,
      this.firstButtonTitle,
      this.secondButtonTitle,
      this.firstButtonOnTap,
      this.secondButtonOnTap,
      this.willPop = true,
      this.commonWidget});

  @override
  State<CommonBottomSheet> createState() => _CommonBottomSheetState();
}

class _CommonBottomSheetState extends State<CommonBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.willPop,
      child: Container(
        // height: (widget.showFirstButton  ?? false) || (widget.showSecondButton ?? false)  ? 28.h : 22.h ,
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.colors.bottomSheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(
              horizontal: 9.w,
            ) +
            EdgeInsets.only(top: 4.5.h),
        child: SafeAreaWidget(
          backgroundColor: R.colors.bottomSheetColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title?.L() ?? "",
                  textAlign: TextAlign.center,
                  style: R.textStyles.inter(
                      color: R.colors.black,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600),
                ),
                h0P5,
                Text(widget.subTitle?.L() ?? '',
                    textAlign: TextAlign.center,
                    style: R.textStyles.inter(
                      fontWeight: FontWeight.w400,
                      color: R.colors.black,
                      fontSize: 10.sp,
                    )),
                h1,
                widget.commonWidget ?? const SizedBox(),
                h4P5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.showFirstButton ?? true,
                      child: AppButton(
                        buttonTitle: widget.firstButtonTitle ?? 'no',
                        textSize: 10.sp,
                        onTap: widget.firstButtonOnTap ?? () {},
                        fontWeight: FontWeight.w500,
                        textColor: R.colors.white,
                        color: R.colors.black,
                        borderRadius: 25,
                        borderColor: R.colors.black,
                        //horizentalPadding: 18.w,
                        buttonWidth: 40.w,
                        textPadding: 0,
                      ),
                    ),
                    w2,
                    Visibility(
                      visible: widget.showSecondButton ?? true,
                      child: AppButton(
                        buttonTitle: widget.secondButtonTitle ?? 'yes',
                        textSize: 10.sp,
                        onTap: widget.secondButtonOnTap ?? () {},
                        fontWeight: FontWeight.w500,
                        textColor: R.colors.white,
                        color: R.colors.black,
                        borderRadius: 25,
                        borderColor: R.colors.black,
                        //horizentalPadding: 18.w,
                        textPadding: 0,
                        buttonWidth: 40.w,
                      ),
                    ),
                  ],
                ),
                h1
              ],
            ),
          ),
        ),
      ),
    );
  }
}
