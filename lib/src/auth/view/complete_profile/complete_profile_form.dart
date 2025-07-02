import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view/complete_profile/form_1.dart';
import 'package:regcard/src/auth/view/complete_profile/form_2.dart';
import 'package:regcard/src/auth/view/complete_profile/form_3.dart';
import 'package:regcard/src/auth/view/complete_profile/form_4.dart';
import 'package:regcard/src/auth/view/complete_profile/form_5.dart';
import 'package:regcard/src/auth/view/complete_profile/form_6.dart';
import 'package:regcard/src/auth/view/complete_profile/form_7.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/background_container.dart';
import '../../../../utils/common_bottomsheet.dart';
import '../../../../utils/global_functions.dart';
import '../../../../utils/heights_widths.dart';
import '../../../base/view/base_view.dart';

class CompleteProfileForm extends StatefulWidget {
  static String route = "/CompleteProfileForm";

  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  List formsList = [
    const ProfileForm1(),
    const ProfileForm2(),
    const ProfileForm3(),
    const ProfileForm4(),
    const ProfileForm5(),
    const ProfileForm6(),
    const ProfileForm7(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm,BaseVm>(
        builder: (context, authVm,baseVm, child) =>  WillPopScope(
        onWillPop: GlobalFunctions.onBackPop,
        child:Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: R.colors.white,
              body: Stack(
                children: [
                  Column(
                    children: [
                      BackgroundContainer(
                        showBackButton:
                            authVm.completeProfilePageIndex == 0 ? false : true,
                        showLogoutButton: true,
                        showLanguageButton: false,
                        onBack: () {
                          if (authVm.completeProfilePageIndex != 0) {
                            authVm.completeProfilePageIndex =
                                authVm.completeProfilePageIndex - 1;
                            authVm.update();
                            authVm.completeProfilePageController
                                .jumpToPage(authVm.completeProfilePageIndex);
                          } else {
                            Get.back();
                          }
                        },
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 15.h, left: 5.w, right: 5.w),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                        color: R.colors.greyBackgroundColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      children: [
                        h1P5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${authVm.completeProfilePageIndex + 1}/${formsList.length}",
                              style: R.textStyles.inter(
                                color: R.colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                ZBotToast.loadingShow();
                                  if(authVm.completeProfilePageIndex != 6 ) {
                                    authVm.completeProfilePageIndex =
                                        authVm.completeProfilePageIndex + 1;
                                    authVm.update();
                                    bool check = await authVm.skipForm(id: authVm.completeProfilePageIndex);
                                    if (check) {
                                      // bool response = await authVm.getProfileWithSteps();
                                      // if (response) {
                                        authVm.completeProfilePageController
                                         .jumpToPage(authVm.completeProfilePageIndex);
                                      // }
                                    }
                                  }
                                  else{
                                    authVm.skipForm(id: 7);
                                    baseVm.getProfile();
                                    Get.bottomSheet(
                                        exitBottomSheetDuration: const Duration(milliseconds: 2500),
                                        const CommonBottomSheet(title: "congratulations", subTitle: "complete_profile_statement",
                                            showFirstButton: false, showSecondButton: false));
                                    Future.delayed(const Duration(milliseconds: 1500),() {
                                      authVm.completeProfilePageIndex = 0;
                                      authVm.update();
                                      Get.offAllNamed(BaseView.route);
                                    },);
                                  }
                                ZBotToast.loadingClose();
                              },
                              child: Text(
                                "skip".L(),
                                style: R.textStyles.inter(
                                  color: R.colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        h1,
                        Image.asset(
                          R.images.appLogo,
                          scale: 3,
                        ),
                        h3,
                        Expanded(
                          child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: authVm.completeProfilePageController,
                              onPageChanged: (val) {
                                authVm.completeProfilePageIndex = val;
                                authVm.update();
                              },
                              children: List.generate(formsList.length,
                                  (index) => formsList[index])),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
