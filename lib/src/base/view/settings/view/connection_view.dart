import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view/settings/model/connections_model.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/display_image.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/custom_footer.dart';
import '../../home/model/chat_model.dart';
import '../view_model/settings_vm.dart';

class ConnectionView extends StatefulWidget {
  static String route = "/ConnectionView";
  const ConnectionView({super.key});

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading(SettingsVm vm) async {
    ZBotToast.loadingShow();
    if (vm.connectionsModel.hasNext == true) {
      await vm.getAllConnectionRequest(
          pageNumber: (vm.connectionsModel.currentPage ?? 0) + 1,
          isLoading: true);
    }
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh(SettingsVm vm) async {
    ZBotToast.loadingShow();
    vm.connectionsModel.connectionsItems?.clear();
    vm.update();
    await vm.getAllConnectionRequest(pageNumber: 1);
    ZBotToast.loadingClose();
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    SettingsVm vm = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        ZBotToast.loadingShow();
        await vm.getAllConnectionRequest(pageNumber: 1);
        ZBotToast.loadingClose();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsVm, HomeVm>(
        builder: (context, settingsVm, homeVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'connections',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: Column(
          children: [
            (settingsVm.connectionsModel.connectionsItems ?? []).isEmpty
                ? Expanded(
                    child: Center(
                    child: emptyScreen(),
                  ))
                : Expanded(
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropMaterialHeader(
                          color: R.colors.white,
                          backgroundColor: R.colors.primaryColor,
                        ),
                        footer: customFooter(context,
                            settingsVm.connectionsModel.hasNext ?? false),
                        onLoading: () => onLoading(settingsVm),
                        onRefresh: () => onRefresh(settingsVm),
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          itemCount: settingsVm
                                  .connectionsModel.connectionsItems?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return (settingsVm.connectionsModel
                                                .connectionsItems ??
                                            [])[index]
                                        .requestToUser ==
                                    null
                                ? SizedBox()
                                : userWidget(
                                    (settingsVm.connectionsModel
                                            .connectionsItems ??
                                        [])[index],
                                    settingsVm,
                                    homeVm);
                          },
                        )),
                  ),
          ],
        ),
      );
    });
  }

  Widget userWidget(
      ConnectionsItems model, SettingsVm settingsVm, HomeVm homeVm) {
    Sender sender = (model.requestToUser?.fullName ?? "") ==
            (AppUser.userProfile?.fullName ?? "")
        ? (model.requestByUser!)
        : (model.requestToUser!);
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          DisplayImage(
              width: 50,
              height: 50,
              isCircle: true,
              isProfileImage: true,
              imageUrl: sender.pictureUrl ?? ""),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sender.fullName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: R.textStyles
                        .inter(fontWeight: FontWeight.w600, fontSize: 13.sp)),
                if (sender.workPosition?.isNotEmpty ?? false)
                  Text(
                    ((sender.workPosition?.isNotEmpty ?? false) &&
                            (sender.company?.isNotEmpty ?? false))
                        ? "${sender.workPosition} at ${sender.company}"
                        : sender.workPosition ?? "",
                    style: R.textStyles
                        .inter(fontWeight: FontWeight.w300, fontSize: 9.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          w1,
          (model.status == ConnectionRequestStatus.accepted.index)
              ? Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          ZBotToast.loadingShow();
                          await homeVm.createChatHead(sender.id ?? "");
                        },
                        child: Image.asset(R.images.messageBlack, scale: 3.5)),
                    w2,
                    InkWell(
                      onTap: () async {
                        ZBotToast.loadingShow();
                        bool isRemoved =
                            await homeVm.removeConnection(model.id ?? 0);
                        if (isRemoved) {
                          (settingsVm.connectionsModel.connectionsItems ?? [])
                              .removeWhere(
                            (element) => element.id == model.id,
                          );
                          setState(() {});
                        }
                        ZBotToast.loadingClose();
                      },
                      child: Container(
                        height: 33,
                        width: 70,
                        decoration: BoxDecoration(
                            color: R.colors.textFieldFillColor,
                            border: Border.all(color: R.colors.black),
                            borderRadius: BorderRadius.circular(31)),
                        child: Center(
                            child: Text("remove".L(),
                                style: R.textStyles.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.sp))),
                      ),
                    )
                  ],
                )
              : Row(
                  children: [
                    InkWell(
                        onTap: () async {
                          ZBotToast.loadingShow();
                          var body = {
                            "connectionRequestId": model.id,
                            "status": ConnectionRequestStatus.rejected.index
                          };
                          bool isReject = await homeVm
                              .acceptOrRejectConnectionRequest(body: body);
                          if (isReject) {
                            (settingsVm.connectionsModel.connectionsItems ?? [])
                                .removeWhere(
                              (element) => element.id == model.id,
                            );
                            setState(() {});
                          }
                          ZBotToast.loadingClose();
                        },
                        child: Image.asset(
                          R.images.reject,
                          height: 35,
                          width: 35,
                        )),
                    w3,
                    InkWell(
                        onTap: () async {
                          ZBotToast.loadingShow();
                          var body = {
                            "connectionRequestId": model.id,
                            "status": ConnectionRequestStatus.accepted.index
                          };
                          bool isAccepted = await homeVm
                              .acceptOrRejectConnectionRequest(body: body);
                          if (isAccepted) {
                            model.status =
                                ConnectionRequestStatus.accepted.index;
                            setState(() {});
                          }
                          ZBotToast.loadingClose();
                        },
                        child: Image.asset(
                          R.images.accept,
                          height: 35,
                          width: 35,
                        )),
                  ],
                )
        ],
      ),
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'no_connections'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'no_connections_found'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
