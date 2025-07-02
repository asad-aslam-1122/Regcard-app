import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/home/model/members_model.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/common_bottomsheet.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/bot_toast/zbot_toast.dart';

class ConnectMemberView extends StatefulWidget {
  static String route = "/ConnectMemberView";
  const ConnectMemberView({super.key});

  @override
  State<ConnectMemberView> createState() => _ConnectMemberViewState();
}

class _ConnectMemberViewState extends State<ConnectMemberView> {
  MembersItems? membersItems;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (Get.arguments != null) {
          membersItems = Get.arguments["member"];
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(builder: (context, homeVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: R.colors.white,
          title: Image.asset(R.images.appLogo, scale: 4),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              children: [
                h4,
                DisplayImage(
                    width: 190,
                    height: 190,
                    imageUrl: membersItems?.pictureUrl ?? '',
                    isCircle: true),
                h1P5,
                Text(membersItems?.fullName ?? "",
                    style: R.textStyles
                        .inter(fontWeight: FontWeight.w600, fontSize: 17.sp)),
                if (membersItems?.workPosition?.isNotEmpty ?? false)
                  Text(
                    ((membersItems?.workPosition?.isNotEmpty ?? false) &&
                            (membersItems?.company?.isNotEmpty ?? false))
                        ? "${membersItems?.workPosition} at ${membersItems?.company}, ${membersItems?.city}, ${membersItems?.country}."
                        : membersItems?.workPosition ?? "",
                    style: R.textStyles
                        .inter(fontWeight: FontWeight.w300, fontSize: 9.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                h5,
                Row(
                  children: [
                    Expanded(
                        child: AppButton(
                      buttonTitle: 'message',
                      textSize: 11.sp,
                      onTap: () async {
                        ZBotToast.loadingShow();
                        await homeVm.createChatHead(membersItems?.id ?? "");
                      },
                      fontWeight: FontWeight.w500,
                      textColor: R.colors.black,
                      color: R.colors.textFieldFillColor,
                      borderRadius: 25,
                      borderColor: R.colors.black,
                      textPadding: 1.5.h,
                    )),
                    if ((membersItems?.isRequestSent ?? false) == false) ...[
                      w2,
                      Expanded(
                          child: AppButton(
                        buttonTitle: 'connect',
                        textSize: 11.sp,
                        onTap: () {
                          Get.bottomSheet(CommonBottomSheet(
                            title: "send_request",
                            subTitle:
                                "Are_you_sure_you_want_to_send_this_request",
                            showFirstButton: true,
                            showSecondButton: true,
                            firstButtonOnTap: () {
                              Get.back();
                            },
                            secondButtonOnTap: () async {
                              ZBotToast.loadingShow();
                              bool isSend = await homeVm
                                  .sendRequest(membersItems?.id ?? "");
                              if (isSend) {
                                membersItems?.isRequestSent = true;
                              }
                              Get.back();
                              ZBotToast.loadingClose();
                            },
                          ));
                        },
                        fontWeight: FontWeight.w500,
                        textColor: R.colors.black,
                        color: R.colors.textFieldFillColor,
                        borderRadius: 25,
                        borderColor: R.colors.black,
                        textPadding: 1.5.h,
                      )),
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
