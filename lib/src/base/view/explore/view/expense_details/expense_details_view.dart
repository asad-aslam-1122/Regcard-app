import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/src/base/view/explore/model/add_expense_model.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/utils/app_bars.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../split_payment/edit_and_delete_sheet.dart';

class ExpenseDetailsView extends StatefulWidget {
  static String route = '/ExpenseDetailsView';

  ExpenseDetailsView({super.key});

  @override
  State<ExpenseDetailsView> createState() => _ExpenseDetailsViewState();
}

class _ExpenseDetailsViewState extends State<ExpenseDetailsView> {
  AddExpenseModel? expenseModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        expenseModel = Get.arguments["expenseModel"];
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return Scaffold(
          appBar: titleAppBar(
            title: "expense_details",
            titleCenter: true,
            icon: Icons.arrow_back_ios_sharp,
          ),
          backgroundColor: R.colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h1,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: R.decoration.boxDecoration(
                      borderColor: R.colors.greyBorderColor,
                      useBorder: true,
                      radius: 8,
                      backgroundColor: R.colors.greyBackgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: expenseModel?.picture == null
                                  ? Image.asset(
                                      R.images.paymentLogo,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.fill,
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        await OpenFilex.open(
                                            expenseModel!.picture.toString());
                                      },
                                      child: Image.file(
                                        expenseModel!.picture!,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    )),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(EditAndDeleteSheet(
                                onEditTab: () {
                                  Get.back();
                                },
                                onDeleteTab: () {
                                  expenseVm.expenseModelList
                                      .remove(expenseModel);
                                  expenseVm.update();
                                },
                              ));
                            },
                            child: Icon(
                              Icons.more_horiz,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                      h1P5,
                      Text(
                        expenseModel?.title ?? "",
                        style: R.textStyles.inter(
                            fontSize: 10.sp, fontWeight: FontWeight.w500),
                      ),
                      h1P5,
                      Text(
                        "\$${((expenseModel?.amount ?? 0) / (expenseModel?.addedMembersList.length ?? 0)).toStringAsFixed(1)}",
                        style: R.textStyles.inter(
                          fontSize: 10.sp,
                        ),
                      ),
                      h1P5,
                      Text(
                        DateFormat("dd/MM/yyyy")
                            .format(DateTime.parse(expenseModel?.date ?? "")),
                        style: R.textStyles.inter(fontSize: 10.sp),
                      ),
                      h1P5,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "paid_by".L(),
                            style: R.textStyles.inter(
                                fontSize: 10.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          CircleAvatar(
                              radius: 16,
                              backgroundImage: getImageProvider(
                                  AppUser.userProfile?.pictureUrl ?? "")),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "you".L(),
                            style: R.textStyles.inter(
                                fontSize: 10.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                h2,
                Text(
                  "payment_contributions".L(),
                  style: R.textStyles.inter(fontWeight: FontWeight.w500),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 12),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: getImageProvider(expenseModel
                                      ?.addedMembersList[index].pictureUrl ??
                                  ""),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 12, left: 8),
                                child: Text(
                                  expenseModel
                                          ?.addedMembersList[index].fullName ??
                                      "",
                                  overflow: TextOverflow.ellipsis,
                                  style: R.textStyles.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              smallBtn(
                                btnTitle: (expenseModel?.paymentPaidMembersList
                                            ?.any((member) =>
                                                member.id ==
                                                expenseModel
                                                    ?.addedMembersList[index]
                                                    .id) ??
                                        false)
                                    ? "accepted"
                                    : "pending",
                                paymentStatus: (expenseModel
                                            ?.paymentPaidMembersList
                                            ?.any((member) =>
                                                member.id ==
                                                expenseModel
                                                    ?.addedMembersList[index]
                                                    .id) ??
                                        false)
                                    ? "accepted"
                                    : "pending",
                                onPressed: () {},
                              ),
                              Text(
                                "\$${((expenseModel?.amount ?? 0) / (expenseModel?.addedMembersList.length ?? 0)).toStringAsFixed(1)}",
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => h2,
                  itemCount: expenseModel?.addedMembersList.length ?? 0,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider<Object> getImageProvider(String? pictureUrl) {
    if (pictureUrl == null || pictureUrl.isEmpty) {
      return AssetImage('assets/default_profile.png'); // Default image
    }
    return NetworkImage(pictureUrl);
  }

  Widget smallBtn({
    required String btnTitle,
    required VoidCallback onPressed,
    required String paymentStatus,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 27,
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: R.decoration.boxDecoration(
            backgroundColor: R.colors.greyBorderColor,
            radius: 20,
            useBorder: false,
            giveShadow: true,
            borderColor: R.colors.transparent),
        child: Center(
          child: Text(
            btnTitle.L(),
            overflow: TextOverflow.ellipsis,
            style: R.textStyles.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: paymentStatus == "pending"
                    ? R.colors.darkGreyColor
                    : paymentStatus == "accepted"
                        ? R.colors.darkBrown
                        : R.colors.red),
          ),
        ),
      ),
    );
  }
}
