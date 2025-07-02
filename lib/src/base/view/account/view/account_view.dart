import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/src/base/view/account/view/my_profile_view.dart';
import 'package:regcard/src/base/view/account/view/my_regcard_document_view.dart';
import 'package:regcard/src/base/view/account/view/personalized_view.dart';
import 'package:regcard/src/base/view/account/view/preferences_view.dart';
import 'package:regcard/src/base/view/explore/view/my_records_view.dart';
import 'package:regcard/src/base/view/settings/view/settings_view.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/localization/app_localization.dart';
import '../../../../../resources/resources.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/heights_widths.dart';
import '../../my_regcard/view/regcard_webview.dart';

class AccountView extends StatefulWidget {
  static String route = '/account_view';

  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  List titles = [
    'my_profile',
    'my_regcard_documents',
    'my_records',
    'manage_settings',
    'my_preferences',
    'personalized',
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            h2,
            DisplayImage(
              imageUrl: AppUser.userProfile?.pictureUrl,
              borderColor: R.colors.lightGreyColor,
              borderWidth: 0,
              isCircle: true,
              hasMargin: false,
              height: 30.w,
              width: 30.w,
              hasBorder: true,
            ),
            h1,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                height: 30,
                child: Text(
                  AppUser.userProfile?.fullName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: R.textStyles
                      .inter(fontWeight: FontWeight.w600, fontSize: 15.sp),
                ),
              ),
            ),
            Text(
              [
                if ((AppUser.userProfile?.workPosition?.isNotEmpty ?? false) &&
                    (AppUser.userProfile?.company?.isNotEmpty ?? false))
                  '${AppUser.userProfile?.workPosition} at ${AppUser.userProfile?.company}'
                else
                  AppUser.userProfile?.workPosition ?? "",
                if ((AppUser.userProfile?.city ?? "").isNotEmpty)
                  AppUser.userProfile?.city,
                if ((AppUser.userProfile?.country ?? "").isNotEmpty)
                  AppUser.userProfile?.country,
              ].where((element) => element?.isNotEmpty ?? false).join(', '),
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w300, fontSize: 9.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            h2,
            AppButton(
              buttonTitle: 'share_profile',
              textSize: 9.sp,
              onTap: () {
                Get.toNamed(RegcardWebView.route,
                    arguments: {'isEditable': true});
              },
              fontWeight: FontWeight.w500,
              textColor: R.colors.black,
              color: R.colors.textFieldFillColor,
              borderRadius: 25,
              borderColor: R.colors.black,
              horizentalPadding: 13.w,
              textPadding: 1.5.h,
            ),
            h3,
            ...List.generate(titles.length, (index) => settingsTile(index))
          ],
        ),
      ),
    );
  }

  Widget settingsTile(int index) {
    return InkWell(
      highlightColor: R.colors.transparent,
      splashColor: R.colors.transparent,
      onTap: () {
        switch (index) {
          case 0:
            Get.toNamed(MyProfileView.route);
            break;
          case 1:
            Get.toNamed(MyRegcardDocumentView.route);
            break;
          case 2:
            Get.toNamed(MyRecordsView.route);
            break;
          case 3:
            Get.toNamed(SettingsView.route);
            break;
          case 4:
            Get.toNamed(PreferencesView.route);
            break;
          case 5:
            Get.toNamed(PersonalizedView.route);
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
            Text(LocalizationMap.getTranslatedValues(titles[index]),
                style: R.textStyles.inter(fontSize: 10.sp)),
            Icon(Icons.arrow_forward_ios_rounded,
                color: R.colors.black, size: 15)
          ],
        ),
      ),
    );
  }
}
