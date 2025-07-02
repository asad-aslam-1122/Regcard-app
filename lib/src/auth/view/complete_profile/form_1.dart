import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:regcard/services/date_picker/date_picker.dart';
import 'package:regcard/src/auth/model/profile_forms_model.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/document_type_sheet.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constant/app_user.dart';
import '../../../../resources/resources.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/display_image.dart';
import '../../../../utils/field_validations.dart';
import '../../../../utils/heights_widths.dart';
import '../../../base/view_model/base_vm.dart';

class ProfileForm1 extends StatefulWidget {
  const ProfileForm1({super.key});

  @override
  State<ProfileForm1> createState() => _ProfileForm1State();
}

class _ProfileForm1State extends State<ProfileForm1> {
  DateTime? selectedDate;
  TextEditingController addressController = TextEditingController();
  FocusNode addressFN = FocusNode();
  TextEditingController cityController = TextEditingController();
  FocusNode cityFN = FocusNode();
  TextEditingController countryController = TextEditingController();
  FocusNode countryFN = FocusNode();
  TextEditingController dobC = TextEditingController();
  FocusNode dobFN = FocusNode();
  String? image = "";
  File? imageFile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ProfileFormsModel p = AppUser.profileForms;
      image = p.step1?.pictureUrl ?? '';
      addressController.text = p.step1?.address ?? "";
      cityController.text = p.step1?.city ?? "";
      countryController.text = p.step1?.country ?? "";
      if ((p.step1?.birthDate ?? "").isNotEmpty || p.step1?.birthDate != null) {
        selectedDate = DateTime.parse(p.step1?.birthDate ?? "");
        dobC.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(
        builder: (context, authVm, baseVm, child) => SafeAreaWidget(
              backgroundColor: R.colors.transparent,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: R.colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(DocumentTypeSheet(
                            showDocument: false,
                            uploadImage: (value) {
                              setState(() {
                                image = value?.path;
                                imageFile = value;
                              });
                            },
                          ));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            imageFile != null
                                ? CircularProfileAvatar(
                                    AppUser.profileForms.step1?.pictureUrl ??
                                        '',
                                    radius: 55,
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : AppUser.profileForms.step1?.pictureUrl !=
                                            "" &&
                                        AppUser.profileForms.step1
                                                ?.pictureUrl !=
                                            null
                                    ? DisplayImage(
                                        imageUrl: AppUser
                                            .profileForms.step1?.pictureUrl,
                                        borderColor: R.colors.lightGreyColor,
                                        borderWidth: 0,
                                        isCircle: true,
                                        hasMargin: false,
                                        height: 30.w,
                                        width: 30.w,
                                        hasBorder: true,
                                        isAllowOnTap: false,
                                      )
                                    : CircularProfileAvatar(
                                        "",
                                        radius: 55,
                                        child: DottedBorder(
                                          dashPattern: [6, 4],
                                          color: R.colors.lightGreyColor,
                                          borderType: BorderType.Circle,
                                          strokeWidth: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    R.colors.textFieldFillColor,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ),
                            if (image == '')
                              Icon(
                                Icons.add,
                                color: R.colors.lightGreyColor,
                                size: 25,
                              ),
                          ],
                        ),
                      ),
                      h1,
                      Text(
                        'upload_your_photo'.L(),
                        style: R.textStyles.inter(
                            color: R.colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      h3,
                      addressField(),
                      h2,
                      cityField(),
                      h2,
                      countryField(),
                      h2,
                      dobField(),
                      h3
                    ],
                  ),
                ),
                bottomNavigationBar: AppButton(
                  buttonTitle: 'continue',
                  textSize: 10.sp,
                  onTap: () {
                    onContinueTap(authVm, baseVm);
                    // AppUser.user?.form1?.address = addressController.text;
                    // AppUser.user?.form1?.city = cityController.text;
                    // AppUser.user?.form1?.country = countryController.text;
                    // AppUser.user?.form1?.dob = dobC.text;
                    // authVm.completeProfilePageIndex =
                    //     authVm.completeProfilePageIndex + 1;
                    // authVm.update();
                    // authVm.completeProfilePageController
                    //     .jumpToPage(authVm.completeProfilePageIndex);
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

  Future<void> onContinueTap(AuthVm authVm, BaseVm baseVm) async {
    ZBotToast.loadingShow();
    String url = AppUser.profileForms.step1?.pictureUrl ?? "";
    if (imageFile != null) {
      url = await authVm.uploadImageUrl(imageFile);
    }
    Map body = {
      "pictureUrl": url,
      "address": addressController.text.trim(),
      "city": cityController.text.trim(),
      "country": countryController.text.trim(),
      "birthDate": selectedDate == null
          ? ""
          : DateFormat("MM/dd/yyyy").format(selectedDate!)
    };
    bool success = await authVm.form1(body: body);
    if (success) {
      AppUser.profileForms.step1 = Step1.fromJson(body);
      authVm.completeProfilePageIndex = authVm.completeProfilePageIndex + 1;
      authVm.update();
      authVm.completeProfilePageController
          .jumpToPage(authVm.completeProfilePageIndex);
      ZBotToast.loadingClose();
    }
  }

  Widget addressField() {
    return TextFormField(
      controller: addressController,
      focusNode: addressFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.location],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
      maxLength: 100,
      decoration: R.decoration.fieldDecoration(
        hintText: "address",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(cityFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget cityField() {
    return TextFormField(
      controller: cityController,
      focusNode: cityFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.addressCity],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
      maxLength: 100,
      decoration: R.decoration.fieldDecoration(
        hintText: "city",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(countryFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget countryField() {
    return TextFormField(
      controller: countryController,
      focusNode: countryFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.countryName],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
      maxLength: 100,
      decoration: R.decoration.fieldDecoration(
        hintText: "country",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(dobFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget dobField() {
    return TextFormField(
      readOnly: true,
      controller: dobC,
      focusNode: dobFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateEmptyField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "date_of_birth",
      ),
      onTap: () async {
        selectedDate = await Get.dialog(CustomDatePickerDialog(
          initialDate: selectedDate,
        ));
        if (selectedDate != null) {
          setState(() {
            dobC.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
          });
        }
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
