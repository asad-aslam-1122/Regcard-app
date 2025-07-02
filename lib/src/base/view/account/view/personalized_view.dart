import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/account/model/personalized_model.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../resources/resources.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/background_container.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../auth/model/personalizationOptions.dart';
import '../../../../auth/view_model/auth_vm.dart';
import '../../../view_model/base_vm.dart';

class PersonalizedView extends StatefulWidget {
  static String route = '/personalized_view';

  const PersonalizedView({super.key});

  @override
  State<PersonalizedView> createState() => _PersonalizedViewState();
}

class _PersonalizedViewState extends State<PersonalizedView> {
  TextEditingController tempController = TextEditingController();
  TextEditingController pescatarianController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController gastronomyController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  List<PersonalizationOptions> selectedFood = [];
  List<PersonalizationOptions> selectedGastronomy = [];
  List<PersonalizationOptions> selectedRestaurants = [];
  List<PersonalizationOptions> selectedActivities = [];

  @override
  void initState() {
    ZBotToast.loadingShow();
    var baseVm = Provider.of<BaseVm>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await baseVm.getPersonalized();
      PersonalizedModel p = baseVm.personalizedModel;
      tempController.text = p.roomTemperature ?? '';
      pescatarianController.text = p.pescatarianPreference ?? '';
      selectedFood = p.foodPersonalities ?? [];
      gastronomyController.text = p.otherGastronomy ?? '';
      selectedGastronomy = p.gastronomyTypes ?? [];
      selectedRestaurants = p.restaurantTypes ?? [];
      selectedActivities = p.activityTypes ?? [];
      activityController.text = p.otherActivity ?? '';
      ZBotToast.loadingClose();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BaseVm, AuthVm>(
        builder: (context, baseVm, authVm, child) => SafeAreaWidget(
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
                                    Text("personalized".L(),
                                        style: R.textStyles.inter(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        "what_is_the_ideal_temperature_for_your_room?"
                                            .L(),
                                        style: R.textStyles.inter(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500)),
                                    h1,
                                    tempField(),
                                    h2,
                                    ...categoriesList(
                                        authVm.personalizationType0,
                                        selectedFood),
                                    h1P5,
                                    Text("pescatarian".L(),
                                        style: R.textStyles
                                            .inter(fontSize: 11.sp)),
                                    h1,
                                    pescatarianField(),
                                    h1,
                                    Text(
                                        "what_types_of_gastronomy_do_you_like?"
                                            .L(),
                                        style: R.textStyles.inter(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500)),
                                    h1P5,
                                    ...categoriesList(
                                        authVm.personalizationType1,
                                        selectedGastronomy),
                                    h1P5,
                                    gastronomyTextField(),
                                    h1,
                                    Text(
                                        "what_types_of_resturants_do_you_prefer?"
                                            .L(),
                                        style: R.textStyles.inter(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500)),
                                    h1P5,
                                    restaurantTextField(),
                                    h1,
                                    ...categoriesList(
                                        authVm.personalizationType2,
                                        selectedRestaurants),
                                    h2,
                                    Text(
                                        "what_type_of_activity_will_the_hotelier_be_able_to_advise"
                                            .L(),
                                        style: R.textStyles.inter(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500)),
                                    h1P5,
                                    ...categoriesList(
                                        authVm.personalizationType3,
                                        selectedActivities),
                                    h1P5,
                                    activityField(),
                                    h2
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
      "roomTemperature": tempController.text.trim(),
      "pescatarianPreference": pescatarianController.text.trim(),
      "foodPersonalityIds": selectedFood.map((e) => e.id).toList(),
      "otherGastronomy": gastronomyController.text.trim(),
      "gastronomyTypeIds": selectedGastronomy.map((e) => e.id).toList(),
      "restaurantTypeIds": selectedRestaurants.map((e) => e.id).toList(),
      "activityTypeIds": selectedActivities.map((e) => e.id).toList(),
      "otherActivity": activityController.text.trim()
    };

    bool check = await baseVm.updatePersonalized(body: body);
    if (check) {
      Get.back();
      ZBotToast.showToastSuccess(
          message: 'personalized_updated_successfully'.L());
    }
  }

  Widget tempField() {
    return TextFormField(
      controller: tempController,
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

  Widget pescatarianField() {
    return TextFormField(
      controller: pescatarianController,
      // focusNode: emailFN,
      maxLength: 32,
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

  Widget gastronomyTextField() {
    return TextFormField(
      controller: gastronomyController,
      // focusNode: emailFN,
      maxLength: 32,
      textCapitalization: TextCapitalization.none,
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

  Widget restaurantTextField() {
    return TextFormField(
      controller: restaurantController,
      // focusNode: emailFN,
      maxLength: 32,
      textCapitalization: TextCapitalization.none,
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

  Widget activityField() {
    return TextFormField(
      controller: activityController,
      // focusNode: emailFN,
      maxLength: 32,
      textCapitalization: TextCapitalization.none,
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
