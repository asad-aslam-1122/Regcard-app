import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/keyboard_config.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/app_user.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../auth/model/user_profile.dart';
import '../../../view_model/base_vm.dart';

class BillingDetailView extends StatefulWidget {
  static String route = "/BillingDetailView";

  const BillingDetailView({super.key});

  @override
  State<BillingDetailView> createState() => _BillingDetailViewState();
}

class _BillingDetailViewState extends State<BillingDetailView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  FocusNode addressFN = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode emailFN = FocusNode();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneFN = FocusNode();
  TextEditingController companyController = TextEditingController();
  FocusNode companyFN = FocusNode();
  // PhoneNumber number = PhoneNumber();
  bool isChecked = false;

  @override
  void initState() {
    ZBotToast.loadingShow();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProfile? p = AppUser.userProfile;
      isChecked = p?.isBillingDefault ?? false;
      if (isChecked) {
        companyController.text = p?.company ?? '';
        emailController.text = p?.email ?? '';
        await Future.delayed(const Duration(milliseconds: 300));
        if (((p?.phoneNumber ?? "").isNotEmpty) || p?.phoneNumber != null) {
          // number = await PhoneNumber.getRegionInfoFromPhoneNumber(
          //   p?.phoneNumber ?? '',
          // );
          // number = PhoneNumber(
          //     isoCode: number.isoCode,
          //     dialCode: number.dialCode,
          //     phoneNumber: number.phoneNumber);
          // setState(() {});
          //   phoneController.text = (p?.phoneNumber ?? '').split("--").last;
        }
        addressController.text = p?.address ?? '';
      } else {
        companyController.text = p?.billingCompany ?? '';
        emailController.text = p?.billingEmail ?? '';
        await Future.delayed(const Duration(milliseconds: 300));
        if (((p?.billingPhone ?? "").isNotEmpty) || p?.billingPhone != null) {
          // number = PhoneNumber(
          //     isoCode: (p?.billingPhone ?? '').split("--").first,
          //     phoneNumber: (p?.billingPhone ?? '').split("--").last
          //     // dialCode:,
          //     // phoneNumber:
          //     );
          setState(() {});
        }
        addressController.text = p?.billingAddress ?? '';
      }
      ZBotToast.loadingClose();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, baseVm, child) => SafeAreaWidget(
              backgroundColor: R.colors.greyBackgroundColor,
              child: Scaffold(
                backgroundColor: R.colors.white,
                body: Stack(
                  children: [
                    const Column(
                      children: [BackgroundContainer(showBackButton: true)],
                    ),
                    Container(
                      width: Get.width,
                      height: Get.height,
                      margin: EdgeInsets.only(top: 15.h, left: 5.w, right: 5.w),
                      decoration: BoxDecoration(
                          color: R.colors.greyBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    h3,
                                    Center(
                                      child: Image.asset(
                                        R.images.appLogo,
                                        scale: 3,
                                      ),
                                    ),
                                    h4,
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
                                          onTap: () async {
                                            setState(() {
                                              isChecked = !isChecked;
                                            });
                                            UserProfile? p =
                                                AppUser.userProfile;
                                            if (isChecked) {
                                              companyController.text =
                                                  p?.company ?? '';
                                              emailController.text =
                                                  p?.email ?? '';
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300));
                                              if (((p?.phoneNumber ?? "")
                                                      .isNotEmpty) ||
                                                  p?.phoneNumber != null) {
                                                // //         number.phoneNumber);
                                                setState(() {});
                                                //   phoneController.text = (p?.phoneNumber ?? '').split("--").last;
                                              }
                                              addressController.text =
                                                  // p?.address ?? number = await PhoneNumber
                                                  //     .getRegionInfoFromPhoneNumber(
                                                  //   p?.phoneNumber ?? '',
                                                  // );
                                                  // number = PhoneNumber(
                                                  //     isoCode: number.isoCode,
                                                  //     dialCode: number.dialCode,
                                                  //     phoneNumber:
                                                  '';
                                            } else {
                                              companyController.text =
                                                  p?.billingCompany ?? '';
                                              emailController.text =
                                                  p?.billingEmail ?? '';
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 300));
                                              if (((p?.billingPhone ?? "")
                                                      .isNotEmpty) ||
                                                  p?.billingPhone != null) {
                                                // number = PhoneNumber(
                                                //     isoCode:
                                                //         (p?.billingPhone ?? '')
                                                //             .split("--")
                                                //             .first,
                                                //     phoneNumber:
                                                //         (p?.billingPhone ?? '')
                                                //             .split("--")
                                                //             .last
                                                //     // dialCode:,
                                                //     // phoneNumber:
                                                //     );
                                                setState(() {});
                                              }
                                              addressController.text =
                                                  p?.billingAddress ?? '';
                                            }
                                          },
                                          child: Container(
                                            height: 13,
                                            width: 13,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                border: Border.all(
                                                    color: isChecked
                                                        ? R.colors.primaryColor
                                                        : R.colors
                                                            .textFieldFillColor),
                                                color: R.colors.white),
                                            child: isChecked
                                                ? Icon(
                                                    Icons.check,
                                                    color: R.colors.black,
                                                    size: 10,
                                                  )
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
                                    company1Field(),
                                    h1P5,
                                    emailField(),
                                    h1P5,
                                    phoneNumber(),
                                    h1P5,
                                    addressField(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          h5,
                          AppButton(
                            buttonTitle: 'update',
                            textSize: 10.sp,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                onContinueTap(baseVm);
                              }
                            },
                            fontWeight: FontWeight.w500,
                            textColor: R.colors.white,
                            color: R.colors.black,
                            borderRadius: 25,
                            borderColor: R.colors.black,
                            buttonWidth: 40.w,
                            textPadding: 0,
                          ),
                          h1
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> onContinueTap(BaseVm baseVm) async {
    ZBotToast.loadingShow();
    String? n;
    if (phoneController.text.isNotEmpty) {
      // n = '${number.isoCode}--${phoneController.text}';
    }
    Map billingDetailBody = {
      "isBillingDefault": isChecked,
      "billingCompany": companyController.text.trim(),
      "billingEmail": emailController.text.trim(),
      "billingPhone": n,
      "billingAddress": addressController.text.trim()
    };

    bool check = await baseVm.billingDetails(body: billingDetailBody);
    if (check) {
      await baseVm.getProfile();
      Get.forceAppUpdate();
      Get.back();
      ZBotToast.showToastSuccess(
          message: 'your_billing_details_is_updated_successfully'.L());
    }
  }

  Widget company1Field() {
    return TextFormField(
      enabled: !isChecked,
      controller: companyController,
      focusNode: companyFN,
      maxLength: 64,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(
          color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
          fontSize: 10.sp),
      keyboardType: TextInputType.name,
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
      maxLength: 40,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      validator: FieldValidator.validateEmailEmpty,
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
      //     isEnabled: !isChecked,
      //     focusNode: phoneFN,
      //     selectorTextStyle: R.textStyles.inter(
      //         color:
      //             isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
      //         fontSize: 10.sp),
      //     textStyle: R.textStyles.inter(
      //         color:
      //             isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
      //         fontSize: 10.sp),
      //     keyboardAction: TextInputAction.next,
      //     inputDecoration: R.decoration.fieldDecoration(
      //         hintText: 'phone_number',
      //         focusNode: phoneFN,
      //         hintTextColor:
      //             isChecked ? R.colors.black.withOpacity(.3) : R.colors.black
      //
      //         // suffixIcon: const Icon(
      //         //   Icons.phone,
      //         // ),
      //         ),
      //     onInputChanged: (PhoneNumber phoneNumber) {
      //       if ((phoneNumber.phoneNumber?.length ?? 0) < 1) {
      //         setState(() {});
      //       }
      //       number = phoneNumber;
      //     },
      //     selectorConfig: const SelectorConfig(
      //       leadingPadding: 5,
      //       selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      //       showFlags: false,
      //       setSelectorButtonAsPrefixIcon: true,
      //       trailingSpace: false,
      //     ),
      //     ignoreBlank: false,
      //     autoValidateMode: AutovalidateMode.onUserInteraction,
      //     initialValue: number,
      //     textFieldController: phoneController,
      //     keyboardType: const TextInputType.numberWithOptions(
      //         signed: false, decimal: false),
      //     inputBorder: const OutlineInputBorder(),
      //     onSaved: (PhoneNumber number) => setState(() {}),
      //     onFieldSubmitted: (s) => setState(() {
      //           FocusScope.of(context).requestFocus(addressFN);
      //           setState(() {});
      //         }),
      //     onInputValidated: (value) {}),
    );
  }

  Widget addressField() {
    return TextFormField(
      enabled: !isChecked,
      controller: addressController,
      focusNode: addressFN,
      maxLength: 100,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.location],
      style: R.textStyles.inter(
          color: isChecked ? R.colors.black.withOpacity(.3) : R.colors.black,
          fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
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
