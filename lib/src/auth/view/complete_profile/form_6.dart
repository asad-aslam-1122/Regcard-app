import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/model/personalizationOptions.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../utils/bot_toast/zbot_toast.dart';
import '../../model/profile_forms_model.dart';

class ProfileForm6 extends StatefulWidget {
  const ProfileForm6({super.key});

  @override
  State<ProfileForm6> createState() => _ProfileForm6State();
}

class _ProfileForm6State extends State<ProfileForm6> {
  TextEditingController gastronomyController = TextEditingController();
  List<PersonalizationOptions> selectedIndexList1 = [];
  List<PersonalizationOptions> selectedIndexList2 = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileFormsModel p = AppUser.profileForms;
      gastronomyController.text = p.step6?.otherGastronomy ?? '';
      selectedIndexList1 = p.step6?.gastronomyTypes ?? [];
      selectedIndexList2 = p.step6?.restaurantTypes ?? [];
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
                Text("what_types_of_gastronomy_do_you_like?".L(),
                    style: R.textStyles
                        .inter(fontSize: 11.sp, fontWeight: FontWeight.w500)),
                h1P5,
                ...categoriesList(
                    authVm.personalizationType1, selectedIndexList1),
                h1P5,
                gastronomyField(),
                h1,
                Text("what_types_of_resturants_do_you_prefer?".L(),
                    style: R.textStyles
                        .inter(fontSize: 11.sp, fontWeight: FontWeight.w500)),
                h2,
                ...categoriesList(
                    authVm.personalizationType2, selectedIndexList2)
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

  Future<void> onContinueTap(AuthVm authVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "otherGastronomy": gastronomyController.text.trim(),
      "gastronomyTypeIds": selectedIndexList1.map((e) => e.id).toList(),
      "restaurantTypeIds": selectedIndexList2.map((e) => e.id).toList(),
    };
    bool success = await authVm.form6(body: body);
    if (success) {
      Step6 p = AppUser.profileForms.step6 ?? Step6();
      p.otherGastronomy = gastronomyController.text;
      p.gastronomyTypes = selectedIndexList1;
      p.restaurantTypes = selectedIndexList2;
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex + 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      ZBotToast.loadingClose();
    }
  }

  Widget gastronomyField() {
    return TextFormField(
      controller: gastronomyController,
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
