import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/base_view.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/common_bottomsheet.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../utils/bot_toast/zbot_toast.dart';
import '../../model/personalizationOptions.dart';
import '../../model/profile_forms_model.dart';

class ProfileForm7 extends StatefulWidget {
  const ProfileForm7({super.key});

  @override
  State<ProfileForm7> createState() => _ProfileForm7State();
}

class _ProfileForm7State extends State<ProfileForm7> {
  TextEditingController activityController = TextEditingController();
  List<PersonalizationOptions> selectedIndexList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileFormsModel p = AppUser.profileForms;
      selectedIndexList = p.step7?.activityTypes ?? [];
      activityController.text = p.step7?.otherActivity ?? "";
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(builder: (context, authVm, baseVm, _) {
      return SafeAreaWidget(
        backgroundColor: R.colors.transparent,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: R.colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h2,
                Text(
                    "what_type_of_activity_will_the_hotelier_be_able_to_advise"
                        .L(),
                    style: R.textStyles
                        .inter(fontSize: 11.sp, fontWeight: FontWeight.w500)),
                h1P5,
                ...categoriesList(
                    authVm.personalizationType3, selectedIndexList),
                h1P5,
                activityField(),
              ],
            ),
          ),
          bottomNavigationBar: AppButton(
            buttonTitle: 'done',
            textSize: 10.sp,
            onTap: () {
              onContinueTap(authVm, baseVm);
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

  Future<void> onContinueTap(AuthVm authVm, BaseVm baseVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "activityTypeIds": selectedIndexList.map((e) => e.id).toList(),
      "otherActivity": activityController.text.trim()
    };
    bool success = await authVm.form7(body: body);
    if (success) {
      baseVm.getProfile();
      Get.bottomSheet(const CommonBottomSheet(
        title: "congratulations",
        subTitle: "complete_profile_statement",
        showFirstButton: false,
        showSecondButton: false,
      ));
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          authVm.completeProfilePageIndex = 0;
          authVm.update();
          Get.offAllNamed(BaseView.route);
        },
      );
    }
  }

  Widget activityField() {
    return TextFormField(
      controller: activityController,
      // focusNode: emailFN,
      textCapitalization: TextCapitalization.none,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 32,
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

  List<Widget> categoriesList(List<PersonalizationOptions> categories,
      List<PersonalizationOptions> list) {
    return List.generate(categories.length, (index) {
      PersonalizationOptions p = categories[index];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${p.description}",
              style: R.textStyles.inter(
                fontSize: 11.sp,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (list.any((element) => element.id == p.id)) {
                    list.removeWhere((element) => element.id == p.id);
                  } else {
                    list.add(p);
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
                    color: list.any((element) => (element.id == p.id))
                        ? R.colors.primaryColor
                        : R.colors.textFieldFillColor,
                  ),
                  color: R.colors.white,
                ),
                child: list.any((element) => (element.id == p.id))
                    ? Icon(
                        Icons.check,
                        color: R.colors.black,
                        size: 13,
                      )
                    : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
