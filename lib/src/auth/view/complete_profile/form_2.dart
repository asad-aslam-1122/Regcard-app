import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../resources/resources.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/heights_widths.dart';
import '../../../../utils/keyboard_config.dart';
import '../../model/profile_forms_model.dart';
import '../../view_model/auth_vm.dart';

class ProfileForm2 extends StatefulWidget {
  const ProfileForm2({super.key});

  @override
  State<ProfileForm2> createState() => _ProfileForm2State();
}

class _ProfileForm2State extends State<ProfileForm2> {
  TextEditingController addressController = TextEditingController();
  FocusNode addressFN = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFN = FocusNode();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneFN = FocusNode();
  TextEditingController companyController = TextEditingController();
  FocusNode companyFN = FocusNode();
  TextEditingController companyController2 = TextEditingController();
  FocusNode companyFN2 = FocusNode();
  TextEditingController workPositionController = TextEditingController();
  FocusNode workPositionFN = FocusNode();
  // PhoneNumber number = PhoneNumber(dialCode: "+92", isoCode: "PK");
  bool isChecked = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {});
      ProfileFormsModel p = AppUser.profileForms;
      workPositionController.text = p.step2?.workPosition ?? "";
      companyController.text = p.step2?.company ?? "";
      isChecked = p.step2?.isBillingDefault ?? true;
      companyController2.text = p.step2?.billingCompany ?? '';
      emailController.text = p.step2?.billingEmail ?? "";
      if (((p.step2?.billingPhone ?? "").isNotEmpty) ||
          p.step2?.billingPhone != null) {
        // number = PhoneNumber(
        //   isoCode: (p.step2?.billingPhone ?? '').split("--").first,
        // );
        phoneController.text = (p.step2?.billingPhone ?? '').split("--").last;
      }

      addressController.text = p.step2?.billingAddress ?? "";
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => SafeAreaWidget(
              backgroundColor: R.colors.transparent,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: R.colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      h1,
                      workPositionField(),
                      h2,
                      company1Field(),
                      h3,
                      Text(
                        'billing_details'.L(),
                        style: R.textStyles.inter(
                          color: R.colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      h0P5,
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: isChecked
                                          ? R.colors.primaryColor
                                          : R.colors.textFieldFillColor),
                                  color: R.colors.white),
                              child: isChecked
                                  ? Center(
                                      child: Icon(
                                      Icons.check,
                                      color: R.colors.black,
                                      size: 13,
                                    ))
                                  : null,
                            ),
                          ),
                          w1,
                          Text(
                            'use_contact_details_as_default'.L(),
                            style: R.textStyles.inter(
                              color: R.colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                      h2,
                      company2Field(),
                      h2,
                      emailField(),
                      h2,
                      phoneNumber(),
                      h2,
                      addressField(),
                      h8
                    ],
                  ),
                ),
                bottomNavigationBar: AppButton(
                  buttonTitle: 'continue',
                  textSize: 10.sp,
                  onTap: () async {
                    ZBotToast.loadingShow();

                    String? n;
                    if (phoneController.text.isNotEmpty) {
                      // n = '${number.isoCode}--${phoneController.text}';
                    }
                    Map body = {
                      "workPosition": workPositionController.text.trim(),
                      "company": companyController.text.trim(),
                      "isBillingDefault": isChecked,
                      "billingCompany": companyController2.text.trim(),
                      "billingEmail": emailController.text.trim(),
                      "billingPhone": n,
                      "billingAddress": addressController.text.trim(),
                    };
                    bool success = await authVm.form2(body: body);

                    if (success) {
                      AppUser.profileForms.step2 = Step2.fromJson(body);
                      print("Success ${AppUser.profileForms.step2?.toJson()}");
                      authVm.completeProfilePageIndex =
                          authVm.completeProfilePageIndex + 1;
                      authVm.update();
                      authVm.completeProfilePageController
                          .jumpToPage(authVm.completeProfilePageIndex);
                      ZBotToast.loadingClose();
                    }
                  },
                  fontWeight: FontWeight.w500,
                  textColor: R.colors.white,
                  color: R.colors.black,
                  borderRadius: 25,
                  borderColor: R.colors.black,
                  textPadding: 0,
                  horizontalMargin: 17.w,
                  verticalMargin: 2.h,
                ),
              ),
            ));
  }

  Widget workPositionField() {
    return TextFormField(
      controller: workPositionController,
      focusNode: workPositionFN,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      maxLength: 64,
      textInputAction: TextInputAction.next,
      decoration: R.decoration.fieldDecoration(
        hintText: "work_position",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(companyFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget company1Field() {
    return TextFormField(
      controller: companyController,
      focusNode: companyFN,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      maxLength: 64,
      decoration: R.decoration.fieldDecoration(
        hintText: "company_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(companyFN2);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget company2Field() {
    return TextFormField(
      enabled: !isChecked,
      controller: companyController2,
      focusNode: companyFN2,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(
          color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
          fontSize: 10.sp),
      keyboardType: TextInputType.name,
      maxLength: 64,
      textInputAction: TextInputAction.next,
      decoration: R.decoration.fieldDecoration(
          hintText: "company_name",
          hintTextColor:
              isChecked ? R.colors.black.withOpacity(.3) : R.colors.black),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(emailFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      enabled: !isChecked,
      controller: emailController,
      focusNode: emailFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(
          color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
          fontSize: 10.sp),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: R.decoration.fieldDecoration(
          hintText: "email",
          hintTextColor:
              isChecked ? R.colors.black.withOpacity(.3) : R.colors.black),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(phoneFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget phoneNumber() {
    return KeyboardActions(
      config:
          buildConfigDone(context, phoneFN, nextFocus: addressFN, isDone: true),
      disableScroll: true,
      autoScroll: false,
      // child: InternationalPhoneNumberInput(
      //   isEnabled: !isChecked,
      //   // formatInput: true,
      //   focusNode: phoneFN,
      //   selectorTextStyle: R.textStyles.inter(
      //       color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
      //       fontSize: 10.sp),
      //   textStyle: R.textStyles.inter(
      //       color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
      //       fontSize: 10.sp),
      //   keyboardAction: TextInputAction.next,
      //   inputDecoration: R.decoration.fieldDecoration(
      //       hintText: 'phone_number',
      //       focusNode: phoneFN,
      //       hintTextColor:
      //           isChecked ? R.colors.black.withOpacity(.3) : R.colors.black
      //       // suffixIcon: const Icon(
      //       //   Icons.phone,
      //       // ),
      //       ),
      //   onInputChanged: (PhoneNumber phoneNumber) {
      //     if ((phoneNumber.phoneNumber?.length ?? 0) < 1) {
      //       setState(() {});
      //     }
      //     number = phoneNumber;
      //   },
      //   selectorConfig: const SelectorConfig(
      //     leadingPadding: 5,
      //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      //     showFlags: false,
      //     setSelectorButtonAsPrefixIcon: true,
      //     trailingSpace: false,
      //   ),
      //   ignoreBlank: false,
      //   initialValue: number,
      //   textFieldController: phoneController,
      //   keyboardType: const TextInputType.numberWithOptions(
      //       signed: false, decimal: false),
      //   inputBorder: const OutlineInputBorder(),
      //   //onSaved: (PhoneNumber number) => setState(() {}),
      //   onFieldSubmitted: (s) => setState(() {
      //     FocusScope.of(context).requestFocus(addressFN);
      //     setState(() {});
      //   }),
      //   // onInputValidated: (value) => setState(() {}),
      // ),
    );
  }

  Widget addressField() {
    return TextFormField(
      enabled: !isChecked,
      controller: addressController,
      focusNode: addressFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.location],
      style: R.textStyles.inter(
          color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
          fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      maxLength: 100,
      textInputAction: TextInputAction.done,
      decoration: R.decoration.fieldDecoration(
          hintText: "address",
          hintTextColor:
              isChecked ? R.colors.black.withOpacity(.3) : R.colors.black),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }
}
