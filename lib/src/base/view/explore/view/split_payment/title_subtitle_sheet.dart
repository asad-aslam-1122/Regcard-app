import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

class TitleSubtitleSheet extends StatefulWidget {
  final String title;
  final String subTitle;

  const TitleSubtitleSheet(
      {super.key, required this.title, required this.subTitle});

  @override
  State<TitleSubtitleSheet> createState() => _TitleSubtitleSheetState();
}

class _TitleSubtitleSheetState extends State<TitleSubtitleSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(builder: (context, baseVm, _) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(
              horizontal: 7.w,
            ) +
            EdgeInsets.only(top: 2.5.h),
        child: SingleChildScrollView(
          child: SafeAreaWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title.L(),
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
                    widget.subTitle.L(),
                    textAlign: TextAlign.center,
                    style: R.textStyles.inter(
                        color: R.colors.black.withOpacity(0.7),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                h1,
              ],
            ),
          ),
        ),
      );
    });
  }
}
