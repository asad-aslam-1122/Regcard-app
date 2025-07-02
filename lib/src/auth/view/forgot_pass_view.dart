import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/resources.dart';
import '../../../utils/bot_toast/zbot_toast.dart';
import '../../../utils/field_validations.dart';
import '../view_model/auth_vm.dart';
import 'otp_view.dart';

class ForgotPassView extends StatefulWidget {
  static String route = '/forgot_view';
  const ForgotPassView({super.key});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView> {
  final _formKey = GlobalKey<FormState>();
  FocusNode emailFN = FocusNode();
  TextEditingController emailController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 30000,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              resizeToAvoidBottomInset: false,
              body: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      centerTitle: true,
                      backgroundColor: R.colors.transparent,
                      automaticallyImplyLeading: false,
                      floating: true,
                      pinned: false,
                      toolbarHeight: 25.h,
                      shadowColor: R.colors.transparent,
                      flexibleSpace: const FlexibleSpaceBar(
                        centerTitle: true,
                        title: BackgroundContainer(showBackButton: true),
                      ),
                    )
                  ];
                },
                body: SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 9.w),
                    color: R.colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          h1,
                          Image.asset(
                            R.images.appLogo,
                            scale: 3,
                          ),
                          h3,
                          Text(
                            'forgot_password'.L(),
                            style: R.textStyles.inter(
                                color: R.colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 19.sp),
                          ),
                          h1P5,
                          Text(
                            'forgot_password_desc'.L(),
                            textAlign: TextAlign.center,
                            style: R.textStyles.inter(
                                color: R.colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 11.sp),
                          ),
                          h3,
                          emailField(),
                          h3,
                          AppButton(
                            buttonTitle: 'proceed',
                            textSize: 11.sp,
                            onTap: () {
                              onTapSendCode(authVm);
                            },
                            fontWeight: FontWeight.w500,
                            textColor: R.colors.black,
                            color: R.colors.textFieldFillColor,
                            borderRadius: 25,
                            borderColor: R.colors.black,
                            horizentalPadding: 18.w,
                            textPadding: 1.5.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  Future<void> onTapSendCode(AuthVm authVm) async {
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();
      Map body = {
        "existingEmail": emailController.text.trim(),
        "newEmail": "#"
      };
      bool check = await authVm.otpGenerate(body: body);
      if (check) {
        ZBotToast.showToastSuccess(message: "verification_code_message".L());
        Get.toNamed(OTPView.route, arguments: {
          'isForgot': true,
          'email': emailController.text.trim()
        });
      }
    }
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      focusNode: emailFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: FieldValidator.validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "email_address",
      ),
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
