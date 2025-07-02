import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/extensions.dart';
import 'package:regcard/src/auth/model/option.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../resources/resources.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../utils/safe_area_widget.dart';
import '../../model/profile_forms_model.dart';
import '../../view_model/auth_vm.dart';

class ProfileForm4 extends StatefulWidget {
  const ProfileForm4({super.key});

  @override
  State<ProfileForm4> createState() => _ProfileForm4State();
}

class _ProfileForm4State extends State<ProfileForm4> {
  Option smoker = Option(title: ["non_smoker", "smoker"], selectedItem: null);
  Option problem = Option(title: ["no", "yes"], selectedItem: null);
  List<String> allergies = [];
  TextEditingController healthController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  TextEditingController footSizeController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileFormsModel p = AppUser.profileForms;
      smoker.selectedItem = p.step4?.isSmoker;
      healthController.text = p.step4?.healthProblem ?? "";
      problem.selectedItem = p.step4?.hasMobilityProblem;
      footSizeController.text = p.step4?.footSize ?? "";
      allergies = p.step4?.allergies ?? [];
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
                      ...checkBoxRowWidget(smoker),
                      h2,
                      Text("health_problem_statement".L(),
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w500, fontSize: 11.sp)),
                      h1,
                      healthField(),
                      h2,
                      Text("do_you_have_any_allergies?".L(),
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w500, fontSize: 11.sp)),
                      h1,
                      Row(
                        children: [
                          Expanded(child: allergyField()),
                          w3,
                          InkWell(
                            onTap: () {
                              if (allergyController.text.trim().isNotEmpty) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  allergies.add(allergyController.text.trim());
                                });
                                allergyController.clear();
                              } else {
                                ZBotToast.showToastError(
                                    message: "Fields can't be empty");

                                allergyController.clear();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: R.colors.primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: Icon(Icons.add, color: R.colors.white),
                            ),
                          )
                        ],
                      ),
                      h1,
                      ...List.generate(
                          allergies.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(allergies[index],
                                          style: R.textStyles
                                              .inter(fontSize: 11.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    w2,
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            allergies.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.remove_circle,
                                            color: R.colors.red, size: 20))
                                  ],
                                ),
                              )),
                      h1P5,
                      Text("do_you_have_any_mobility_problems?".L(),
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w500, fontSize: 11.sp)),
                      h1,
                      ...checkBoxRowWidget(problem),
                      h1P5,
                      Text("foot_size".L(),
                          style: R.textStyles.inter(
                            fontSize: 11.sp,
                          )),
                      h1,
                      footSizeField(),
                      h3,
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
            ));
  }

  Widget healthField() {
    return TextFormField(
      controller: healthController,
      // focusNode: emailFN,
      maxLines: 2,
      maxLength: 100,
      textCapitalization: TextCapitalization.sentences,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration
          .fieldDecoration(hintText: "write_here"),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget allergyField() {
    return TextFormField(
      controller: allergyController,
      maxLength: 30,
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

  Widget footSizeField() {
    return TextFormField(
      controller: footSizeController,
      // focusNode: emailFN,
      maxLength: 3,
      textCapitalization: TextCapitalization.words,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.number,
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

  List<Widget> checkBoxRowWidget(Option list) {
    return List.generate(
        list.title?.length ?? 0,
        (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(list.title?[index].L() ?? "",
                      style: R.textStyles.inter(
                        fontSize: 11.sp,
                      )),
                  InkWell(
                    onTap: () {
                      setState(() {
                        list.selectedItem = index.toBool();
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: list.selectedItem == index.toBool()
                                  ? R.colors.primaryColor
                                  : R.colors.textFieldFillColor),
                          color: R.colors.white),
                      child: list.selectedItem == index.toBool()
                          ? Icon(Icons.check, color: R.colors.black, size: 13)
                          : null,
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> onContinueTap(AuthVm authVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "isSmoker": smoker.selectedItem,
      "healthProblem": healthController.text.trim(),
      "hasMobilityProblem": problem.selectedItem,
      "footSize": footSizeController.text.trim(),
      "allergies": allergies
    };
    bool success = await authVm.form4(body: body);
    AppUser.profileForms.step4 = Step4.fromJson(body);
    if (success) {
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex + 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      ZBotToast.loadingClose();
    }
  }
}
