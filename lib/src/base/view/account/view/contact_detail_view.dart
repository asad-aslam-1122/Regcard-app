import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/auth/model/user_profile.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/background_container.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/keyboard_config.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/app_user.dart';
import '../../../../../services/date_picker/date_picker.dart';

class ContactDetailsView extends StatefulWidget {
  static String route = "/ContactDetailsView";

  const ContactDetailsView({super.key});

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  FocusNode addressFN = FocusNode();
  TextEditingController cityController = TextEditingController();
  FocusNode cityFN = FocusNode();
  TextEditingController countryController = TextEditingController();
  FocusNode countryFN = FocusNode();
  TextEditingController dobC = TextEditingController();
  FocusNode dobFN = FocusNode();
  FocusNode firstNameFN = FocusNode();
  FocusNode lastNameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode phoneFN = FocusNode();

  // PhoneNumber number = PhoneNumber();
  TextEditingController companyController = TextEditingController();
  FocusNode companyFN = FocusNode();
  TextEditingController workPositionController = TextEditingController();
  FocusNode workPositionFN = FocusNode();
  List<String> title = ["Mr", "Mrs", "Miss"];
  // selected Title
  String? selectedTitle;

  @override
  void initState() {
    ZBotToast.loadingShow();

    // setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 300));
      UserProfile? p = AppUser.userProfile;
      log(jsonEncode(p));
      selectedTitle = p?.title ?? title.first;
      firstNameController.text = p?.firstName ?? "";
      lastNameController.text = p?.lastName ?? "";
      emailController.text = p?.email ?? "";
      // number = await PhoneNumber.getRegionInfoFromPhoneNumber(
      //   p?.phoneNumber ?? '',
      // );
      // number = PhoneNumber(
      //     isoCode: number.isoCode,
      //     dialCode: number.dialCode,
      //     phoneNumber: number.phoneNumber);
      setState(() {});
      addressController.text = p?.address ?? "";
      cityController.text = p?.city ?? "";
      countryController.text = p?.country ?? "";
      if ((p?.birthDate ?? "").isNotEmpty || p?.birthDate != null) {
        selectedDate = DateTime.parse(p?.birthDate ?? "");
        dobC.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
      }
      workPositionController.text = p?.workPosition ?? "";
      companyController.text = p?.company ?? "";
      setState(() {});
      ZBotToast.loadingClose();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(
        builder: (context, baseVm, child) => SafeAreaWidget(
              backgroundColor: R.colors.greyBackgroundColor,
              child: Scaffold(
                backgroundColor: R.colors.white,
                body: Stack(
                  children: [
                    const Column(
                      children: [
                        BackgroundContainer(
                            showBackButton: true, showLanguageButton: false)
                      ],
                    ),
                    Container(
                      width: Get.width,
                      height: Get.height,
                      margin: EdgeInsets.only(top: 15.h, left: 5.w, right: 5.w),
                      decoration: BoxDecoration(
                          color: R.colors.greyBackgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Column(
                                children: [
                                  h3,
                                  Image.asset(
                                    R.images.appLogo,
                                    scale: 3,
                                  ),
                                  h4,
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField2(
                                            isExpanded: true,
                                            iconStyleData: IconStyleData(
                                                icon: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_sharp,
                                                    color: R.colors.black,
                                                    size: 24,
                                                  ),
                                                ),
                                                openMenuIcon: Transform.flip(
                                                  flipY: true,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_sharp,
                                                      color: R.colors.black,
                                                      size: 24,
                                                    ),
                                                  ),
                                                )),
                                            style: R.textStyles.inter(
                                                color: R.colors.black,
                                                fontSize: 10.sp),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              elevation: 1,
                                              offset: const Offset(0, -6),
                                              decoration: BoxDecoration(
                                                  color: R.colors.white,
                                                  border: Border.all(
                                                    color: R.colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            hint: Text(
                                              "title".L(),
                                              overflow: TextOverflow.ellipsis,
                                              style: R.textStyles.inter(
                                                fontWeight: FontWeight.w300,
                                                color: R.colors.black,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                            validator: FieldValidator
                                                .validateTitleDropdown,
                                            items: title
                                                .map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            R.textStyles.inter(
                                                          fontSize: 9.sp,
                                                          color: R.colors.black,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            value: selectedTitle,
                                            onChanged: (updatedValue) {
                                              selectedTitle = updatedValue;
                                              setState(() {});
                                            },
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 30,
                                            ),
                                            isDense: true,
                                            decoration: R.decoration
                                                .dropDownDecoration(
                                                    horizontalPadding: -2,
                                                    verticalPadding: 10),
                                          ),
                                        ),
                                        h1P5,
                                        firstNameField(),
                                        h1P5,
                                        lastNameField(),
                                        h1P5,
                                        emailField(),
                                        h1P5,
                                        phoneNumber(),
                                      ],
                                    ),
                                  ),
                                  h1P5,
                                  addressField(),
                                  h1P5,
                                  cityField(),
                                  h1P5,
                                  countryField(),
                                  h1P5,
                                  dobField(),
                                  h1P5,
                                  companyField(),
                                  h1P5,
                                  workPositionField(),
                                ],
                              ),
                            ),
                          ),
                          h1,
                          AppButton(
                            buttonTitle: 'update',
                            textSize: 10.sp,
                            onTap: () {
                              onContinueTap(baseVm);
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
                          h1
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> onContinueTap(BaseVm baseVm) async {
    if (_formKey.currentState!.validate()) {
      ZBotToast.loadingShow();

      Map contactDetailBody = {
        "title": selectedTitle,
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "phoneNumber": "",
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "country": countryController.text.trim(),
        "birthDate": selectedDate == null
            ? ""
            : DateFormat("MM/dd/yyyy").format(selectedDate!),
        "workPosition": workPositionController.text.trim(),
        "company": companyController.text.trim(),
      };

      bool check = await baseVm.contactDetails(body: contactDetailBody);
      if (check) {
        await baseVm.getProfile();
        Get.forceAppUpdate();
        Get.back();
        ZBotToast.showToastSuccess(
            message: 'your_contact_details_is_updated_successfully'.L());
      }
    }
  }

  Widget firstNameField() {
    return TextFormField(
      controller: firstNameController,
      focusNode: firstNameFN,
      maxLength: 64,
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateFirstName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "first_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(lastNameFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      controller: lastNameController,
      focusNode: lastNameFN,
      maxLength: 64,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateLastName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "last_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(phoneFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      enabled: false,
      controller: emailController,
      focusNode: emailFN,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "email",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(phoneFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  Widget phoneNumber() {
    return KeyboardActions(
      config:
          buildConfigDone(context, phoneFN, nextFocus: addressFN, isDone: true),
      disableScroll: true,
      autoScroll: false,
      // child: InternationalPhoneNumberInput(
      //   // spaceBetweenSelectorAndTextField: 1,
      //   focusNode: phoneFN,
      //   selectorTextStyle:
      //       R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      //   textStyle: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      //   keyboardAction: TextInputAction.next,
      //   inputDecoration: R.decoration.fieldDecoration(
      //     hintText: 'phone_number',
      //     focusNode: phoneFN,
      //     // suffixIcon: const Icon(
      //     //   Icons.phone,
      //     // ),
      //   ),
      //   onInputChanged: (PhoneNumber phoneNumber) {
      //     if ((phoneNumber.phoneNumber?.length ?? 0) < 1) {
      //       setState(() {});
      //     }
      //     number = phoneNumber;
      //   },
      //   selectorConfig: const SelectorConfig(
      //     leadingPadding: 5,
      //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      //     showFlags: false,
      //     setSelectorButtonAsPrefixIcon: true,
      //     trailingSpace: false,
      //   ),
      //   ignoreBlank: false,
      //   autoValidateMode: AutovalidateMode.onUserInteraction,
      //   initialValue: number,
      //
      //   textFieldController: phoneController,
      //   keyboardType: const TextInputType.numberWithOptions(
      //       signed: false, decimal: false),
      //   inputBorder: const OutlineInputBorder(),
      //   onSaved: (PhoneNumber number) => setState(() {}),
      //   onFieldSubmitted: (s) => setState(() {
      //     FocusScope.of(context).requestFocus(addressFN);
      //     setState(() {});
      //   }),
      //   onInputValidated: (value) {},
      // ),
    );
  }

  Widget addressField() {
    return TextFormField(
      controller: addressController,
      focusNode: addressFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.location],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      maxLength: 100,
      textInputAction: TextInputAction.next,
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
      maxLength: 100,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.addressCity],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
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
      maxLength: 100,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.countryName],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.next,
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
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
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

  Widget workPositionField() {
    return TextFormField(
      controller: workPositionController,
      focusNode: workPositionFN,
      maxLength: 64,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      decoration: R.decoration.fieldDecoration(
        hintText: "work_position",
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

  Widget companyField() {
    return TextFormField(
      controller: companyController,
      focusNode: companyFN,
      maxLength: 64,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: R.decoration.fieldDecoration(
        hintText: "company_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(workPositionFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }
}
