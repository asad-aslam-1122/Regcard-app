import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../model/add_expense_model.dart';
import 'expense_details_view.dart';

class OtherPayments extends StatefulWidget {
  const OtherPayments({super.key});

  @override
  State<OtherPayments> createState() => _OtherPaymentsState();
}

class _OtherPaymentsState extends State<OtherPayments> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return Column(
          children: [
            Expanded(
              child: expenseVm.otherExpenseList.isEmpty
                  ? Center(
                      child: emptyScreen(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Text(
                                DateFormat("MMMM yyyy").format(DateTime.parse(
                                    expenseVm.expenseModelList[index].date)),
                                style: R.textStyles.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                              ),
                            paymentCard(
                                expenseModel:
                                    expenseVm.otherExpenseList[index]),
                          ],
                        );
                      },
                      itemCount: expenseVm.expenseModelList.length),
            ),
          ],
        );
      },
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'no_payment_history'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'no_payment_history_desc'.L(),
          style: R.textStyles.inter(
              color: R.colors.black,
              fontSize: 9.sp,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget paymentCard({required AddExpenseModel expenseModel}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(ExpenseDetailsView.route,
            arguments: {"expenseModel": expenseModel});
      },
      child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: R.decoration.boxDecoration(
              borderColor: R.colors.greyBorderColor,
              giveShadow: false,
              backgroundColor: R.colors.greyBackgroundColor,
              useBorder: true,
              radius: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: R.decoration.boxDecoration(
                          borderColor: R.colors.greyBorderColor,
                          giveShadow: true,
                          backgroundColor:
                              R.colors.textFieldFillColor.withOpacity(0.3),
                          useBorder: true,
                          radius: 8),
                      child: expenseModel.picture == null
                          ? Image.asset(
                              R.images.paymentLogo,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.file(expenseModel.picture!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            expenseModel.title,
                            style: R.textStyles.inter(
                                fontWeight: FontWeight.w600, fontSize: 11.sp),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '\$${expenseModel.amount}',
                            style: R.textStyles.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(expenseModel.date)),
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w400, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (!expenseModel.hasAccepted)
                SizedBox(
                  width: 40.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: smallBtn(
                            btnTitle: "reject",
                            onPressed: () {
                              expenseModel.hasAccepted = false;
                              setState(() {});
                            },
                            showBorder: true),
                      ),
                      Expanded(
                        child: smallBtn(
                            btnTitle: "accept",
                            onPressed: () {
                              expenseModel.hasAccepted = true;
                              setState(() {});
                            },
                            showBorder: false),
                      ),
                    ],
                  ),
                )
            ],
          )),
    );
  }

  Widget smallBtn(
      {required String btnTitle,
      required VoidCallback onPressed,
      bool? showBorder}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 27,
        margin: EdgeInsets.only(left: 6),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: R.decoration.boxDecoration(
            giveShadow: true,
            backgroundColor: (showBorder ?? false)
                ? R.colors.transparent
                : R.colors.darkBrown,
            radius: 30,
            useBorder: (showBorder ?? false),
            borderColor: (showBorder ?? false)
                ? R.colors.darkBrown
                : R.colors.transparent),
        child: Center(
          child: Text(
            btnTitle.L(),
            style: R.textStyles.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: (showBorder ?? false)
                    ? R.colors.darkBrown
                    : R.colors.white),
          ),
        ),
      ),
    );
  }
}
