import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_bars.dart';
import '../model/reg_card_model.dart';

class RegcardHistoryView extends StatefulWidget {
  static String route = '/RegcardHistoryView';
  const RegcardHistoryView({super.key});

  @override
  State<RegcardHistoryView> createState() => _RegcardHistoryViewState();
}

class _RegcardHistoryViewState extends State<RegcardHistoryView> {
  RegCardItems regCardItem = RegCardItems();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (Get.arguments != null) {
          regCardItem = Get.arguments["regCardItem"];
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRegCardVm>(builder: (context, myRegCardVm, _) {
      return Scaffold(
        backgroundColor: R.colors.white,
        appBar: titleAppBar(
            title: 'history',
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp),
        body: (regCardItem.history ?? []).isEmpty
            ? emptyWidget()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${"creation_date".L()}:",
                      style: R.textStyles
                          .inter(fontWeight: FontWeight.w500, fontSize: 10.sp),
                    ),
                    h0P5,
                    Text(
                      "${DateFormat('dd-MM-yyyy').format(DateTime.parse(regCardItem.createdAt ?? DateTime.now().toString()))}",
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: R.colors.darkGreyColor),
                    ),
                    h1P5,
                    Text(
                      "${"creation_time".L()}:",
                      style: R.textStyles
                          .inter(fontWeight: FontWeight.w500, fontSize: 10.sp),
                    ),
                    h0P5,
                    Text(
                      "${DateFormat('hh:mm a').format(DateTime.parse(regCardItem.createdAt ?? DateTime.now().toString()))}",
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: R.colors.darkGreyColor),
                    ),
                    h1P5,
                    Text(
                      "${"total_times_shared".L()}:",
                      style: R.textStyles
                          .inter(fontWeight: FontWeight.w500, fontSize: 10.sp),
                    ),
                    h0P5,
                    Text(
                      (regCardItem.shareCount ?? 0).toString(),
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: R.colors.darkGreyColor),
                    ),
                    h1P5,
                    Text(
                      "${"total_views".L()}:",
                      style: R.textStyles
                          .inter(fontWeight: FontWeight.w500, fontSize: 10.sp),
                    ),
                    h0P5,
                    Text(
                      (regCardItem.views ?? 0).toString(),
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          color: R.colors.darkGreyColor),
                    ),
                    h1P5,
                    Text(
                      "${"sharing_timeline".L()}:",
                      style: R.textStyles
                          .inter(fontWeight: FontWeight.w500, fontSize: 10.sp),
                    ),
                    h2,
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          History history = (regCardItem.history ?? [])[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: R.decoration.boxDecoration(
                                giveShadow: false,
                                useBorder: true,
                                radius: 8,
                                backgroundColor: R.colors.greyBackgroundColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    titleSub(
                                        title: "date",
                                        subTitle:
                                            "${DateFormat('dd-MM-yyyy a').format(DateTime.parse(history.shareDate ?? DateTime.now().toString()))}"),
                                    titleSub(
                                        title: "time",
                                        subTitle:
                                            "${DateFormat('hh:mm a').format(DateTime.parse(history.shareDate ?? DateTime.now().toString()))}"),
                                  ],
                                ),
                                h0P5,
                                titleSub(
                                    title: "duration",
                                    subTitle: myRegCardVm
                                            .durationList[
                                                history.durationId ?? 0]
                                            .title ??
                                        "")
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => h1,
                        itemCount: regCardItem.history?.length ?? 0,
                      ),
                    )
                  ],
                ),
              ),
      );
    });
  }

  Widget titleSub({required String title, required String subTitle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${title.L()}:",
          style:
              R.textStyles.inter(fontSize: 11.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          "${subTitle}",
          style: R.textStyles.inter(
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'no_history'.L(),
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600),
          ),
          Text(
            'no_history_found'.L(),
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
