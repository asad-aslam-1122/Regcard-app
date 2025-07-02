import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/select_language_sheet.dart';
import 'package:sizer/sizer.dart';

import '../resources/resources.dart';
import 'bot_toast/zbot_toast.dart';

class BackgroundContainer extends StatefulWidget {
  final bool? showBackButton;
  final bool? showLanguageButton;
  final bool? showLogoutButton;
  final VoidCallback? onBack;
  const BackgroundContainer(
      {super.key,
      required this.showBackButton,
      this.onBack,
      this.showLanguageButton = true,
      this.showLogoutButton});

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(builder: (context, authVm, baseVm, _) {
      return Container(
        height: 30.h,
        // width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(R.images.background),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize:  MainAxisSize.max,
            children: [
              Visibility(
                visible: widget.showBackButton ?? true,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: widget.onBack ??
                        () {
                          Get.back();
                        },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: R.colors.white,
                      size: 20,
                    )),
              ),
              Visibility(
                visible: widget.showLanguageButton ?? false,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Get.bottomSheet(SelectLanguageSheet());
                    },
                    child: Text(
                      authVm.selectedLanguage == LanguageEnum.english.index
                          ? 'EN'
                          : "Fr",
                      style: R.textStyles.inter(
                          color: R.colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                    )),
              ),
              if (widget.showLogoutButton ?? false)
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () async {
                      ZBotToast.loadingShow();
                      await authVm.logout();
                    },
                    child: Image.asset(
                      R.images.logout,
                      scale: 5,
                    )),
            ],
          ),
        ),
      );
    });
  }
}
