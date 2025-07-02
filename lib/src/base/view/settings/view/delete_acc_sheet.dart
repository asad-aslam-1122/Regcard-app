import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/bot_toast/zbot_toast.dart';

class DeleteAccSheet extends StatefulWidget {
  const DeleteAccSheet({super.key});

  @override
  State<DeleteAccSheet> createState() => _DeleteAccSheetState();
}

class _DeleteAccSheetState extends State<DeleteAccSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  FocusNode passFN = FocusNode();
  FocusNode reasonFN = FocusNode();
  bool passObscure = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, baseVm, child) => Container(
              // constraints: BoxConstraints(maxHeight: 45.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: R.colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                  ) +
                  EdgeInsets.only(top: 2.5.h),
              child: SafeAreaWidget(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "delete_acc".L(),
                          textAlign: TextAlign.center,
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        h1,
                        Text(
                          "delete_acc_statement".L(),
                          textAlign: TextAlign.center,
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300),
                        ),
                        h2,
                        passField(),
                        h1P5,
                        reasonField(),
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
                                buttonTitle: "delete",
                                textSize: 10.sp,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ZBotToast.loadingShow();
                                    Map deleteAccount = {
                                      "password":
                                          passwordController.text.trim(),
                                      "reason": reasonController.text.trim(),
                                    };
                                    await baseVm.deleteAccount(
                                        body: deleteAccount, context: context);
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
            ));
  }

  Widget passField() {
    return TextFormField(
      controller: passwordController,
      focusNode: passFN,
      obscureText: passObscure,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validatePassEmptyField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              passObscure = !passObscure;
            });
          },
          child: Icon(
            passObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: R.colors.lightGreyColor,
          ),
        ),
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: ((value) async {}),
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(reasonFN);
        setState(() {});
      },
    );
  }

  Widget reasonField() {
    return TextFormField(
      controller: reasonController,
      focusNode: reasonFN,
      maxLines: 6,
      maxLength: 262,
      textCapitalization: TextCapitalization.sentences,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      validator: FieldValidator.validateDeleteAccountResField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration
          .fieldDecoration(hintText: "write_reason", verticalPadding: 6),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }
}
