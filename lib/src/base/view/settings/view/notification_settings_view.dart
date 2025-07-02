import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/settings/view_model/settings_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

class NotificationSettingView extends StatefulWidget {
  static String route = "/NotificationSettingView";
  const NotificationSettingView({super.key});

  @override
  State<NotificationSettingView> createState() =>
      _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsVm>(builder: (context, settingsVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'notifications',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              h3,
              ...List.generate(
                  settingsVm.notificationSettingsList.length,
                  (index) => NotificationTile(
                        index: index,
                      ))
            ],
          ),
        ),
      );
    });
  }
}

class NotificationTile extends StatefulWidget {
  final int index;
  const NotificationTile({super.key, required this.index});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsVm>(builder: (context, settingsVm, _) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
        margin: EdgeInsets.only(bottom: 1.5.h),
        decoration: BoxDecoration(
          color: R.colors.greyBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(settingsVm.notificationSettingsList[widget.index].title!.L(),
                style: R.textStyles.inter(fontSize: 13.sp)),
            FlutterSwitch(
              value: () {
                bool switchValue = false;
                switch (widget.index) {
                  case 0:
                    switchValue = AppUser.userProfile?.isChatReplies ?? false;
                    break;
                  case 1:
                    switchValue =
                        AppUser.userProfile?.isConnectionRequest ?? false;
                    break;
                  case 2:
                    switchValue =
                        AppUser.userProfile?.isNewsArticleUploaded ?? false;
                    break;
                  case 3:
                    switchValue =
                        AppUser.userProfile?.isSharingHistory ?? false;
                    break;
                  case 4:
                    switchValue = AppUser.userProfile
                            ?.isRequiresSharingRequestConfirmation ??
                        false;
                    break;
                  default:
                    switchValue = false;
                }
                return switchValue;
              }(),
              onToggle: (val) {
                switch (widget.index) {
                  case 0:
                    {
                      AppUser.userProfile?.isChatReplies =
                          !(AppUser.userProfile?.isChatReplies ?? false);
                      setState(() {});
                      settingsVm.userSettingsToggle(
                          type: widget.index,
                          value: AppUser.userProfile?.isChatReplies ?? false);
                    }
                  case 1:
                    {
                      AppUser.userProfile?.isConnectionRequest =
                          !(AppUser.userProfile?.isConnectionRequest ?? false);
                      setState(() {});
                      settingsVm.userSettingsToggle(
                          type: widget.index,
                          value: AppUser.userProfile?.isConnectionRequest ??
                              false);
                    }
                  case 2:
                    {
                      AppUser.userProfile?.isNewsArticleUploaded =
                          !(AppUser.userProfile?.isNewsArticleUploaded ??
                              false);
                      setState(() {});
                      settingsVm.userSettingsToggle(
                          type: widget.index,
                          value: AppUser.userProfile?.isNewsArticleUploaded ??
                              false);
                    }
                  case 3:
                    {
                      AppUser.userProfile?.isSharingHistory =
                          !(AppUser.userProfile?.isSharingHistory ?? false);
                      setState(() {});
                      settingsVm.userSettingsToggle(
                          type: widget.index,
                          value:
                              AppUser.userProfile?.isSharingHistory ?? false);
                    }
                  case 4:
                    {
                      AppUser.userProfile
                          ?.isRequiresSharingRequestConfirmation = !(AppUser
                              .userProfile
                              ?.isRequiresSharingRequestConfirmation ??
                          false);
                      setState(() {});
                      settingsVm.userSettingsToggle(
                          type: widget.index,
                          value: AppUser.userProfile
                                  ?.isRequiresSharingRequestConfirmation ??
                              false);
                    }
                }
              },
              activeColor: R.colors.primaryColor,
              height: 26,
              width: 58,
              padding: 2,
            )
          ],
        ),
      );
    });
  }
}
