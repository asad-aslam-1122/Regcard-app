import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/extensions.dart';
import 'package:regcard/src/auth/view/complete_profile/widgets/upload_doc_sheet.dart';
import 'package:regcard/src/base/view/account/view/family_member.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../constant/enums.dart';
import '../../../../resources/resources.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/heights_widths.dart';
import '../../../base/view/account/view/documents_view.dart';
import '../../model/option.dart';
import '../../model/profile_forms_model.dart';
import '../../view_model/auth_vm.dart';

class ProfileForm3 extends StatefulWidget {
  const ProfileForm3({super.key});

  @override
  State<ProfileForm3> createState() => _ProfileForm3State();
}

class _ProfileForm3State extends State<ProfileForm3> {
  Option familyStatusList =
      Option(title: ["no_kids", "kids"], selectedItem: null);
  Option statusList =
      Option(title: ['single', 'taken', 'married'], selectedIndex: -1);
  List<String> kidsList = [];
  List<String> petsList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      log("form 3 init");
      var authVm = Provider.of<AuthVm>(context, listen: false);
      ZBotToast.loadingShow();
      await authVm.getDocument();
      ZBotToast.loadingClose();
      ProfileFormsModel p = AppUser.profileForms;
      statusList.selectedIndex = p.step3?.maritalStatus;
      familyStatusList.selectedItem = p.step3?.hasKids;
      kidsList = p.step3?.kids ?? [];
      petsList = p.step3?.pets ?? [];
      setState(() {});
    });
    super.initState();
  }

  TextEditingController kidsController = TextEditingController();
  FocusNode kidsFN = FocusNode();
  TextEditingController petsController = TextEditingController();
  FocusNode petsFN = FocusNode();

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
                      myDocsWidget(),
                      h2,
                      if (authVm.allDocList
                          .where(
                              (e) => e.documentType == DocumentType.myDocuments)
                          .toList()
                          .isNotEmpty)
                        InkWell(
                          onTap: () {
                            authVm.docViewsList = authVm.allDocList
                                .where((e) =>
                                    e.documentType == DocumentType.myDocuments)
                                .toList();
                            Get.toNamed(DocumentsView.route, arguments: {
                              'docType': DocumentType.myDocuments,
                              'title': 'my_documents'.L(),
                              'documents': authVm.allDocList
                                  .where((e) =>
                                      e.documentType ==
                                      DocumentType.myDocuments)
                                  .toList(),
                            });
                          },
                          child: tile('my_documents'),
                        ),
                      if (authVm.allDocList
                          .where((e) =>
                              e.documentType == DocumentType.familyDocuments)
                          .toList()
                          .isNotEmpty)
                        InkWell(
                          onTap: () {
                            authVm.familyDocsList = authVm.allDocList
                                .where((e) =>
                                    e.documentType ==
                                    DocumentType.familyDocuments)
                                .toList();
                            Get.toNamed(FamilyMemberView.route, arguments: {
                              'docType': DocumentType.familyDocuments,
                              'title': 'family_documents'.L(),
                              'documents': authVm.allDocList
                                  .where((e) =>
                                      e.documentType ==
                                      DocumentType.familyDocuments)
                                  .toList(),
                            });
                          },
                          child: tile('family_documents'),
                        ),
                      if (authVm.allDocList
                          .where((e) =>
                              e.documentType ==
                              DocumentType.additionalDocuments)
                          .toList()
                          .isNotEmpty)
                        InkWell(
                          onTap: () {
                            authVm.docViewsList = authVm.allDocList
                                .where((e) =>
                                    e.documentType ==
                                    DocumentType.additionalDocuments)
                                .toList();
                            Get.toNamed(DocumentsView.route, arguments: {
                              'docType': DocumentType.additionalDocuments,
                              'title': 'additional_documents'.L(),
                              'documents': authVm.allDocList
                                  .where((e) =>
                                      e.documentType ==
                                      DocumentType.additionalDocuments)
                                  .toList(),
                            });
                          },
                          child: tile('additional_documents'),
                        ),
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
                      ...checkBoxRowWidget(statusList, status: true),
                      h1P5,
                      Text(
                        'family'.L(),
                        style: R.textStyles.inter(
                            color: R.colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp),
                      ),
                      h1,
                      ...checkBoxRowWidget(familyStatusList, isFamily: true),
                      if (familyStatusList.selectedItem == true) ...{
                        h1,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: kidsField()),
                            w3,
                            InkWell(
                              onTap: () {
                                if (kidsController.text.trim().isNotEmpty) {
                                  setState(() {
                                    kidsList.add(kidsController.text.trim());
                                  });
                                  kidsController.clear();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                  color: R.colors.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: R.colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      },
                      ...List.generate(
                          kidsList.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(kidsList[index],
                                        style: R.textStyles
                                            .inter(fontSize: 11.sp)),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            kidsList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.remove_circle,
                                            color: R.colors.red, size: 20))
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: petsField()),
                          w3,
                          InkWell(
                            onTap: () {
                              if (petsController.text.trim().isNotEmpty) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  petsList.add(petsController.text.trim());
                                });
                                petsController.clear();
                              } else {
                                ZBotToast.showToastError(
                                    message: "Fields can't be empty");
                                petsController.clear();
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
                      ...List.generate(
                          petsList.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(petsList[index],
                                          style: R.textStyles
                                              .inter(fontSize: 11.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            petsList.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.remove_circle,
                                            color: R.colors.red, size: 20))
                                  ],
                                ),
                              )),
                    ],
                  ),
                ),
                bottomNavigationBar: AppButton(
                  buttonTitle: 'continue',
                  textSize: 10.sp,
                  onTap: () async {
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

  Widget kidsField() {
    return TextFormField(
      controller: kidsController,
      focusNode: kidsFN,
      textCapitalization: TextCapitalization.none,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 32,
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

  Widget tile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: R.colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.L(), style: R.textStyles.inter(fontSize: 10.sp)),
          Icon(Icons.arrow_forward_ios_rounded, color: R.colors.black, size: 15)
        ],
      ),
    );
  }

  Widget myDocsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'my_documents'.L(),
              style: R.textStyles.inter(
                  color: R.colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp),
            ),
            h0P5,
            Text(
              'upload_your_passport_or_id'.L(),
              style: R.textStyles.inter(
                  color: R.colors.black,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        AppButton(
          buttonTitle: 'add',
          onTap: () {
            Get.bottomSheet(const UploadDocumentSheet());
          },
          borderRadius: 25,
          color: R.colors.black,
          textSize: 9.sp,
          fontWeight: FontWeight.w400,
          textColor: R.colors.white,
          buttonWidth: 19.w,
          buttonHeight: 3.5.h,
          textPadding: 0,
        )
      ],
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

  Future<void> onContinueTap(AuthVm authVm) async {
    ZBotToast.loadingShow();
    Map body = {
      "maritalStatus": statusList.selectedIndex,
      "hasKids": familyStatusList.selectedItem,
      "kids": kidsList,
      "pets": petsList
    };
    bool success = await authVm.form3(body: body);
    if (success) {
      AppUser.profileForms.step3 = Step3.fromJson(body);
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex + 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      ZBotToast.loadingClose();
    }
  }
}
