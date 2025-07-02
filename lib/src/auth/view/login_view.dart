import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view/complete_profile/complete_profile_form.dart';
import 'package:regcard/src/auth/view/forgot_pass_view.dart';
import 'package:regcard/src/auth/view/signup_view.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/base_view.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/deviceType.dart';
import 'package:regcard/utils/global_functions.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../constant/app_user.dart';
import '../../../resources/resources.dart';
import '../../../utils/bot_toast/zbot_toast.dart';
import '../../../utils/field_validations.dart';
import '../../base/view_model/base_vm.dart';
import 'otp_view.dart';

class LoginView extends StatefulWidget {
  static String route = '/login_view';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFN = FocusNode();
  TextEditingController emailController = TextEditingController();
  FocusNode passFN = FocusNode();
  bool passObscure = true;
  ScrollController scrollController = ScrollController();
  late StreamSubscription<bool> keyboardSubscription;
  final deviceInfoPlugin = DeviceInfoPlugin();
  String? deviceName;
  int? deviceType;

  bool showPass = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var keyboardVisibilityController = KeyboardVisibilityController();
      if (Platform.isAndroid) {
        var info = await deviceInfoPlugin.androidInfo;
        deviceName = info.model;
      } else if (Platform.isIOS) {
        var info = await deviceInfoPlugin.iosInfo;
        deviceName = info.name;
      }
      deviceType = getDeviceType(context);
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
        builder: (context, authVm, child) => WillPopScope(
            onWillPop: GlobalFunctions.onWillPop,
            child: Scaffold(
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
                        title: BackgroundContainer(showBackButton: false),
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
                            'login'.L(),
                            style: R.textStyles.inter(
                                color: R.colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 19.sp),
                          ),
                          h3,
                          emailField(),
                          h2,
                          passField(),
                          h2,
                          Material(
                            color: R.colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                splashColor: R.colors.greyBackgroundColor,
                                splashFactory: InkSparkle.splashFactory,
                                onTap: () {
                                  Get.toNamed(ForgotPassView.route);
                                },
                                child: Text(
                                  'forgot_password?'.L(),
                                  style: R.textStyles.inter(
                                    color: R.colors.black,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          h2P5,
                          AppButton(
                            buttonTitle: 'login',
                            textSize: 11.sp,
                            onTap: () {
                              onLoginTap(authVm);
                            },
                            fontWeight: FontWeight.w500,
                            textColor: R.colors.black,
                            color: R.colors.textFieldFillColor,
                            borderRadius: 25,
                            borderColor: R.colors.black,
                            horizentalPadding: 18.w,
                            textPadding: 1.5.h,
                          ),
                          h2P5,
                          Material(
                            color: R.colors.transparent,
                            child: InkWell(
                              splashColor: R.colors.greyBackgroundColor,
                              splashFactory: InkSparkle.splashFactory,
                              onTap: () {
                                Get.toNamed(SignupView.route);
                              },
                              child: Text(
                                'create_an_account'.L(),
                                style: R.textStyles.inter(
                                  color: R.colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<void> onLoginTap(AuthVm authVm) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var vm = Provider.of<BaseVm>(context, listen: false);
    var homeVm = Provider.of<HomeVm>(context, listen: false);
    var regCardsVm = Provider.of<MyRegCardVm>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      await authVm.updateFCM();
      Map loginBody = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'fcmToken': AppUser.fcmToken,
        'timeZoneId': currentTimeZone,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "appVersion": AppUser.appVersion
      };
      bool loginResponse = await authVm.login(body: loginBody);
      if (loginResponse) {
        bool getProfile = await vm.getProfile();
        authVm.getPersonalizationOptions(id: 0);
        authVm.getPersonalizationOptions(id: 1);
        authVm.getPersonalizationOptions(id: 2);
        authVm.getPersonalizationOptions(id: 3);
        if (getProfile) {
          await regCardsVm.getAllDurations();
          if (AppUser.login.emailConfirmationRequired == true &&
              AppUser.login.emailConfirmed == false) {
            ZBotToast.showToastError(message: "email_not_verified".L());
            ZBotToast.loadingShow();
            Map otpBody = {
              "existingEmail": emailController.text.trim(),
              "newEmail": "#"
            };

            bool otpResponse = await authVm.otpGenerate(body: otpBody);
            if (otpResponse) {
              Get.toNamed(OTPView.route, arguments: {
                'isForgot': false,
                'email': emailController.text.trim()
              });
            }
          } else {
            await authVm.getProfileWithSteps();
            homeVm.getTravelGuides();
            homeVm.getHomeMembers();
            homeVm.getChatHead();
            homeVm.getMembers();
            regCardsVm.getAllRegCards(pageNumber: 1);
            AppUser.profileForms.profileStep != 7
                ? {
                    authVm.completeProfilePageIndex =
                        AppUser.profileForms.profileStep ?? 0,
                    authVm.completeProfilePageController = PageController(
                        initialPage: authVm.completeProfilePageIndex),
                    authVm.update(),
                    Get.toNamed(CompleteProfileForm.route),
                  }
                : Get.offAllNamed(BaseView.route);
          }
        }
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
      textInputAction: TextInputAction.next,
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
        FocusScope.of(context).requestFocus(passFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget passField() {
    return TextFormField(
      controller: passwordController,
      focusNode: passFN,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: FieldValidator.validatePassEmptyField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: !showPass,
      decoration: R.decoration.fieldDecoration(
          hintText: "password",
          suffixIcon: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                showPass = !showPass;
                setState(() {});
              },
              icon: Icon(
                showPass ? Icons.visibility : Icons.visibility_off_outlined,
                color: R.colors.lightGreyColor,
              ))),
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
