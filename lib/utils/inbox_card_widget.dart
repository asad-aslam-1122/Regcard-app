import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constant/enums.dart';
import '../resources/resources.dart';
import '../src/base/view/home/model/chat_head_model.dart';
import '../src/base/view/home/model/chat_model.dart';
import '../src/base/view/home/view_model/home_vm.dart';
import 'bot_toast/zbot_toast.dart';
import 'display_image.dart';
import 'heights_widths.dart';

class InboxCardWidget extends StatefulWidget {
  final ChatHead chatHead;
  final HomeVm homeVm;
  final Sender otherUser;
  const InboxCardWidget(
      {super.key,
      required this.homeVm,
      required this.chatHead,
      required this.otherUser});

  @override
  State<InboxCardWidget> createState() => _InboxCardWidgetState();
}

class _InboxCardWidgetState extends State<InboxCardWidget>
    with SingleTickerProviderStateMixin {
  late final SlidableController controller = SlidableController(this);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          GestureDetector(
            onTap: () async {
              controller.close();
              ZBotToast.loadingShow();
              bool isSuccess = await widget.homeVm
                  .deleteChatHead(widget.chatHead.chatHeadId ?? 0);
              if (isSuccess) {
                (widget.homeVm.chatHeadModel.chatHead ?? []).removeWhere(
                  (element) => element.chatHeadId == widget.chatHead.chatHeadId,
                );
                widget.homeVm.update();
              }
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: R.colors.red),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: R.colors.white,
                  ),
                )),
          )
        ],
      ),
      child: InkWell(
        onTap: () async {
          ZBotToast.loadingShow();
          widget.homeVm.chatHead = widget.chatHead;
          await widget.homeVm.getChatById(
            pageNumber: 1,
            isLoading: false,
          );
          ZBotToast.loadingClose();
        },
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              widget.otherUser.isBlocked == true
                  ? Colors.white38
                  : R.colors.transparent,
              BlendMode.srcATop),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: R.colors.greyBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayImage(
                  imageUrl: widget.otherUser.pictureUrl,
                  borderColor: R.colors.lightGreyColor,
                  borderWidth: 0,
                  isCircle: true,
                  hasMargin: false,
                  height: 15.w,
                  width: 15.w,
                  hasBorder: true,
                ),
                w2,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h1,
                      Text(
                        widget.otherUser.fullName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyles.inter(
                            color: R.colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp),
                      ),
                      h0P3,
                      widget.otherUser.isBlocked == true
                          ? Text(
                              'block_contact_desc'.L(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: R.textStyles.inter(
                                  color: R.colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8.sp),
                            )
                          : (widget.chatHead.lastMsg?.messageType ?? 0) ==
                                  MessageTypeEnum.text.index
                              ? Text(
                                  widget.chatHead.lastMsg?.message ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles.inter(
                                      color: R.colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 8.sp),
                                )
                              : Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 5),
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                        R.images.document,
                                      ))),
                                      child: Text(
                                        widget.chatHead.lastMsg?.extension
                                                ?.toUpperCase() ??
                                            "",
                                        style: R.textStyles.inter(
                                            color: R.colors.black,
                                            fontSize: 5,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.chatHead.lastMsg?.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: R.textStyles.inter(
                                            color: R.colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 8.sp),
                                      ),
                                    )
                                  ],
                                ),
                    ],
                  ),
                ),
                Text(
                  timeago.format(
                      DateTime.parse(widget.chatHead.lastMsg?.sendTime ??
                          DateTime.now().toString()),
                      locale: 'en_short'),
                  style: R.textStyles.inter(
                      color: R.colors.lightGreyColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 7.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
