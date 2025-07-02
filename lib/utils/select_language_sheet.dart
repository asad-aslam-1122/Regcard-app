import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import 'heights_widths.dart';

class SelectLanguageSheet extends StatefulWidget {
  const SelectLanguageSheet({super.key});

  @override
  State<SelectLanguageSheet> createState() => _SelectLanguageSheetState();
}

class _SelectLanguageSheetState extends State<SelectLanguageSheet> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var authVm = Provider.of<AuthVm>(context, listen: false);
      setState(() {
        selectedLanguage = authVm.selectedLanguage;
      });
    });
    super.initState();
  }

  int? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, authVm, _) {
      return Container(
        constraints: BoxConstraints(maxHeight: 45.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.colors.bottomSheetColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(top: 2.5.h),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: SafeAreaWidget(
            backgroundColor: R.colors.bottomSheetColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                h2,
                Text("languages".L(),
                    style: R.textStyles.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text("${"please_select_language".L()}.",
                      style: R.textStyles.inter(fontSize: 12.sp),
                      textAlign: TextAlign.center),
                ),
                h4,
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = 1;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 9.w, vertical: 1.h),
                    width: Get.width,
                    // height: 30,
                    color: selectedLanguage == LanguageEnum.french.index
                        ? R.colors.primaryColor.withOpacity(0.48)
                        : R.colors.transparent,
                    child: Text("french".L(),
                        style: R.textStyles.inter(fontSize: 13.sp)),
                  ),
                ),
                h2,
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = 0;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 9.w, vertical: 1.h),
                    width: Get.width,
                    // height: 30,
                    color: selectedLanguage == LanguageEnum.english.index
                        ? R.colors.primaryColor.withOpacity(0.48)
                        : R.colors.transparent,
                    child: Text("english".L(),
                        style: R.textStyles.inter(fontSize: 13.sp)),
                  ),
                ),
                h3,
                AppButton(
                  buttonTitle: 'save',
                  textSize: 10.sp,
                  onTap: () {
                    authVm.selectedLanguage = selectedLanguage ?? 0;
                    authVm.update();
                    Get.back();
                  },
                  fontWeight: FontWeight.w500,
                  textColor: R.colors.white,
                  color: R.colors.black,
                  borderRadius: 25,
                  borderColor: R.colors.black,
                  //horizentalPadding: 18.w,
                  buttonWidth: 40.w,
                  textPadding: 0,
                ),
                h1
              ],
            ),
          ),
        ),
      );
    });
  }
}
