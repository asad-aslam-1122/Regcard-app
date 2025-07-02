import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:regcard/resources/localization/app_localization.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/my_regcard/model/duration_model.dart';
import 'package:regcard/src/base/view/my_regcard/view/regcard_history_view.dart';
import 'package:regcard/src/base/view/my_regcard/view/regcard_webview.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/app_bars.dart';
import '../../../../../utils/widgets/code_painter.dart';
import '../../explore/view/split_payment/edit_and_delete_sheet.dart';
import '../model/reg_card_model.dart';

class MyRegCardView extends StatefulWidget {
  static String route = '/my_regcard_view';
  const MyRegCardView({
    super.key,
  });

  @override
  State<MyRegCardView> createState() => _MyRegCardViewState();
}

class _MyRegCardViewState extends State<MyRegCardView> {
  RegCardItems regCardItem = RegCardItems();
  bool qrVisible = true;
  bool enable = true;
  DurationModel? selectedDuration;

  @override
  void initState() {
    MyRegCardVm vm = context.read<MyRegCardVm>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (Get.arguments != null) {
          regCardItem = Get.arguments["regCardItem"];
          selectedDuration = vm.durationList.firstWhereOrNull(
            (element) => element.id == regCardItem.durationId,
          );
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRegCardVm>(builder: (context, myRegcardVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'sharing',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(RegcardHistoryView.route,
                    arguments: {"regCardItem": regCardItem});
              },
              child: Container(
                color: R.colors.transparent,
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.history,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text("history".L(),
                        style: R.textStyles.inter(
                          fontSize: 10.sp,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.6.h,
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: R.colors.greyBackgroundColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          SizedBox(
                            height: 5,
                          ),
                          Text("press_me".L(),
                              style: R.textStyles.inter(
                                  fontSize: 6.sp,
                                  height: 0,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(EditAndDeleteSheet(
                              onDeleteTab: () {}, onEditTab: () {}));
                        },
                        child: Icon(
                          Icons.more_horiz,
                        ),
                      ),
                    ],
                  ),
                  if (!qrVisible) ...[
                    Image.asset(R.images.appLogo, scale: 4),
                    Text(
                      regCardItem.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: R.textStyles.poppins(
                          fontSize: 16.sp,
                          color: R.colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(R.images.qrCorners))),
                      child: QrImageView(
                        data: regCardItem.url ?? "",
                        eyeStyle: QrEyeStyle(
                            color: R.colors.black, eyeShape: QrEyeShape.square),
                        version: QrVersions.auto,
                        size: 60,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Text(
                      "scan_me".L(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: R.textStyles.inter(
                          fontSize: 10.sp,
                          color: R.colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat("dd/yy").format(DateTime.parse(
                                  "${regCardItem.createdAt ?? DateTime.now().toString()}")),
                              style: R.textStyles.inter(
                                  fontSize: 9.sp, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              DateFormat("hh:mm a").format(DateTime.parse(
                                  "${regCardItem.createdAt ?? DateTime.now().toString()}")),
                              style: R.textStyles.inter(
                                  fontSize: 9.sp, fontWeight: FontWeight.w500),
                            ),
                          ]),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          R.images.viewImg,
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "${regCardItem.views ?? 0}",
                          style: R.textStyles.inter(
                            fontSize: 10.sp,
                          ),
                        ),
                      ]),
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
                    value: regCardItem.sharableMyQR ?? false,
                    onToggle: (val) async {
                      regCardItem.sharableMyQR =
                          !(regCardItem.sharableMyQR ?? false);
                      setState(() {});

                      // await myRegcardVm.shareQRCodeToggle(
                      //     id: regCardItem.id ?? 0,
                      //     value: regCardItem.sharableMyQR ?? false);
                    },
                    activeColor: R.colors.primaryColor,
                    height: 26,
                    width: 58,
                    padding: 2,
                  )
                ],
              ),
            ),
            h1,
            Text(
              "${"set_regcard_sharing_expiration".L()}:",
              style: R.textStyles.inter(fontWeight: FontWeight.w500),
            ),
            h1,
            Wrap(
              children: List.generate(
                myRegcardVm.durationList.length,
                (index) {
                  return SizedBox(
                    width: 30.w,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        radioTheme: RadioThemeData(
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return R.colors.primaryColor;
                            }
                            return R.colors.lightGreyColor;
                          }),
                        ),
                      ),
                      child: RadioMenuButton<DurationModel>(
                        style:
                            ButtonStyle(visualDensity: VisualDensity.compact),
                        value: myRegcardVm.durationList[index],
                        groupValue: selectedDuration,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDuration = newValue;
                          });
                        },
                        child: Text(
                          myRegcardVm.durationList[index].title ?? "",
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            h1,
            if (qrVisible) ...{
              Text("get_a_present_from_regcard_after_sharing_100_times".L(),
                  style: R.textStyles.inter(fontSize: 11.sp)),
              h0P5,
              Text(
                  "${"shared".L()} ${regCardItem.shareCount ?? 0} ${"times".L()}",
                  style: R.textStyles.inter(fontSize: 11.sp)),
              h1,
              LinearProgressIndicator(
                value: double.parse(
                    ((regCardItem.shareCount ?? 0) / 500).toString()),
                backgroundColor: R.colors.primaryColor.withValues(alpha: 0.24),
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
                  Text("250",
                      style: R.textStyles.inter(
                          fontSize: 9.sp, color: R.colors.lightGreyColor)),
                  Text("500",
                      style: R.textStyles.inter(
                          fontSize: 9.sp, color: R.colors.lightGreyColor)),
                ],
              ),
              h2
            },
            settingsTile(
                "check_again_your_documents",
                () => Get.toNamed(
                      RegcardWebView.route, /*arguments: {'isEditable':true}*/
                    ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: R.colors.black, size: 15)),
            if (regCardItem.sharableMyQR == true)
              settingsTile(
                  "copy_link",
                  () async => await Clipboard.setData(
                          ClipboardData(text: regCardItem.url ?? ""))
                      .then((value) => ZBotToast.showToastSuccess(
                          message: "link_copied".L())),
                  Image.asset(R.images.copyLink, scale: 4)),
            if (regCardItem.sharableMyQR == true)
              settingsTile(
                  "share",
                  !enable
                      ? null
                      : () async {
                          setState(() {
                            enable = false;
                          });
                          await shareQRImage(regCardItem);
                        },
                  Image.asset(R.images.shareIcon, scale: 4)),
          ]),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 12, left: 30.w, right: 30.w),
          child: AppButton(
            buttonTitle: 'save',
            textSize: 9.sp,
            onTap: () {},
            fontWeight: FontWeight.w500,
            textColor: R.colors.black,
            color: R.colors.textFieldFillColor,
            borderRadius: 25,
            borderColor: R.colors.black,
            horizentalPadding: 6.w,
            textPadding: 1.h,
          ),
        ),
      );
    });
  }

  Widget settingsTile(String title, Function()? onTap, Widget trailIcon) {
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
            trailIcon,
          ],
        ),
      ),
    );
  }

  Future shareQRImage(RegCardItems regCardItem) async {
    final image = await QrPainter(
      data: regCardItem.url ?? "",
      gapless: true,
      version: QrVersions.auto,
      eyeStyle: QrEyeStyle(color: R.colors.black, eyeShape: QrEyeShape.square),
    ).toImage(1000);
    final ByteData qrImageData = await CodePainter(
          qrImage: image,
          margin: 50,
        ).toImageData(1000) ??
        ByteData(0);

    String filename =
        "${(regCardItem.title ?? "qr_code").toLowerCase().replaceAll(" ", "_")}.png";
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$filename').create();
    var bytes = qrImageData.buffer.asUint8List();
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: regCardItem.url);
    setState(() {
      enable = true;
    });
  }

  bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}
