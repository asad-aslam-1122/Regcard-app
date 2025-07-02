import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/account/view/my_profile_view.dart';
import 'package:regcard/src/base/view/explore/view/travel_guide_view.dart';
import 'package:regcard/src/base/view/explore/view/travel_guides_gridview.dart';
import 'package:regcard/src/base/view/home/model/travel_guides_model.dart';
import 'package:regcard/src/base/view/home/view/chats_view.dart';
import 'package:regcard/src/base/view/home/view/connect_with_members.dart';
import 'package:regcard/src/base/view/home/view/notification_view.dart';
import 'package:regcard/src/base/view/home/view/search_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/app_user.dart';
import '../../../../../utils/common_bottomsheet.dart';
import '../model/members_model.dart';
import 'connect_member_view.dart';

class HomeView extends StatefulWidget {
  static String route = "/HomeView";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double percentage = 0;
  final RefreshController travelRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController memberRefreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var vm = Provider.of<HomeVm>(context, listen: false);
      Future.delayed(
        const Duration(milliseconds: 500),
        () async {
          percentage = (await vm.getProfileCompletionPercentage()).toDouble();
        },
      );
      setState(() {});
    });
    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    BaseVm baseVm = context.read<BaseVm>();
    HomeVm homeVm = context.read<HomeVm>();
    await baseVm.getProfile();
    await homeVm.getHomeMembers();
    baseVm.update();
    homeVm.update();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void onLoad() async {
    BaseVm baseVm = context.read<BaseVm>();

    ZBotToast.loadingShow();

    await baseVm.getProfile();
    baseVm.update();

    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              body: Column(
                children: [
                  topContainerWidget(),
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      reverse: false,
                      enablePullUp: false,
                      header: WaterDropMaterialHeader(
                        color: R.colors.white,
                        backgroundColor: R.colors.primaryColor,
                      ),
                      onRefresh: () => onRefresh(),
                      onLoading: () => onLoad(),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            h1,
                            Text("your_profile".L(),
                                style: R.textStyles.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp)),
                            h1,
                            linearProfileWidget(),
                            h1P5,
                            if ((homeVm.travelGuidesModel.travelItems ?? [])
                                .isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("what_on".L(),
                                      style: R.textStyles.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp)),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(TravelGuideGridView.route);
                                    },
                                    child: Text("see_all".L(),
                                        style: R.textStyles.inter(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              h0P5,
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      ((homeVm.travelGuidesModel.travelItems
                                                      ?.length ??
                                                  0) >
                                              10)
                                          ? 10
                                          : (homeVm.travelGuidesModel
                                                  .travelItems?.length ??
                                              0),
                                      (index) => travelGuideWidget(homeVm
                                          .travelGuidesModel
                                          .travelItems?[index])),
                                ),
                              ),
                            ],
                            if ((homeVm.homeMembersModel.membersItems ?? [])
                                .isNotEmpty) ...[
                              h0P5,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("connect_with_members".L(),
                                      style: R.textStyles.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp)),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(ConnectWithMembers.route);
                                    },
                                    child: Text("see_all".L(),
                                        style: R.textStyles.inter(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      (homeVm.homeMembersModel.membersItems
                                              ?.length ??
                                          0),
                                      (index) => membersWidget(
                                          homeVm.homeMembersModel
                                              .membersItems?[index],
                                          homeVm)),
                                ),
                              ),
                            ],
                            h2
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget topContainerWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(R.images.background), fit: BoxFit.fill)),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(SearchView.route);
                      },
                      child: Image.asset(R.images.search, scale: 4),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(ChatsView.route);
                          },
                          child: badges.Badge(
                              showBadge:
                                  (AppUser.userProfile?.unReadChat ?? 0) > 0,
                              position:
                                  badges.BadgePosition.topEnd(top: -5, end: -5),
                              badgeContent: Text(
                                (AppUser.userProfile?.unReadChat ?? 0) > 99
                                    ? "99+"
                                    : (AppUser.userProfile?.unReadChat ?? 0)
                                        .toString(),
                                style: R.textStyles
                                    .inter(fontSize: 8, color: R.colors.white),
                              ),
                              child: Image.asset(R.images.message, scale: 4)),
                        ),
                        w1,
                        InkWell(
                          onTap: () {
                            Get.toNamed(NotificationView.route);
                          },
                          child: badges.Badge(
                              showBadge:
                                  (AppUser.userProfile?.unReadNotification ??
                                          0) >
                                      0,
                              position:
                                  badges.BadgePosition.topEnd(top: -5, end: -5),
                              badgeContent: Text(
                                (AppUser.userProfile?.unReadNotification ?? 0) >
                                        99
                                    ? "99+"
                                    : (AppUser.userProfile
                                                ?.unReadNotification ??
                                            0)
                                        .toString(),
                                style: R.textStyles
                                    .inter(fontSize: 8, color: R.colors.white),
                              ),
                              child:
                                  Image.asset(R.images.notification, scale: 4)),
                        ),
                      ],
                    )
                  ],
                ),
                Image.asset(R.images.appLogoWhite, scale: 4),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 60.w,
              child: Text(
                "${AppUser.userProfile?.fullName ?? ""}!",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: R.textStyles.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: R.colors.white),
              ),
            ),
            h0P5,
            Text(
              "explore_what_happening_around_the_world".L(),
              style: R.textStyles.inter(fontSize: 10.sp, color: R.colors.white),
            ),
            h1,
          ],
        ),
      ),
    );
  }

  Widget linearProfileWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
          color: R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          DisplayImage(
            imageUrl: AppUser.userProfile?.pictureUrl ?? '',
            isCircle: true,
            height: 70,
            width: 70,
          ),
          w1,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50.w,
                      child: Text(AppUser.userProfile?.fullName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: R.textStyles.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              height: 0)),
                    ),
                    InkWell(
                        onTap: () {
                          Get.toNamed(MyProfileView.route);
                        },
                        child: Image.asset(R.images.edit, scale: 3.5))
                  ],
                ),
                Text(
                  ((AppUser.userProfile?.workPosition?.isNotEmpty ?? false) &&
                          (AppUser.userProfile?.company?.isNotEmpty ?? false))
                      ? "${AppUser.userProfile?.workPosition} at ${AppUser.userProfile?.company}"
                      : AppUser.userProfile?.workPosition ?? "",
                  style: R.textStyles
                      .inter(fontWeight: FontWeight.w300, fontSize: 7.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                h1,
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage == 0 ? null : (percentage / 100),
                        backgroundColor:
                            R.colors.primaryColor.withOpacity(0.24),
                        color: R.colors.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                        minHeight: 8,
                      ),
                    ),
                    w1P5,
                    Text(
                      '${percentage.toInt()}%',
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 7.sp,
                          color: R.colors.primaryColor),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget travelGuideWidget(TravelGuidesItems? travelGuidesItems) {
    return InkWell(
      onTap: () {
        Get.toNamed(TravelGuideView.route, arguments: {
          'url': travelGuidesItems?.blogUrl,
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: travelGuidesItems?.thumbnailUrl ?? "",
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 55.w,
                height: 30.h,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
              width: 55.w,
              height: 30.h,
              padding: const EdgeInsets.only(right: 10),
              child: SpinKitPulse(
                color: R.colors.primaryColor,
              ),
            ),
            errorWidget: (context, url, error) => Container(
                margin: const EdgeInsets.only(right: 10),
                width: 55.w,
                height: 30.h,
                child: url.isEmpty
                    ? Image.asset(
                        R.images.spot1,
                        // scale: 1,
                      )
                    : const Icon(Icons.error)),
          ),
          Text("travel_guide".L(),
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w200, fontSize: 7.sp)),
          h0P5,
          SizedBox(
            width: 55.w,
            child: Text(travelGuidesItems?.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: R.textStyles
                    .inter(fontWeight: FontWeight.w500, fontSize: 10.sp)),
          ),
        ],
      ),
    );
  }

  Widget membersWidget(MembersItems? membersItems, HomeVm homeVm) {
    return Container(
      padding: const EdgeInsets.only(right: 10, top: 10),
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(ConnectMemberView.route,
                      arguments: {"member": membersItems});
                },
                child: DisplayImage(
                    width: 60,
                    height: 60,
                    isAllowOnTap: false,
                    imageUrl: membersItems?.pictureUrl ?? '',
                    isCircle: true),
              ),
              Positioned(
                right: 5,
                child: InkWell(
                  onTap: () {
                    if (membersItems?.isRequestSent == false) {
                      Get.bottomSheet(CommonBottomSheet(
                        title: "send_request",
                        subTitle: "Are_you_sure_you_want_to_send_this_request",
                        showFirstButton: true,
                        showSecondButton: true,
                        firstButtonOnTap: () {
                          Get.back();
                        },
                        secondButtonOnTap: () async {
                          ZBotToast.loadingShow();
                          bool isSend =
                              await homeVm.sendRequest(membersItems?.id ?? "");
                          if (isSend) {
                            membersItems?.isRequestSent = true;
                          }
                          Get.back();
                          ZBotToast.loadingClose();
                        },
                      ));
                    } else {
                      ZBotToast.showToastError(
                          message: 'Connection request already sent.');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: R.colors.primaryColor,
                        shape: membersItems?.isRequestSent == true
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        borderRadius: membersItems?.isRequestSent == true
                            ? null
                            : BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      membersItems?.isRequestSent == true
                          ? Icons.check
                          : Icons.add,
                      color: R.colors.white,
                      size: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 65,
            child: Text(membersItems?.fullName ?? "",
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: R.textStyles
                    .inter(fontWeight: FontWeight.w600, fontSize: 8.sp)),
          ),
          SizedBox(
            width: 65,
            child: Text(
              ((membersItems?.workPosition?.isNotEmpty ?? false) &&
                      (membersItems?.company?.isNotEmpty ?? false))
                  ? "${membersItems?.workPosition} at\n${membersItems?.company}"
                  : membersItems?.workPosition ?? "",
              textAlign: TextAlign.center,
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w300, fontSize: 7.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
