import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/localization/app_localization.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/settings/view/admin_support_view.dart';
import 'package:regcard/src/base/view/settings/view/biometric_view.dart';
import 'package:regcard/src/base/view/settings/view/change_pass_sheet.dart';
import 'package:regcard/src/base/view/settings/view/connection_view.dart';
import 'package:regcard/src/base/view/settings/view/delete_acc_sheet.dart';
import 'package:regcard/src/base/view/settings/view/help_sheet.dart';
import 'package:regcard/src/base/view/settings/view/legal_documents_view.dart';
import 'package:regcard/src/base/view/settings/view/logout_sheet.dart';
import 'package:regcard/src/base/view/settings/view/notification_settings_view.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/common_bottomsheet.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/select_language_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/display_image.dart';
import '../../../model/social_link_model.dart';
import '../../../view_model/base_vm.dart';
import '../../explore/view/travel_guide_view.dart';
import '../../my_regcard/view/my_regcard_view.dart';

class SettingsView extends StatefulWidget {
  static String route = "/SettingsView";
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List settings = [
    "change_password",
    "biometrics",
    "notifications",
    "sharing",
    "invite_friend",
    "connections",
    "languages",
    "delete_account",
    "terms_and_conditions",
    "contact_us",
    "help",
    "logout"
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<BaseVm, AuthVm>(
        builder: (context, baseVm, authVm, child) => Scaffold(
            backgroundColor: R.colors.white,
            appBar: titleAppBar(
                title: 'settings',
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [
                  h1,
                  ...List.generate(settings.length,
                      (index) => settingsTile(index, baseVm, authVm)),
                  h2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        baseVm.socialLinks.length,
                        (index) {
                          SocialLink link = baseVm.socialLinks[index];
                          return InkWell(
                              onTap: () {
                                Get.toNamed(TravelGuideView.route,
                                    arguments: {"url": link.value ?? ""});
                              },
                              child: DisplayImage(
                                height: 30,
                                width: 30,
                                borderRadius: 0,
                                isCircle: false,
                                imageUrl: link.iconUrl,
                                isAllowOnTap: false,
                              ));
                        },
                      ),
                    ],
                  ),
                  h1,
                  Text("rights_reserve_statement".L(),
                      style: R.textStyles.inter(fontSize: 9.sp))
                ],
              ),
            )));
  }

  Widget settingsTile(int index, BaseVm baseVm, AuthVm authVm) {
    return InkWell(
      highlightColor: R.colors.transparent,
      splashColor: R.colors.transparent,
      onTap: () async {
        switch (index) {
          case 0:
            Get.bottomSheet(const ChangePassSheet(), isScrollControlled: true);
            break;
          case 1:
            Get.toNamed(BiometricView.route);
            break;
          case 2:
            Get.toNamed(NotificationSettingView.route);
            break;
          case 3:
            {
              Get.toNamed(MyRegCardView.route);
            }
            break;
          case 4:
            onTap3();
            break;
          case 5:
            {
              Get.toNamed(ConnectionView.route);
            }
            break;
          case 6:
            {
              Get.bottomSheet(const SelectLanguageSheet());
            }
            break;
          case 7:
            {
              Get.bottomSheet(const DeleteAccSheet());
            }
            break;
          case 8:
            Get.toNamed(LegalDocumentsView.route);
            break;

          case 9:
            Get.toNamed(AdminSupportView.route);
            break;
          case 10:
            Get.bottomSheet(const HelpSheet());
            break;
          case 11:
            {
              Get.bottomSheet(LogoutBottomSheet(
                title: "logout",
                onRightBtnPressed: () async {
                  ZBotToast.loadingShow();
                  await authVm.logout();
                },
              ));
            }
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        margin: EdgeInsets.only(bottom: 1.5.h),
        decoration: BoxDecoration(
          color: R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocalizationMap.getTranslatedValues(settings[index]),
                style: R.textStyles.inter(fontSize: 10.sp)),
            if (index != 9)
              Icon(Icons.arrow_forward_ios_rounded,
                  color: R.colors.black, size: 15)
          ],
        ),
      ),
    );
  }

  onTap3() {
    Get.bottomSheet(CommonBottomSheet(
      title: "invite",
      subTitle: "share_link_to_invite",
      showFirstButton: true,
      showSecondButton: true,
      commonWidget: Container(
        decoration: BoxDecoration(
            color: R.colors.textFieldFillColor.withOpacity(0.37),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("share_link_statement".L(),
                style: R.textStyles.inter(fontSize: 10.sp)),
            h1,
            Text("share_link".L(),
                style: R.textStyles.inter(
                    fontSize: 10.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: R.colors.primaryColor)),
          ],
        ),
      ),
      firstButtonTitle: "cancel",
      secondButtonTitle: "share",
      firstButtonOnTap: () {
        Get.back();
      },
      secondButtonOnTap: () async {
        await Share.share("${"share_link_statement".L()}\n${"share_link".L()}")
            .then((value) => Get.back());
      },
    ));
  }
}
