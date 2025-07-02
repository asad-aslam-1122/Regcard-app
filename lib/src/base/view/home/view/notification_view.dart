import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/src/base/view/home/model/notifications_model.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/custom_footer.dart';

class NotificationView extends StatefulWidget {
  static String route = "/NotificationView";

  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading(HomeVm vm) async {
    ZBotToast.loadingShow();
    if (vm.notificationModel.hasNext == true) {
      await vm.getAllNotifications(
          pageNumber: (vm.notificationModel.currentPage ?? 0) + 1,
          isLoading: true);
    }
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh(HomeVm vm) async {
    ZBotToast.loadingShow();
    vm.notificationModel.items?.clear();
    vm.update();
    await vm.getAllNotifications(pageNumber: 1);
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Scaffold(
            appBar: titleAppBar(
                title: 'notifications',
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp),
            backgroundColor: R.colors.white,
            body: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(
                color: R.colors.white,
                backgroundColor: R.colors.primaryColor,
              ),
              footer: customFooter(
                  context, homeVm.notificationModel.hasNext ?? false),
              onLoading: () => onLoading(homeVm),
              onRefresh: () => onRefresh(homeVm),
              child: homeVm.notificationModel.items?.isEmpty == true
                  ? emptyScreen()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          h1,
                          ...List.generate(
                              homeVm.notificationModel.items?.length ?? 0,
                              (index) => notifications(
                                  homeVm.notificationModel.items?[index],
                                  homeVm))
                        ],
                      ),
                    ),
            )));
  }

  Widget notifications(NotificationItems? items, HomeVm vm) {
    return InkWell(
      onTap: () async {
        if (items?.isRead == false) {
          bool proceed = await vm.markAsSeen(notificationId: items?.id);
          if (proceed) {
            items!.isRead = true;
            if ((AppUser.userProfile?.unReadNotification ?? 0) > 0) {
              AppUser.userProfile?.unReadNotification =
                  (AppUser.userProfile?.unReadNotification ?? 0) - 1;
            }
          }
          setState(() {});
          vm.update();
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: items?.isRead == false
              ? R.colors.primaryColor.withOpacity(0.2)
              : R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              items?.description ?? '',
              style: R.textStyles.inter(
                  color: R.colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 9.sp),
            ),
            h0P3,
            Text(
              items?.createdAt ?? "",
              style: R.textStyles.inter(
                  color: R.colors.lightGreyColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 7.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_new_notifications'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        h1,
        Text(
          'no_new_notifications_desc'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
