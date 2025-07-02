import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/extensions.dart';
import 'package:regcard/src/base/view/account/model/preferences_model.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/background_container.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../auth/model/option.dart';
import '../../../view_model/base_vm.dart';

class PreferencesView extends StatefulWidget {
  static String route = "/preferences_view";

  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  Option familyStatusList =
      Option(title: ["no_kids", "kids"], selectedItem: null);
  Option statusList =
      Option(title: ['single', 'taken', 'married'], selectedIndex: -1);
  List kidsList = [];
  List petsList = [];

  TextEditingController kidsController = TextEditingController();
  TextEditingController healthController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  TextEditingController footSizeController = TextEditingController();
  TextEditingController petsController = TextEditingController();
  FocusNode petsFN = FocusNode();
  FocusNode kidsFN = FocusNode();
  TextEditingController clotheSizeController = TextEditingController();

  Option smoker = Option(title: ["smoker", "non_smoker"], selectedItem: null);
  Option problem = Option(title: ["yes", "no"], selectedItem: null);
  List allergies = [];

  @override
  void initState() {
    ZBotToast.loadingShow();
    var baseVm = Provider.of<BaseVm>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await baseVm.getPreferences();
      PreferencesModel p = baseVm.preferencesModel;

      statusList.selectedIndex = p.maritalStatus;
      familyStatusList.selectedItem = p.hasKids ?? false;
      kidsList = p.kids ?? [];
      petsList = p.pets ?? [];
      smoker.selectedItem = p.isSmoker;
      healthController.text = p.healthProblem ?? "";
      problem.selectedItem = p.hasMobilityProblem;
      footSizeController.text = p.footSize ?? "";
      allergies = p.allergies ?? [];
      clotheSizeController.text = p.clotheSize ?? '';
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
                resizeToAvoidBottomInset: true,
                backgroundColor: R.colors.white,
                body: Stack(
                  children: [
                    Column(
                      children: [
                        BackgroundContainer(
                          showBackButton: true,
                          showLogoutButton: false,
                          showLanguageButton: false,
                          onBack: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                    Container(
                        width: Get.width,
                        height: Get.height,
                        margin:
                            EdgeInsets.only(top: 15.h, left: 5.w, right: 5.w),
                        decoration: BoxDecoration(
                            color: R.colors.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    h2P5,
                                    Center(
                                      child: Image.asset(
                                        R.images.appLogo,
                                        scale: 3,
                                      ),
                                    ),
                                    h1,
                                    h2,
                                    Text(
                                      'my_preferences'.L(),
                                      style: R.textStyles.inter(
                                          color: R.colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp),
                                    ),
                                    h0P5,
                                    Text(
                                      'my_preferences_desc'.L(),
                                      style: R.textStyles.inter(
                                          color: R.colors.lightGreyColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp),
                                    ),
                                    h1,
                                    ...checkBoxRowWidget(statusList,
                                        status: true),
                                    h1P5,
                                    Text(
                                      'family'.L(),
                                      style: R.textStyles.inter(
                                          color: R.colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp),
                                    ),
                                    h1,
                                    ...checkBoxRowWidget(familyStatusList,
                                        isFamily: true),
                                    if (familyStatusList.selectedItem ==
                                        true) ...{
                                      h1,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: kidsField()),
                                          w3,
                                          InkWell(
                                            onTap: () {
                                              if (kidsController.text
                                                  .trim()
                                                  .isNotEmpty) {
                                                setState(() {
                                                  kidsList.add(kidsController
                                                      .text
                                                      .trim());
                                                });
                                                kidsController.clear();
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: R.colors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                              child: Icon(Icons.add,
                                                  color: R.colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    },
                                    h0P5,
                                    ...List.generate(
                                        kidsList.length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(kidsList[index],
                                                        style: R.textStyles
                                                            .inter(
                                                                fontSize:
                                                                    11.sp),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          kidsList
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.remove_circle,
                                                          color: R.colors.red,
                                                          size: 20))
                                                ],
                                              ),
                                            )),
                                    h1P5,
                                    Text(
                                      'pets'.L(),
                                      style: R.textStyles.inter(
                                          color: R.colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp),
                                    ),
                                    h0P5,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: petsField()),
                                        w3,
                                        InkWell(
                                          onTap: () {
                                            if (petsController.text
                                                .trim()
                                                .isNotEmpty) {
                                              setState(() {
                                                petsList.add(
                                                    petsController.text.trim());
                                              });
                                              petsController.clear();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: R.colors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: Icon(Icons.add,
                                                color: R.colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    h0P5,
                                    ...List.generate(
                                        petsList.length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(petsList[index],
                                                        style: R.textStyles
                                                            .inter(
                                                                fontSize:
                                                                    11.sp),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          petsList
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.remove_circle,
                                                          color: R.colors.red,
                                                          size: 20))
                                                ],
                                              ),
                                            )),
                                    h1,
                                    ...checkBoxRowWidget(smoker),
                                    h2,
                                    Text("health_problem_statement".L(),
                                        style: R.textStyles.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp)),
                                    h1,
                                    healthField(),
                                    h2,
                                    Text("do_you_have_any_allergies?".L(),
                                        style: R.textStyles.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp)),
                                    h1,
                                    Row(
                                      children: [
                                        Expanded(child: allergyField()),
                                        w3,
                                        InkWell(
                                          onTap: () {
                                            if (allergyController.text
                                                .trim()
                                                .isNotEmpty) {
                                              setState(() {
                                                allergies.add(allergyController
                                                    .text
                                                    .trim());
                                              });
                                              allergyController.clear();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: R.colors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                            child: Icon(Icons.add,
                                                color: R.colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    h1,
                                    ...List.generate(
                                        allergies.length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        allergies[index],
                                                        style: R.textStyles
                                                            .inter(
                                                                fontSize:
                                                                    11.sp),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          allergies
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.remove_circle,
                                                          color: R.colors.red,
                                                          size: 20))
                                                ],
                                              ),
                                            )),
                                    h1P5,
                                    Text(
                                        "do_you_have_any_mobility_problems?"
                                            .L(),
                                        style: R.textStyles.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp)),
                                    h1,
                                    ...checkBoxRowWidget(problem),
                                    h1P5,
                                    Text("foot_size".L(),
                                        style: R.textStyles.inter(
                                          fontSize: 11.sp,
                                        )),
                                    h1,
                                    footSizeField(),
                                    h2,
                                    Text("clothe_size".L(),
                                        style: R.textStyles
                                            .inter(fontSize: 11.sp)),
                                    h1,
                                    clotheSizeField(),
                                    h2,
                                  ],
                                ),
                              ),
                            ),
                            h1,
                            AppButton(
                              buttonTitle: 'update',
                              textSize: 10.sp,
                              onTap: () {
                                onUpdateTap(baseVm);
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
                            h1,
                          ],
                        )),
                  ],
                ),
              ),
            ));
  }

  Future<void> onUpdateTap(BaseVm baseVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "maritalStatus": statusList.selectedIndex,
      "hasKids": familyStatusList.selectedItem,
      "kids": kidsList,
      "pets": petsList,
      "isSmoker": smoker.selectedItem,
      "healthProblem": healthController.text.trim(),
      "hasMobilityProblem": problem.selectedItem,
      "footSize": footSizeController.text.trim(),
      "allergies": allergies,
      "clothSize": clotheSizeController.text.trim(),
    };

    bool check = await baseVm.updatePreferences(body: body);
    if (check) {
      Get.back();
      ZBotToast.showToastSuccess(
          message: 'preferences_updated_successfully'.L());
    }
  }

  Widget kidsField() {
    return TextFormField(
      controller: kidsController,
      focusNode: kidsFN,
      maxLength: 32,
      textCapitalization: TextCapitalization.none,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "number_of_kids_sex",
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

  Widget petsField() {
    return TextFormField(
      controller: petsController,
      focusNode: petsFN,
      maxLength: 30,
      textCapitalization: TextCapitalization.none,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

  List<Widget> checkBoxRowWidget(Option list,
      {bool? isFamily, bool status = false}) {
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
                        if (status == false) {
                          list.selectedItem = index.toBool();
                          if (familyStatusList.selectedItem == false &&
                              isFamily == true) {
                            kidsList.clear();
                            setState(() {});
                          }
                        } else {
                          list.selectedIndex = index;
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
                              color: (!status
                                      ? list.selectedItem == index.toBool()
                                      : (list.selectedIndex == index))
                                  ? R.colors.primaryColor
                                  : R.colors.textFieldFillColor),
                          color: R.colors.white),
                      child: (!status
                              ? list.selectedItem == index.toBool()
                              : (list.selectedIndex == index))
                          ? Icon(Icons.check, color: R.colors.black, size: 13)
                          : null,
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget healthField() {
    return TextFormField(
      controller: healthController,
      // focusNode: emailFN,
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
      // autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      // validator: FieldValidator.validateEmail,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration
          .fieldDecoration(hintText: "write_here", verticalPadding: 6),
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
      // focusNode: emailFN,
      maxLength: 30,
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
      maxLength: 10,
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

  Widget clotheSizeField() {
    return TextFormField(
      controller: clotheSizeController,
      // focusNode: emailFN,
      maxLength: 7,
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
}
