import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view/login_view.dart';
import 'package:regcard/src/auth/view/otp_view.dart';
import 'package:regcard/src/base/view/settings/view/legal_documents_view.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/keyboard_config.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/drop_down_widget.dart';
import '../view_model/auth_vm.dart';

class SignupView extends StatefulWidget {
  static String route = "/SignupView";

  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode firstNameFN = FocusNode();
  FocusNode lastNameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode confirmPassFN = FocusNode();
  FocusNode phoneFN = FocusNode();
  bool passObscure = true;
  bool confirmPassObscure = true;
  String? phnNumber;
  // PhoneNumber number = PhoneNumber(isoCode: 'US');

  bool acceptTerms = false;
  List<String> title = ["Mr", "Mrs", "Miss"];

  String? selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Scaffold(
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            h3,
                            Image.asset(
                              R.images.appLogo,
                              scale: 3,
                            ),
                            h4,
                            DropdownWidget(
                              validator: FieldValidator.validateTitleDropdown,
                              onChanged: (updatedValue) {
                                selectedTitle = updatedValue;
                                setState(() {});
                              },
                              selectedValue: selectedTitle,
                              list: title,
                              hintText: "title",
                            ),
                            h1P5,
                            firstNameField(),
                            h1P5,
                            lastNameField(),
                            h1P5,
                            emailField(),
                            h1P5,
                            phoneNumber(),
                            h1P5,
                            passField(),
                            h1P5,
                            confirmPassField(),
                            h3,
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      authVm.isChecked = !authVm.isChecked;
                                    });
                                  },
                                  child: Container(
                                    height: 2.h,
                                    width: 2.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: R.colors.textFieldFillColor),
                                        color: authVm.isChecked
                                            ? R.colors.primaryColor
                                            : R.colors.white),
                                    child: authVm.isChecked
                                        ? Center(
                                            child: Icon(
                                            Icons.check,
                                            color: R.colors.white,
                                            size: 13,
                                          ))
                                        : null,
                                  ),
                                ),
                                w2,
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "i_accept_the".L(),
                                    style: R.textStyles.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300,
                                      color: R.colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "${"terms_and_conditions".L()}.",
                                        style: R.textStyles.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                          color: R.colors.black,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(
                                                LegalDocumentsView.route);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            h5,
                            AppButton(
                              buttonTitle: 'sign_up',
                              textSize: 10.sp,
                              onTap: () async {
                                await onTapSignUp(authVm);
                              },
                              fontWeight: FontWeight.w500,
                              textColor: R.colors.white,
                              color: R.colors.black,
                              borderRadius: 25,
                              borderColor: R.colors.black,
                              //horizentalPadding: 18.w,
                              buttonWidth: 40.w,
                              textPadding: 0,
                            ),
                            h2,
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  //TODO: Missing exception handling and the "else" part for the OTP request.
  Future<void> onTapSignUp(AuthVm authVm) async {
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();
      if (authVm.isChecked) {
        Map signupBody = {
          "title": selectedTitle,
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "email": emailController.text.trim(),
          "phoneNumber": "",
          "password": passwordController.text.trim()
        };
        bool signupResponse = await authVm.signUp(body: signupBody);
        if (signupResponse) {
          FocusScope.of(context).requestFocus(FocusNode());
          ZBotToast.loadingShow();
          Map otpBody = {
            "existingEmail": emailController.text,
            "newEmail": "#"
          };
          bool otpResponse = await authVm.otpGenerate(body: otpBody);
          if (otpResponse) {
            authVm.isChecked = false;
            Get.offAndToNamed(OTPView.route,
                arguments: {'isForgot': false, 'email': emailController.text});
          } else {
            Get.offAllNamed(LoginView.route);
          }
        }
      } else {
        ZBotToast.showToastError(
            message: 'please_accept_the_terms_and_conditions'.L());
      }
    }
  }

  Widget firstNameField() {
    return TextFormField(
      controller: firstNameController,
      focusNode: firstNameFN,
      maxLength: 25,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateFirstName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "first_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(lastNameFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      controller: lastNameController,
      focusNode: lastNameFN,
      maxLength: 25,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateLastName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "last_name",
      ),
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
      controller: emailController,
      focusNode: emailFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "email",
      ),
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
          buildConfigDone(context, phoneFN, nextFocus: passFN, isDone: true),
      disableScroll: true,
      autoScroll: false,
      // child: InternationalPhoneNumberInput(
      //   // spaceBetweenSelectorAndTextField: 1,
      //   focusNode: phoneFN,
      //   selectorTextStyle:
      //       R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      //   textStyle: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      //   keyboardAction: TextInputAction.next,
      //   inputDecoration: R.decoration.fieldDecoration(
      //     hintText: 'phone_number',
      //     focusNode: phoneFN,
      //     // suffixIcon: const Icon(
      //     //   Icons.phone,
      //     // ),
      //   ),
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
      //   autoValidateMode: AutovalidateMode.onUserInteraction,
      //   initialValue: number,
      //   textFieldController: phoneController,
      //   keyboardType: const TextInputType.numberWithOptions(
      //       signed: false, decimal: false),
      //   inputBorder: const OutlineInputBorder(),
      //   onSaved: (PhoneNumber number) => setState(() {}),
      //   onFieldSubmitted: (s) => setState(() {
      //     FocusScope.of(context).requestFocus(passFN);
      //     setState(() {});
      //   }),
      //   // onInputValidated: (value) => setState(() {}),
      // ),
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
      inputFormatters: [NoPasteFormatter()],
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

class NoPasteFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > oldValue.text.length &&
        newValue.text.length - oldValue.text.length > 3) {
      // This is likely a paste operation
      return oldValue;
    }
    return newValue;
  }
}
