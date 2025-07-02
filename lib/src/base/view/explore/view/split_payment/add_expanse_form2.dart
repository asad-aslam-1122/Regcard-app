import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../constant/enums.dart';
import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_button.dart';
import '../../../../../../utils/display_image.dart';
import '../../../../../../utils/heights_widths.dart';

class AddExpanseForm2 extends StatefulWidget {
  const AddExpanseForm2({super.key});

  @override
  State<AddExpanseForm2> createState() => _AddExpanseForm2State();
}

class _AddExpanseForm2State extends State<AddExpanseForm2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h1P5,
                  Text(
                    "which_method_you_want_to_choose".L(),
                    style: R.textStyles
                        .inter(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  ),
                  h1P5,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        2,
                        (index) => methodContainer(
                            title: index == 0 ? "fix_amount" : "percentage",
                            method: PaymentMethodEnum.values[index],
                            expenseVm: expenseVm,
                            onTab: () {
                              expenseVm.onMethodSelected(
                                  PaymentMethodEnum.values[index]);
                            }),
                      )),
                  h3,
                  if (expenseVm.selectedMethod != null) ...[
                    Text(
                      "how_do_you_want_to_split".L(),
                      style: R.textStyles
                          .inter(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    ),
                    h1P5,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          2,
                          (index) => splitContainer(
                              title: index == 0 ? "equally" : "custom",
                              split: PaymentSplitEnum.values[index],
                              expenseVm: expenseVm,
                              onTab: () {
                                expenseVm.onSplitSelected(
                                    PaymentSplitEnum.values[index]);
                              }),
                        )),
                  ],
                  h2,
                  if (expenseVm.selectedSplit != null) ...[
                    Text(
                      "enter_contribution".L(),
                      style: R.textStyles
                          .inter(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    ),
                    h2,
                    Expanded(child: membersContributions(expenseVm)),
                  ],
                ],
              ),
            ),
            if (expenseVm.selectedSplit == PaymentSplitEnum.custom)
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${expenseVm.getTotalOfReaming(expenseVm.selectedMethod == PaymentMethodEnum.fix)}',
                      style: R.textStyles.inter(
                          fontSize: 13.sp,
                          color: R.colors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      expenseVm
                              .getRemainingAmount(expenseVm.selectedMethod ==
                                  PaymentMethodEnum.fix)
                              .contains("-")
                          ? expenseVm
                              .getRemainingAmount(expenseVm.selectedMethod ==
                                  PaymentMethodEnum.fix)
                              .replaceFirst("-", "")
                          : expenseVm.getRemainingAmount(
                              expenseVm.selectedMethod ==
                                  PaymentMethodEnum.fix),
                      style: R.textStyles.inter(
                          fontSize: 11.sp,
                          color: expenseVm
                                  .getRemainingAmount(
                                      expenseVm.selectedMethod ==
                                          PaymentMethodEnum.fix)
                                  .contains("-")
                              ? R.colors.error
                              : R.colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: AppButton(
                buttonTitle: "next",
                textSize: 10.sp,
                onTap: () {
                  if (expenseVm.selectedMethod == null) {
                    ZBotToast.showToastError(
                        message: "please_select_the_payment_method".L());
                  } else if (expenseVm.selectedSplit == null) {
                    ZBotToast.showToastError(
                        message: "please_select_the_payment_split".L());
                  } else if (expenseVm.getRemainingValue()) {
                    ZBotToast.showToastError(
                        message:
                            "Payment ${expenseVm.getRemainingAmount(expenseVm.selectedMethod == PaymentMethodEnum.fix).replaceFirst("-", "")}");
                  } else {
                    expenseVm.selectedExpenseIndex =
                        expenseVm.selectedExpenseIndex + 1;
                    expenseVm.update();
                  }
                },
                fontWeight: FontWeight.w500,
                textColor: R.colors.white,
                color: R.colors.black,
                borderRadius: 25,
                borderColor: (expenseVm.selectedSplit == null ||
                        expenseVm.selectedMethod == null)
                    ? R.colors.black.withValues(alpha: .3)
                    : R.colors.black,
                buttonWidth: 40.w,
                textPadding: 0,
              ),
            )
          ],
        );
      },
    );
  }

  Widget membersContributions(ExpenseVm expenseVm) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final member = expenseVm.addedMembersList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DisplayImage(
                      imageUrl: member.pictureUrl ?? "",
                      borderColor: R.colors.lightGreyColor,
                      isCircle: true,
                      hasMargin: false,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: Text(
                              member.fullName ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: R.textStyles.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (expenseVm.selectedMethod ==
                                  PaymentMethodEnum.percentage &&
                              expenseVm.selectedSplit ==
                                  PaymentSplitEnum.custom)
                            Padding(
                              padding: EdgeInsets.only(right: 30.w),
                              child: Text(
                                "\$${(member.contributionAmount?.toPrecision(2) ?? 0.0)}",
                                overflow: TextOverflow.ellipsis,
                                style: R.textStyles.inter(
                                  fontSize: 10.sp,
                                  color: R.colors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    if (expenseVm.selectedMethod == PaymentMethodEnum.fix)
                      Text(
                        "\$",
                        style: R.textStyles.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.sp,
                        ),
                      ),
                    Expanded(
                      child: TextFormField(
                        controller: member.controller,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        textInputAction:
                            (expenseVm.addedMembersList.length - 1) != index
                                ? TextInputAction.next
                                : TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        textAlign: TextAlign.end,
                        readOnly:
                            expenseVm.selectedSplit == PaymentSplitEnum.equally,
                        keyboardType: TextInputType.number,
                        style: R.textStyles.inter(
                          color: R.colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                        ),
                        onChanged: (value) {
                          expenseVm.handleInputChange(
                            index,
                            value.isEmpty ? "0" : value,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "0.00",
                          hintStyle: R.textStyles.inter(
                            color: R.colors.black.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  R.colors.primaryColor.withValues(alpha: .3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  R.colors.primaryColor.withValues(alpha: .3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  R.colors.primaryColor.withValues(alpha: .3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (expenseVm.selectedMethod ==
                        PaymentMethodEnum.percentage)
                      Text(
                        "%",
                        style: R.textStyles.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: expenseVm.addedMembersList.length,
    );
  }

  Widget methodContainer(
      {required ExpenseVm expenseVm,
      required String title,
      required PaymentMethodEnum method,
      required VoidCallback onTab}) {
    return Expanded(
      child: InkWell(
        onTap: onTab,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.only(right: method.index == 0 ? 10 : 0),
          decoration: R.decoration.boxDecoration(
              giveShadow: false,
              backgroundColor: expenseVm.selectedMethod == method
                  ? R.colors.primaryColor
                  : R.colors.textFieldFillColor,
              radius: 31,
              borderColor: expenseVm.selectedMethod == method
                  ? R.colors.transparent
                  : R.colors.black.withValues(alpha: 0.3),
              useBorder: expenseVm.selectedMethod == method ? false : true),
          child: Center(
            child: Text(
              title.L(),
              style: R.textStyles.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: expenseVm.selectedMethod == method
                      ? R.colors.white
                      : R.colors.black.withValues(alpha: 0.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget splitContainer(
      {required ExpenseVm expenseVm,
      required String title,
      required PaymentSplitEnum split,
      required VoidCallback onTab}) {
    return Expanded(
      child: InkWell(
        onTap: onTab,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.only(right: split.index == 0 ? 10 : 0),
          decoration: R.decoration.boxDecoration(
              giveShadow: false,
              backgroundColor: expenseVm.selectedSplit == split
                  ? R.colors.primaryColor
                  : R.colors.textFieldFillColor,
              radius: 31,
              borderColor: expenseVm.selectedSplit == split
                  ? R.colors.transparent
                  : R.colors.black.withValues(alpha: 0.3),
              useBorder: expenseVm.selectedSplit == split ? false : true),
          child: Center(
            child: Text(
              title.L(),
              style: R.textStyles.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: expenseVm.selectedSplit == split
                      ? R.colors.white
                      : R.colors.black.withValues(alpha: 0.5)),
            ),
          ),
        ),
      ),
    );
  }
}
