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

import '../../../constant/enums.dart';
import '../../../resources/resources.dart';
import '../../../utils/bot_toast/zbot_toast.dart';
import '../../../utils/common_bottomsheet.dart';
import '../../../utils/field_validations.dart';
import '../view_model/auth_vm.dart';
import 'login_view.dart';

class ChangePassView extends StatefulWidget {
  static String route = '/change_pass_view';
  const ChangePassView({super.key});

  @override
  State<ChangePassView> createState() => _ChangePassViewState();
}

class _ChangePassViewState extends State<ChangePassView> {
  ScrollController scrollController = ScrollController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode passFN = FocusNode();
  FocusNode confirmPassFN = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription<bool> keyboardSubscription;
  bool passObscure = true;
  bool passObscure2 = true;
  String? email;
  String? otp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dynamic data = ModalRoute.of(context)?.settings.arguments;
      if (data != null) {
        if (data['email'] != null) {
          otp = data['otp'];
          email = data["email"];
        }
      }
      setState(() {});
      print(data);
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
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
                            'change_password'.L(),
                            style: R.textStyles.inter(
                                color: R.colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 19.sp),
                          ),
                          h3,
                          passField(),
                          h2P5,
                          confirmPassField(),
                          h3,
                          AppButton(
                            buttonTitle: 'save',
                            textSize: 11.sp,
                            onTap: () {
                              onTapReset(authVm);
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

  Future<void> onTapReset(AuthVm authVm) async {
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();
      Map body = {
        "email": email,
        "resetOption": ResetPasswordOptionEnum.otp.index,
        "resetValue": otp,
        "password": passwordController.text.trim()
      };
      bool check = await authVm.resetPass(body: body);
      if (check) {
        Get.bottomSheet(
            enableDrag: false,
            isDismissible: false,
            CommonBottomSheet(
              title: 'password_reset',
              subTitle: 'password_reset_desc',
              firstButtonTitle: 'sign_in',
              firstButtonOnTap: () {
                Get.offAllNamed(
                  LoginView.route,
                );
              },
              willPop: false,
              showFirstButton: true,
              showSecondButton: false,
            ));
      }
    }
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
      obscureText: passObscure2,
      focusNode: confirmPassFN,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: (value) =>
          FieldValidator.validatePasswordMatch(value, passwordController.text),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "confirm_password",
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              passObscure2 = !passObscure2;
            });
          },
          child: Icon(
            passObscure2
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
