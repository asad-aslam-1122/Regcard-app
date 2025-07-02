import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/app_user.dart';

class SharingView extends StatefulWidget {
  static String route = "/SharingView";
  const SharingView({super.key});

  @override
  State<SharingView> createState() => _SharingViewState();
}

class _SharingViewState extends State<SharingView> {
  bool qrVisible = false;
  bool shareCard = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(builder: (context, baseVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'sharing',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h3,
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: R.colors.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (qrVisible)
                          Text("scan_me".L(),
                              style: R.textStyles.inter(fontSize: 9.sp)),
                        const Spacer(),
                        baseVm.infoCardModel.regCardModifiedAt != '' ||
                                baseVm.infoCardModel.regCardModifiedAt
                                        ?.isNotEmpty ==
                                    true
                            ? Text(baseVm.infoCardModel.regCardModifiedAt ?? "",
                                style: R.textStyles
                                    .inter(fontSize: 11.sp, height: 0))
                            : const SizedBox(
                                width: 35,
                              ),
                        const SizedBox(height: 7)
                      ],
                    ),
                    Column(
                      // mainAxisAlignment: qrVisible ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        if (!qrVisible) ...{
                          h1,
                          Image.asset(R.images.appLogo, scale: 4),
                          h2P5,
                        } else ...{
                          QrImageView(
                            data: AppUser.url,
                            version: QrVersions.auto,
                            size: 80.0,
                            padding: EdgeInsets.zero,
                          ),
                          const Spacer()
                        },
                        SizedBox(
                          width: 45.w,
                          child: Text(AppUser.userProfile?.fullName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: R.textStyles.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.sp,
                                  height: 0)),
                        ),
                        const SizedBox(height: 5)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              setState(() {
                                qrVisible = !qrVisible;
                              });
                            },
                            child: Image.asset(
                              R.images.qrIcon,
                              scale: 4,
                            )),
                        h1,
                        Text("press_me".L(),
                            style:
                                R.textStyles.inter(fontSize: 6.sp, height: 0)),
                      ],
                    ),
                  ],
                ),
              ),
              h2,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
                margin: EdgeInsets.only(bottom: 1.5.h),
                decoration: BoxDecoration(
                  color: R.colors.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("sharing_your_regcard".L(),
                        style: R.textStyles.inter(fontSize: 13.sp)),
                    FlutterSwitch(
                      value: shareCard,
                      onToggle: (val) {
                        setState(() {
                          shareCard = val;
                        });
                      },
                      activeColor: R.colors.primaryColor,
                      height: 26,
                      width: 58,
                      padding: 2,
                    )
                  ],
                ),
              ),
              if (qrVisible) ...{
                Text("get_a_present_from_regcard_after_sharing_100_times".L(),
                    style: R.textStyles.inter(fontSize: 11.sp)),
                h0P5,
                Text("${"shared".L()} 0 ${"times".L()}",
                    style: R.textStyles.inter(fontSize: 11.sp)),
                h1,
                LinearProgressIndicator(
                  value: 0,
                  backgroundColor: R.colors.primaryColor.withOpacity(0.24),
                  color: R.colors.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  minHeight: 8,
                ),
                h1P5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("0",
                        style: R.textStyles.inter(
                            fontSize: 9.sp, color: R.colors.lightGreyColor)),
                    Text("100",
                        style: R.textStyles.inter(
                            fontSize: 9.sp, color: R.colors.lightGreyColor)),
                    Text("500",
                        style: R.textStyles.inter(
                            fontSize: 9.sp, color: R.colors.lightGreyColor)),
                  ],
                ),
                h2
              },
            ],
          ),
        ),
      );
    });
  }
}
