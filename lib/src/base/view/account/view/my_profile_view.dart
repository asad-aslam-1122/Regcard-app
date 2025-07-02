import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/resources/localization/app_localization.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/account/view/billing_detail_view.dart';
import 'package:regcard/src/base/view/account/view/contact_detail_view.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/document_type_sheet.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/bot_toast/zbot_toast.dart';

class MyProfileView extends StatefulWidget {
  static String route = "/MyProfileView";
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  String? image = "";
  File? imageFile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(
        builder: (context, authVm, baseVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              appBar: titleAppBar(
                  title: 'my_profile',
                  titleCenter: true,
                  icon: Icons.arrow_back_ios_sharp),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    h3,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // image != ""
                        //     ? CircularProfileAvatar(
                        //   '',
                        //   radius: 55,
                        //   child: Image.file(
                        //     File(image ?? ""),
                        //     fit: BoxFit.cover,
                        //   ),
                        // )
                        //     :
                        // AppUser.userProfile?.pictureUrl != "" &&
                        //     AppUser.userProfile?.pictureUrl != null
                        //     ?
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
                        //     : CircularProfileAvatar(
                        //    "",
                        //   radius: 55,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color:
                        //         R.colors.textFieldFillColor,
                        //         shape: BoxShape.circle),
                        //   ),
                        // ),
                        InkWell(
                            onTap: () {
                              Get.bottomSheet(DocumentTypeSheet(
                                  showDocument: false,
                                  uploadImage: (value) async {
                                    ZBotToast.loadingShow();
                                    String url = "";
                                    if (value != null) {
                                      image = value.path;
                                      imageFile = value;

                                      url = await authVm
                                          .uploadImageUrl(imageFile);

                                      Map body = {
                                        "pictureUrl": url,
                                      };
                                      bool success = await baseVm
                                          .updateProfilePic(body: body);
                                      if (success) {
                                        await baseVm.getProfile();
                                        Get.forceAppUpdate();
                                        setState(() {
                                          ZBotToast.showToastSuccess(
                                              message:
                                                  'profile_picture_updated_successfully'
                                                      .L());
                                        });
                                      }
                                    }
                                  }));
                            },
                            child:
                                Image.asset(R.images.changeImage, scale: 3.5))
                      ],
                    ),
                    h1,
                    SizedBox(
                      width: 60.w,
                      child: Text(AppUser.userProfile?.fullName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w600, fontSize: 17.sp)),
                    ),
                    h3,
                    settingsTile("contact_details", () {
                      Get.toNamed(ContactDetailsView.route);
                    }),
                    settingsTile("billing_details", () {
                      Get.toNamed(BillingDetailView.route);
                    }),
                  ],
                ),
              ),
            ));
  }

  Widget settingsTile(String title, Function() onTap) {
    return InkWell(
      highlightColor: R.colors.transparent,
      splashColor: R.colors.transparent,
      onTap: onTap,
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
            Text(LocalizationMap.getTranslatedValues(title),
                style: R.textStyles.inter(fontSize: 12.sp)),
            Icon(Icons.arrow_forward_ios_rounded,
                color: R.colors.black, size: 15)
          ],
        ),
      ),
    );
  }
}
