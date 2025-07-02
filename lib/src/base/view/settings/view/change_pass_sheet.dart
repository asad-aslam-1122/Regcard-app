import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../auth/view_model/auth_vm.dart';

class ChangePassSheet extends StatefulWidget {
  const ChangePassSheet({super.key});

  @override
  State<ChangePassSheet> createState() => _ChangePassSheetState();
}

class _ChangePassSheetState extends State<ChangePassSheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPassController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode passFN = FocusNode();
  FocusNode currentPassFN = FocusNode();
  FocusNode confirmPassFN = FocusNode();
  bool passObscure = true;
  bool currentPassObscure = true;
  bool confirmPassObscure = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Container(
              constraints: BoxConstraints(maxHeight: 45.h),
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
                          "change_password".L(),
                          textAlign: TextAlign.center,
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        h3,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Column(
                            children: [
                              currentPassField(),
                              h1P5,
                              passField(),
                              h1P5,
                              confirmPassField(),
                            ],
                          ),
                        ),
                        h5,
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
                                buttonTitle: "save",
                                textSize: 10.sp,
                                onTap: () {
                                  onTapReset(authVm);
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

  Future<void> onTapReset(AuthVm authVm) async {
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();
      Map body = {
        "email": AppUser.userProfile?.email,
        "resetOption": ResetPasswordOptionEnum.password.index,
        "resetValue": currentPassController.text.trim(),
        "password": passwordController.text.trim()
      };
      bool check = await authVm.resetPass(body: body);
      if (check) {
        Get.back();
        ZBotToast.showToastSuccess(message: "Password Updated Successfully");
      }
    }
  }

  Widget currentPassField() {
    return TextFormField(
      controller: currentPassController,
      focusNode: currentPassFN,
      obscureText: currentPassObscure,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validatePassEmptyField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "current_password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              currentPassObscure = !currentPassObscure;
            });
          },
          child: Icon(
            currentPassObscure
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
        FocusScope.of(context).requestFocus(passFN);
        setState(() {});
      },
    );
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
      validator: FieldValidator.validatePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "new_password",
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
        FocusScope.of(context).requestFocus(confirmPassFN);
        setState(() {});
      },
    );
  }

  Widget confirmPassField() {
    return TextFormField(
      controller: confirmPasswordController,
      focusNode: confirmPassFN,
      obscureText: confirmPassObscure,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: (val) =>
          FieldValidator.validatePasswordMatch(val, passwordController.text),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "confirm_password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              confirmPassObscure = !confirmPassObscure;
            });
          },
          child: Icon(
            confirmPassObscure
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
        FocusScope.of(context).unfocus();
        setState(() {});
      },
    );
  }
}
