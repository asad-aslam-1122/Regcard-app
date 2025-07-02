import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/constant/extensions.dart';
import 'package:regcard/services/custom_file_picker/pdf_view_widget.dart';
import 'package:regcard/src/base/view/home/model/chat_model.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/save_file_service.dart';
import '../../../../../utils/common_bottomsheet.dart';
import '../../../../../utils/display_image.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../../utils/image_preview.dart';
import '../../../../auth/view_model/auth_vm.dart';

class AdminSupportView extends StatefulWidget {
  static String route = "/AdminSupportView";

  const AdminSupportView({super.key});

  @override
  State<AdminSupportView> createState() => _AdminSupportViewState();
}

class _AdminSupportViewState extends State<AdminSupportView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TextEditingController chatTC = TextEditingController();
  FocusNode chatFN = FocusNode();
  bool isLoading = false;
  int pageNumber = 1;
  DateTime now = DateTime.now();

  Sender? otherUser;

  List<Message> msgList = [];

  @override
  void initState() {
    HomeVm homeVm = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      otherUser = Get.arguments["otherUser"];
      setState(() {});
      ZBotToast.loadingShow();
      await homeVm.initializeSignalR();
      await homeVm.readChat();
      await Future.delayed(Duration(seconds: 1), () {
        homeVm.scrollToEnd();
      });
      ZBotToast.loadingClose();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(
        builder: (context, homeVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: R.colors.white,
                forceMaterialTransparency: true,
                centerTitle: false,
                leadingWidth: 40,
                title: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: R.colors.darkBrown,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(R.images.appLogo),
                      ),
                    ),
                    w1P5,
                    Expanded(
                      child: Text(
                        "admin_support".L(),
                        style: R.textStyles.inter(
                            fontSize: 12.sp,
                            color: R.colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
                leading: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: R.colors.black,
                      size: 25,
                    )),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        color: R.colors.white,
                        backgroundColor: R.colors.primaryColor,
                        onRefresh: () async {},
                        child: ListView.builder(
                          controller: homeVm.controller,
                          itemCount: homeVm.adminChatModel.message?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _getGroupSeparator(
                                    homeVm.adminChatModel.message ?? [], index),
                                homeVm.adminChatModel.message?[index].sender
                                            ?.id ==
                                        AppUser.userProfile?.id
                                    ? sendMsg(
                                        (homeVm.adminChatModel.message ??
                                            [])[index],
                                        index)
                                    : receivedMsg(
                                        (homeVm.adminChatModel.message ??
                                            [])[index],
                                        index)
                              ],
                            );
                          },
                        )),
                  ),
                  homeVm.otherUser?.isBlocked == true
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 2.w),
                          color: R.colors.white,
                          // child: Text(
                          //   'block_contact_desc'.L(),
                          //   style: R.textStyles.inter(
                          //       color: R.colors.black,
                          //       fontSize: 11.sp,
                          //       fontWeight: FontWeight.w400),
                          //
                          // ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Block contact. ",
                                    style: R.textStyles.inter(
                                        color: R.colors.black,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: "Unblock",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
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
                                            bool isSuccess = await homeVm
                                                .blockUser({
                                              "userId": homeVm.otherUser?.id,
                                              "isBlock":
                                                  homeVm.otherUser?.isBlocked
                                            });
                                            ZBotToast.loadingClose();
                                            if (isSuccess) {
                                              Get.bottomSheet(CommonBottomSheet(
                                                title: 'member_unblocked',
                                                subTitle:
                                                    'member_unblocked_desc',
                                                showFirstButton: false,
                                                showSecondButton: false,
                                              ));
                                              Future.delayed(
                                                Duration(seconds: 2),
                                                () {
                                                  if (Get.isBottomSheetOpen ==
                                                      true) {
                                                    Get.back();
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        ));
                                      },
                                    style: R.textStyles
                                        .inter(
                                            color: R.colors.black,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500)
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline)),
                                TextSpan(
                                    text: " to chat.",
                                    style: R.textStyles.inter(
                                        color: R.colors.black,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        )
                      : bottomSendMessage(homeVm)
                ],
              ),
              // bottomSheet: bottomSendMessage(),
            ));
  }

  Widget bottomSendMessage(HomeVm homeVm) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.w),
      color: R.colors.white,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowMultiple: false,
                allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
              );
              chatFN.unfocus();

              if (result != null) {
                List<PlatformFile> p = result.files
                    .map((e) =>
                        PlatformFile(name: e.name, size: e.size, path: e.path))
                    .toList();
                String fileType = p.first.extension.toString();
                if ((fileType == FileTypeEnum.jpg.name ||
                    fileType == FileTypeEnum.jpeg.name ||
                    fileType == FileTypeEnum.png.name ||
                    fileType == FileTypeEnum.pdf.name)) {
                  setState(() {
                    isLoading = true;
                  });
                  String url = await context
                      .read<AuthVm>()
                      .uploadImageUrl(File(p.first.path ?? ""));

                  var body = {
                    "chatHeadId": homeVm.chatHead.chatHeadId,
                    "messageType": MessageTypeEnum.image.index,
                    "url": url,
                    "name": p.first.name,
                    "size": p.first.size.toString(),
                    "extension": p.first.extension
                  };
                  await homeVm.sendMessage(body);
                  Future.delayed(Duration(seconds: 1), () {
                    homeVm.scrollToEnd();
                  });
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  ZBotToast.showToastError(
                      message: "File format not supported.");
                }
              } else {
                ZBotToast.showToastError(message: "No file selected.");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: R.colors.primaryColor),
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 7, left: 5),
              child: Icon(
                Icons.add,
                color: R.colors.white,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: chatTC,
              focusNode: chatFN,
              style: R.textStyles
                  .inter(fontSize: 10.sp, fontWeight: FontWeight.w300),
              onTap: () {
                Future.delayed(Duration(seconds: 1), () {
                  homeVm.scrollToEnd();
                });
              },
              decoration: R.decoration
                  .fieldBorderDecoration(
                      fillColor: R.colors.greyBackgroundColor,
                      borderColor: R.colors.greyBackgroundColor,
                      hintText: "type_a_message".L(),
                      hintTextStyle: R.textStyles
                          .inter(fontSize: 10.sp, fontWeight: FontWeight.w300),
                      radius: 25,
                      suffixIcon: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: SpinKitDualRing(
                                color: R.colors.primaryColor,
                                size: 20,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (chatTC.text.trim().isNotEmpty) {
                                  var body = {
                                    "chatHeadId": homeVm.chatHead.chatHeadId,
                                    "message": chatTC.text.trim(),
                                    "messageType": MessageTypeEnum.text.index,
                                  };
                                  await homeVm.sendMessage(body);
                                  homeVm.scrollToEnd();
                                  chatTC.clear();
                                  setState(() {});
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  R.images.sendButton,
                                  scale: 4.5,
                                ),
                              ),
                            ))
                  .copyWith(
                      contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ) +
                          const EdgeInsets.only(left: 10)),
            ),
          ),
          w3,
        ],
      ),
    );
  }

  Widget receivedMsg(Message msg, int index) {
    String? formattedDate = DateFormat('dd MMM, hh:mm a')
        .format(DateTime.parse(msg.sendTime ?? now.toIso8601String()));

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: R.colors.darkBrown,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(R.images.appLogo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 5),
                      decoration: BoxDecoration(
                          color: R.colors.greyBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(30),
                          )),
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.7,
                      ),
                      child: msg.messageType == MessageTypeEnum.image.index
                          ? sendFile(msg: msg, isSender: false)
                          : Column(
                              children: [
                                Text(
                                  msg.message ?? "",
                                  style: R.textStyles.inter(
                                      color: R.colors.black,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                h0P5,
                              ],
                            )),
                  Text(formattedDate,
                      style: R.textStyles.inter(
                          color: R.colors.lightGreyColor, fontSize: 8.sp))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sendMsg(Message msg, int index) {
    String? formattedDate = DateFormat('dd MMM, hh:mm a')
        .format(DateTime.parse(msg.sendTime ?? now.toIso8601String()));

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 5),
                    decoration: BoxDecoration(
                        color: R.colors.greyBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(15),
                        )),
                    constraints: BoxConstraints(
                      maxWidth: Get.width * 0.7,
                    ),
                    child: msg.messageType == MessageTypeEnum.image.index
                        ? sendFile(msg: msg, isSender: true)
                        : Column(
                            children: [
                              Text(
                                msg.message ?? "",
                                style: R.textStyles.inter(
                                    color: R.colors.black,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              h0P5,
                            ],
                          ),
                  ),
                  Text(formattedDate,
                      style: R.textStyles.inter(
                          color: R.colors.lightGreyColor, fontSize: 8.sp))
                ],
              ),
            ),
            DisplayImage(
              imageUrl: AppUser.userProfile?.pictureUrl ?? "",
              borderColor: R.colors.lightGreyColor,
              borderWidth: 0,
              isCircle: true,
              hasMargin: false,
              height: 10.w,
              width: 10.w,
              hasBorder: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget sendFile({required Message msg, required bool isSender}) {
    return GestureDetector(
      onTap: () async {
        ZBotToast.loadingShow();
        await SaveFileService.downloadFile(msg.url ?? "", msg.name ?? "");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: isSender
              ? BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(11),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                  topLeft: Radius.circular(20),
                ),
        ),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                if (msg.extension == "pdf") {
                  Get.to(() => PDFViewWidget(
                        path: "",
                        fromUrl: true,
                        url: msg.url ?? "",
                      ));
                } else if (msg.extension == "jpeg" ||
                    msg.extension == "jpg" ||
                    msg.extension == "png") {
                  Get.to(() => ImageViewScreen(
                      imageProvider: NetworkImage(msg.url ?? "")));
                } else {
                  ZBotToast.loadingShow();
                  await SaveFileService.downloadFile(
                      msg.url ?? "", msg.name ?? "");
                }
              },
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: R.colors.greyBackgroundColor,
                    image: (msg.extension == "jpeg" ||
                            msg.extension == "jpg" ||
                            msg.extension == "png")
                        ? DecorationImage(
                            image: NetworkImage(msg.url ?? ""),
                            fit: BoxFit.cover)
                        : null),
                child: (msg.extension == "jpeg" ||
                        msg.extension == "jpg" ||
                        msg.extension == "png")
                    ? SizedBox(
                        height: 60,
                        width: 60,
                      )
                    : msg.extension == "pdf"
                        ? Container(
                            padding: const EdgeInsets.only(top: 19),
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                              R.images.pdf,
                            ))),
                          )
                        : Container(
                            padding: const EdgeInsets.only(top: 19),
                            alignment: Alignment.center,
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                              R.images.document,
                            ))),
                            child: Text(
                              msg.extension?.toUpperCase() ?? "",
                              style: R.textStyles.inter(
                                  color: R.colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
              ),
            ),
            h1,
            Text(
              msg.name ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: R.textStyles.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: R.colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (int.parse(msg.size ?? "")).getFileSizeString(),
                  style: R.textStyles.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: R.colors.black),
                ),
                Image.asset(
                  R.images.download,
                  height: 20,
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getGroupSeparator(List<Message> conversation, int index) {
    DateTime currentDate = DateTime(
      DateTime.parse((conversation[index].sendTime ?? now.toIso8601String()))
          .year,
      DateTime.parse((conversation[index].sendTime ?? now.toIso8601String()))
          .month,
      DateTime.parse((conversation[index].sendTime ?? now.toIso8601String()))
          .day,
    );

    DateTime? previousDate;
    if (index > 0) {
      previousDate = DateTime(
        DateTime.parse(
                (conversation[index - 1].sendTime ?? now.toIso8601String()))
            .year,
        DateTime.parse(
                (conversation[index - 1].sendTime ?? now.toIso8601String()))
            .month,
        DateTime.parse(
                (conversation[index - 1].sendTime ?? now.toIso8601String()))
            .day,
      );
    }

    if (previousDate == null || currentDate != previousDate) {
      String formattedDate =
          currentDate == DateTime(now.year, now.month, now.day)
              ? "Today"
              : DateFormat('dd/MM/yyyy').format(currentDate);
      return SizedBox(
        height: 35,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formattedDate,
              style: R.textStyles.inter(
                color: R.colors.lightGreyColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox();
  }
}
