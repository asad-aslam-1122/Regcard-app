import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../utils/bot_toast/zbot_toast.dart';
import '../../model/personalizationOptions.dart';
import '../../model/profile_forms_model.dart';

class ProfileForm5 extends StatefulWidget {
  const ProfileForm5({super.key});

  @override
  State<ProfileForm5> createState() => _ProfileForm5State();
}

class _ProfileForm5State extends State<ProfileForm5> {
  TextEditingController clotheSizeController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController pescatarianController = TextEditingController();
  List<PersonalizationOptions> selectedList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileFormsModel p = AppUser.profileForms;
      clotheSizeController.text = p.step5?.clotheSize ?? '';
      tempController.text = p.step5?.roomTemperature ?? '';
      pescatarianController.text = p.step5?.pescatarianPreference ?? '';
      selectedList = p.step5?.foodPersonalities ?? [];
      log("a ${p.step5?.foodPersonalities?.length}");
      print("ff${selectedList.length}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(builder: (context, authVm, _) {
      return SafeAreaWidget(
        backgroundColor: R.colors.transparent,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: R.colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("clothe_size".L(),
                    style: R.textStyles.inter(fontSize: 11.sp)),
                h1,
                clotheSizeField(),
                h2,
                Text("personalized".L(),
                    style: R.textStyles
                        .inter(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                Text("what_is_the_ideal_temperature_for_your_room?".L(),
                    style: R.textStyles
                        .inter(fontSize: 11.sp, fontWeight: FontWeight.w500)),
                h1,
                tempField(),
                h2,
                ...List.generate(authVm.personalizationType0.length, (index) {
                  PersonalizationOptions p = authVm.personalizationType0[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${p.description}",
                            style: R.textStyles.inter(
                              fontSize: 11.sp,
                            )),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedList
                                  .any((element) => element.id == p.id)) {
                                selectedList.removeWhere(
                                    (element) => element.id == p.id);
                              } else {
                                selectedList.add(p);
                              }
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: selectedList.any(
                                            (element) => (element.id == p.id))
                                        ? R.colors.primaryColor
                                        : R.colors.textFieldFillColor),
                                color: R.colors.white),
                            child: selectedList
                                    .any((element) => (element.id == p.id))
                                ? Icon(Icons.check,
                                    color: R.colors.black, size: 13)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                h1P5,
                Text("pescatarian".L(),
                    style: R.textStyles.inter(fontSize: 11.sp)),
                h1,
                pescatarianField()
              ],
            ),
          ),
          bottomNavigationBar: AppButton(
            buttonTitle: 'continue',
            textSize: 10.sp,
            onTap: () {
              onContinueTap(authVm);
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
      );
    });
  }

  Widget clotheSizeField() {
    return TextFormField(
      controller: clotheSizeController,
      maxLength: 10,
      // focusNode: emailFN,
      textCapitalization: TextCapitalization.words,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "write_here",
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

  Widget tempField() {
    return TextFormField(
      controller: tempController,
      maxLength: 7,
      // focusNode: emailFN,
      textCapitalization: TextCapitalization.words,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "write_here",
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

  Widget pescatarianField() {
    return TextFormField(
      controller: pescatarianController,
      // focusNode: emailFN,
      textCapitalization: TextCapitalization.words,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      maxLength: 32,
      textInputAction: TextInputAction.done,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "write_here",
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

  Future<void> onContinueTap(AuthVm authVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "clothSize": clotheSizeController.text.trim(),
      "roomTemperature": tempController.text.trim(),
      "pescatarianPreference": pescatarianController.text.trim(),
      "foodPersonalityIds": selectedList.map((e) => e.id).toList()
    };
    bool success = await authVm.form5(body: body);
    if (success) {
      Step5 p = AppUser.profileForms.step5 ?? Step5();
      p.clotheSize = clotheSizeController.text;
      p.roomTemperature = tempController.text;
      p.pescatarianPreference = pescatarianController.text;
      p.foodPersonalities = selectedList;
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex + 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      ZBotToast.loadingClose();
    }
  }
}
