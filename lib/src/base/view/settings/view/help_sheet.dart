import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/app_button.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

class HelpSheet extends StatefulWidget {
  const HelpSheet({super.key});

  @override
  State<HelpSheet> createState() => _HelpSheetState();
}

class _HelpSheetState extends State<HelpSheet> {
  TextEditingController helpController = TextEditingController();
  FocusNode helpFN = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseVm>(builder: (context, baseVm, _) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(
              horizontal: 7.w,
            ) +
            EdgeInsets.only(top: 2.5.h),
        child: SingleChildScrollView(
          child: SafeAreaWidget(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "help".L(),
                    textAlign: TextAlign.center,
                    style: R.textStyles.inter(
                        color: R.colors.black,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  h1,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "help_statement".L(),
                      textAlign: TextAlign.center,
                      style: R.textStyles.inter(
                          color: R.colors.black.withOpacity(0.7),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  h2,
                  helpField(),
                  h3,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton(
                          buttonTitle: "cancel",
                          textSize: 10.sp,
                          onTap: () {
                            Get.back();
                          },
                          fontWeight: FontWeight.w500,
                          textColor: R.colors.white,
                          color: R.colors.black,
                          borderRadius: 25,
                          borderColor: R.colors.black,
                          textPadding: 0,
                        ),
                      ),
                      w2,
                      Expanded(
                        child: AppButton(
                          buttonTitle: "submit",
                          textSize: 10.sp,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              ZBotToast.loadingShow();
                              await baseVm.createHelpRequest(
                                  body: {"detail": helpController.text.trim()});
                            }
                          },
                          fontWeight: FontWeight.w500,
                          textColor: R.colors.white,
                          color: R.colors.black,
                          borderRadius: 25,
                          borderColor: R.colors.black,
                          //horizentalPadding: 18.w,
                          textPadding: 0,
                          // buttonWidth: 40.w,
                        ),
                      ),
                    ],
                  ),
                  h1
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget helpField() {
    return TextFormField(
      controller: helpController,
      focusNode: helpFN,
      maxLines: 6,
      maxLength: 262,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      validator: FieldValidator.validateHelpField,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
          hintText: "write_here",
          verticalPadding: 6,
          horizontalPadding: 6,
          showCounter: true),
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
}
