import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/heights_widths.dart';
import '../../explore/view/split_payment/edit_and_delete_sheet.dart';
import '../model/reg_card_model.dart';
import 'my_regcard_view.dart';
import 'regcard_webview.dart';

class RegCardListView extends StatefulWidget {
  static String route = '/RegCardListView';
  const RegCardListView({super.key});

  @override
  State<RegCardListView> createState() => _RegCardListViewState();
}

class _RegCardListViewState extends State<RegCardListView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onLoading({required MyRegCardVm vm}) async {
    ZBotToast.loadingShow();
    if (vm.regCardModel.hasNext == true) {
      await vm.getAllRegCards(
          pageNumber: (vm.regCardModel.currentPage ?? 0) + 1, isLoading: true);
    }
    ZBotToast.loadingClose();
    _refreshController.loadComplete();
    if (mounted) setState(() {});
  }

  void onRefresh({required MyRegCardVm vm}) async {
    vm.regCardModel.regCardItems?.clear();
    await vm.getAllRegCards(pageNumber: 1);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyRegCardVm>(builder: (context, myRegCardsVm, child) {
      return Scaffold(
        backgroundColor: R.colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if ((myRegCardsVm.regCardModel.regCardItems ?? [])
                  .isNotEmpty) ...[
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    reverse: false,
                    enablePullUp: true,
                    header: WaterDropMaterialHeader(
                      color: R.colors.white,
                      backgroundColor: R.colors.primaryColor,
                    ),
                    onRefresh: () => onRefresh(vm: myRegCardsVm),
                    onLoading: () => onLoading(vm: myRegCardsVm),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        RegCardItems regCardItem =
                            (myRegCardsVm.regCardModel.regCardItems ??
                                [])[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(MyRegCardView.route,
                                arguments: {"regCardItem": regCardItem});
                          },
                          child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: R.decoration.boxDecoration(
                                          useBorder: false,
                                          backgroundColor:
                                              (regCardItem.isActive == true)
                                                  ? R.colors.primaryColor
                                                      .withOpacity(0.2)
                                                  : R.colors.darkGreyColor
                                                      .withOpacity(0.15),
                                          radius: 20,
                                          giveShadow: true),
                                      child: Text(
                                          (regCardItem.isActive == true)
                                              ? "active".L()
                                              : "inActive".L(),
                                          style: R.textStyles.poppins(
                                              fontSize: 9.sp,
                                              color:
                                                  (regCardItem.isActive == true)
                                                      ? R.colors.darkBrown
                                                      : R.colors.darkGreyColor,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(EditAndDeleteSheet(
                                            onDeleteTab: () {},
                                            onEditTab: () {}));
                                      },
                                      child: Icon(
                                        Icons.more_horiz,
                                      ),
                                    ),
                                  ],
                                ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat("dd/yy").format(
                                                DateTime.parse(
                                                    "${regCardItem.createdAt ?? DateTime.now().toString()}")),
                                            style: R.textStyles.inter(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            DateFormat("hh:mm a").format(
                                                DateTime.parse(
                                                    "${regCardItem.createdAt ?? DateTime.now().toString()}")),
                                            style: R.textStyles.inter(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
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
                        );
                      },
                      itemCount: myRegCardsVm.regCardModel.regCardItems?.length,
                    ),
                  ),
                ),
                h1,
              ],
              Center(
                child: AppButton(
                  buttonTitle: 'create_new_regcard',
                  textSize: 9.sp,
                  onTap: () {
                    Get.toNamed(RegcardWebView.route);
                  },
                  fontWeight: FontWeight.w500,
                  textColor: R.colors.black,
                  color: R.colors.textFieldFillColor,
                  borderRadius: 25,
                  borderColor: R.colors.black,
                  horizentalPadding: 6.w,
                  textPadding: 1.5.h,
                ),
              ),
              h3,
            ],
          ),
        ),
      );
    });
  }
}
