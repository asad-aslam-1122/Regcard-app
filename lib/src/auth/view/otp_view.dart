import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view/change_pass_view.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/resources.dart';
import '../../../utils/bot_toast/zbot_toast.dart';
import '../../../utils/common_bottomsheet.dart';
import '../../../utils/field_validations.dart';
import '../view_model/auth_vm.dart';
import 'login_view.dart';

class OTPView extends StatefulWidget {
  static String route = '/otp_view';

  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 59;
  int currentSeconds = 0;
  late Timer _timer;
  int start = 60;
  int minute = 1;
  bool hasTimerStopped = false;
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  late StreamSubscription<bool> keyboardSubscription;
  final TextEditingController otpController = TextEditingController();
  FocusNode otpFN = FocusNode();
  String? email;
  bool? isForgot;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (minute == 0 && start == 0) {
          setState(() {
            hasTimerStopped = true;
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
            if (start == 0) {
              if (minute != 0) {
                start = 60;
                minute--;
              }
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dynamic args = Get.arguments;
      isForgot = args['isForgot'];
      email = args['email'];
      setState(() {});
      startTimer();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Scaffold(
            backgroundColor: R.colors.white,
            body: isForgot == true
                ? NestedScrollView(
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
                            title: BackgroundContainer(
                              showBackButton: true,
                            ),
                          ),
                        )
                      ];
                    },
                    body: SafeArea(
                      child: Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 9.w),
                        decoration: BoxDecoration(
                          color: R.colors.white,
                        ),
                        child: otpWidget(authVm),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      const Column(
                        children: [BackgroundContainer(showBackButton: true)],
                      ),
                      Container(
                        width: Get.width,
                        height: Get.height,
                        margin:
                            EdgeInsets.only(top: 15.h, left: 5.w, right: 5.w),
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                            color: R.colors.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: otpWidget(authVm),
                        ),
                      ),
                    ],
                  )));
  }

  Widget otpWidget(AuthVm authVm) {
    return Form(
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
            'enter_otp'.L(),
            textAlign: TextAlign.center,
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 19.sp,
                fontWeight: FontWeight.w600),
          ),
          h3,
          Text("enter_otp_statement".L(),
              textAlign: TextAlign.center,
              style: R.textStyles.inter(
                fontWeight: FontWeight.w300,
                color: R.colors.black,
                fontSize: 11.sp,
              )),
          Text(
            checkEmail(email: email ?? ''),
            style: R.textStyles.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
              color: R.colors.black,
            ),
          ),
          h2,
          PinCodeTextField(
            appContext: context,
            enableActiveFill: true,
            controller: otpController,
            keyboardType: TextInputType.number,
            focusNode: otpFN,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                FieldValidator.validateOTP(otpController.text),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              LengthLimitingTextInputFormatter(06),
            ],
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(2),
              fieldHeight: 45,
              fieldWidth: 45,
              activeColor: R.colors.textFieldFillColor,
              activeFillColor: R.colors.textFieldFillColor,
              selectedColor: R.colors.black,
              selectedFillColor: R.colors.textFieldFillColor,
              disabledColor: R.colors.textFieldFillColor,
              inactiveColor: R.colors.textFieldFillColor,
              inactiveFillColor: R.colors.textFieldFillColor,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: R.colors.transparent,
            textStyle: R.textStyles.inter(
              color: R.colors.black,
            ),
            onCompleted: (value) {
              debugPrint("Completed");
            },
            onTap: () {},
            onChanged: (value) {
              debugPrint(value);
            },
          ),
          h2,
          AppButton(
            buttonTitle: 'proceed',
            textSize: 11.sp,
            fontWeight: FontWeight.w500,
            textColor: isForgot == true ? R.colors.black : R.colors.white,
            color:
                isForgot == true ? R.colors.textFieldFillColor : R.colors.black,
            borderRadius: 25,
            borderColor: R.colors.black,
            horizentalPadding: 18.w,
            textPadding: 1.5.h,
            onTap: () async {
              onTapVerifyOTP(authVm);
            },
          ),
          h3,
          Text.rich(
            TextSpan(
              style: R.textStyles
                  .inter(
                      fontWeight: FontWeight.w300,
                      fontSize: 10.sp,
                      color: R.colors.lightGreyColor)
                  .copyWith(),
              children: [
                TextSpan(
                  text: start >= 10 ? "0$minute:$start" : "0$minute:0$start",
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: 'sec'.L(),
                ),
              ],
            ),
          ),
          h0P2,
          start == 0
              ? GestureDetector(
                  onTap: () async {
                    ZBotToast.loadingShow();
                    Map body = {"existingEmail": email, "newEmail": "#"};
                    bool check = await authVm.otpGenerate(body: body);
                    if (check) {
                      start = 60;
                      minute = 1;
                      setState(() {});
                      startTimer();
                      ZBotToast.loadingClose();
                    }
                  },
                  child: Text(
                    'resend_code'.L(),
                    style: R.textStyles.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: R.colors.black,
                    ) /*.copyWith(decoration: TextDecoration.underline)*/,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<void> onTapVerifyOTP(AuthVm authVm) async {
    if (_formKey.currentState!.validate()) {
      if (isForgot == true) {
        Get.toNamed(ChangePassView.route,
            arguments: {"email": email, "otp": otpController.text});
      } else {
        ZBotToast.loadingShow();
        final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
        debugPrint("time is : $currentTimeZone}");

        Map body = {
          "email": email,
          "otp": otpController.text,
          'fcmToken': '',
          'timeZoneId': currentTimeZone
        };
        bool check = await authVm.otpVerify(body: body);
        if (check) {
          Get.bottomSheet(
              enableDrag: false,
              isDismissible: false,
              CommonBottomSheet(
                title: 'congratulations',
                subTitle: 'signup_congrats_desc',
                firstButtonTitle: 'login',
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
  }

  String checkEmail({required String email}) {
    int index = email.indexOf('@');
    if (index > 0) {
      String firstCharacter = email.characters.first;
      String firstSecondCharacter = email.substring(0, 2);
      String firstPart = email.substring(0, index);
      String secondPart = email.substring(index);
      String maskedEmail = '';
      if (firstPart.length < 2) {
        return firstCharacter + secondPart;
      } else {
        for (int i = 2; i < firstPart.length; i++) {
          maskedEmail += '*';
        }
        return firstSecondCharacter + maskedEmail + secondPart;
      }
    } else {
      return 'Invalid email format';
    }
  }
}
