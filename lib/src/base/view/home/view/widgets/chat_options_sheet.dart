import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view/settings/view/report_sheet.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/common_bottomsheet.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_button.dart';
import '../../../../../../utils/heights_widths.dart';

class ChatOptionSheet extends StatefulWidget {
  const ChatOptionSheet({super.key});

  @override
  State<ChatOptionSheet> createState() => _ChatOptionSheetState();
}

class _ChatOptionSheetState extends State<ChatOptionSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Container(
              // height: (widget.showFirstButton  ?? false) || (widget.showSecondButton ?? false)  ? 28.h : 22.h ,
              width: double.infinity,
              decoration: BoxDecoration(
                color: R.colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                  ) +
                  EdgeInsets.only(top: 4.h, bottom: 1.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (homeVm.otherUser?.isBlocked == true) ...{
                    tileWidget('unblock', () {
                      Get.back();
                      Get.bottomSheet(CommonBottomSheet(
                        title: 'unblock_member',
                        subTitle: 'unblock_member_desc',
                        showFirstButton: true,
                        showSecondButton: true,
                        firstButtonTitle: 'cancel',
                        firstButtonOnTap: () {
                          Get.back();
                        },
                        secondButtonTitle: 'unblock',
                        secondButtonOnTap: () async {
                          ZBotToast.loadingShow();
                          homeVm.otherUser?.isBlocked = false;
                          Get.back();
                          bool isSuccess = await homeVm.blockUser({
                            "userId": homeVm.otherUser?.id,
                            "isBlock": homeVm.otherUser?.isBlocked
                          });
                          ZBotToast.loadingClose();
                          if (isSuccess) {
                            Get.bottomSheet(CommonBottomSheet(
                              title: 'member_unblocked',
                              subTitle: 'member_unblocked_desc',
                              showFirstButton: false,
                              showSecondButton: false,
                            ));
                            Future.delayed(
                              Duration(seconds: 2),
                              () {
                                if (Get.isBottomSheetOpen == true) {
                                  Get.back();
                                }
                              },
                            );
                          }
                        },
                      ));
                    })
                  } else ...{
                    tileWidget('block', () {
                      Get.back();
                      Get.bottomSheet(CommonBottomSheet(
                        title: 'block_member',
                        subTitle: 'block_member_desc',
                        showFirstButton: true,
                        showSecondButton: true,
                        firstButtonTitle: 'cancel',
                        firstButtonOnTap: () {
                          Get.back();
                        },
                        secondButtonTitle: 'block',
                        secondButtonOnTap: () async {
                          ZBotToast.loadingShow();
                          homeVm.otherUser?.isBlocked = true;
                          Get.back();
                          bool isSuccess = await homeVm.blockUser({
                            "userId": homeVm.otherUser?.id,
                            "isBlock": homeVm.otherUser?.isBlocked
                          });
                          ZBotToast.loadingClose();
                          if (isSuccess) {
                            Get.bottomSheet(CommonBottomSheet(
                              title: 'member_blocked',
                              subTitle: 'member_blocked_desc',
                              showFirstButton: false,
                              showSecondButton: false,
                            ));
                            Future.delayed(
                              Duration(seconds: 2),
                              () {
                                if (Get.isBottomSheetOpen == true) {
                                  Get.back();
                                }
                              },
                            );
                          }
                        },
                      ));
                    }),
                    tileWidget('report', () {
                      Get.back();
                      Get.bottomSheet(ReportSheet());
                    }),
                  },
                  h1,
                  AppButton(
                    buttonTitle: 'close',
                    textSize: 10.sp,
                    onTap: () {
                      Get.back();
                    },
                    fontWeight: FontWeight.w500,
                    textColor: R.colors.white,
                    color: R.colors.black,
                    borderRadius: 25,
                    borderColor: R.colors.black,
                    textPadding: 0,
                    buttonWidth: 40.w,
                  )
                ],
              ),
            ));
  }

  Widget tileWidget(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.L(),
              style: R.textStyles.inter(
                  color: R.colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp),
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: R.colors.black,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
