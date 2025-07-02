import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/common_bottomsheet.dart';

class ReportSheet extends StatefulWidget {
  const ReportSheet({super.key});

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  TextEditingController reportTC = TextEditingController();
  FocusNode reportFN = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVm>(builder: (context, homeVm, _) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(
              horizontal: 7.w,
            ) +
            EdgeInsets.only(top: 2.5.h),
        child: SingleChildScrollView(
          child: SafeAreaWidget(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "report".L(),
                    textAlign: TextAlign.center,
                    style: R.textStyles.inter(
                        color: R.colors.black,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  h1,
                  Text(
                    "anything_to_report".L(),
                    textAlign: TextAlign.center,
                    style: R.textStyles.inter(
                        color: R.colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  h2,
                  reportField(),
                  h3,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton(
                          buttonTitle: "cancel",
                          textSize: 10.sp,
                          onTap: () {
                            Get.back();
                          },
                          fontWeight: FontWeight.w500,
                          textColor: R.colors.white,
                          color: R.colors.black,
                          borderRadius: 25,
                          borderColor: R.colors.black,
                          //horizentalPadding: 18.w,
                          // buttonWidth: 40.w,
                          textPadding: 0,
                        ),
                      ),
                      w2,
                      Expanded(
                        child: AppButton(
                          buttonTitle: "submit",
                          textSize: 10.sp,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              ZBotToast.loadingShow();
                              Get.back();
                              bool isSuccess = await homeVm.reportUser({
                                "userId": homeVm.otherUser?.id,
                                "details": reportTC.text.trim(),
                              });
                              ZBotToast.loadingClose();
                              if (isSuccess) {
                                Get.bottomSheet(CommonBottomSheet(
                                  title: 'report_submitted',
                                  subTitle: 'report_submitted_desc',
                                  showFirstButton: false,
                                  showSecondButton: false,
                                ));
                                Future.delayed(
                                  Duration(seconds: 2),
                                  () {
                                    if (Get.isBottomSheetOpen == true) {
                                      Get.back();
                                    }
                                  },
                                );
                              }
                            }
                          },
                          fontWeight: FontWeight.w500,
                          textColor: R.colors.white,
                          color: R.colors.black,
                          borderRadius: 25,
                          borderColor: R.colors.black,
                          //horizentalPadding: 18.w,
                          textPadding: 0,
                          // buttonWidth: 40.w,
                        ),
                      ),
                    ],
                  ),
                  h1
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget reportField() {
    return TextFormField(
      controller: reportTC,
      focusNode: reportFN,
      maxLines: 4,
      maxLength: 262,
      textCapitalization: TextCapitalization.sentences,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      validator: FieldValidator.validateEmptyField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration
          .fieldDecoration(hintText: "write_here", verticalPadding: 6),
    );
  }
}
