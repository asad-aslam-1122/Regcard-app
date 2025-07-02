import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../constant/enums.dart';
import '../../../../../../resources/resources.dart';
import '../../../../../../services/custom_file_picker/file_picker_widget.dart';
import '../../../../../../services/custom_file_picker/image_view.dart';
import '../../../../../../services/date_picker/date_picker.dart';
import '../../../../../../utils/app_button.dart';
import '../../../../../../utils/display_image.dart';
import '../../../../../../utils/field_validations.dart';
import '../../../../../../utils/heights_widths.dart';
import '../../../../../../utils/image_preview.dart';
import '../../../../../../utils/widgets/global_widgets.dart';
import '../../view_model/expense_vm.dart';
import 'add_members_view.dart';
import 'edit_and_delete_sheet.dart';

class AddExpanseForm1 extends StatefulWidget {
  const AddExpanseForm1({super.key});

  @override
  State<AddExpanseForm1> createState() => _AddExpanseForm1State();
}

class _AddExpanseForm1State extends State<AddExpanseForm1> {
  FocusNode titleFN = FocusNode();

  FocusNode amountFN = FocusNode();

  FocusNode dateFN = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseVm>(
      builder: (context, expenseVm, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlobalWidgets.labelText(title: "title"),
                        h0P8,
                        titleField(expenseVm),
                        h1P5,
                        GlobalWidgets.labelText(title: "amount"),
                        h0P8,
                        amountField(expenseVm),
                        h1P5,
                        GlobalWidgets.labelText(title: "choose_date"),
                        h0P8,
                        datePickerField(expenseVm),
                        h1P5,
                        MembersField(expenseVm: expenseVm),
                        h1P5,
                        uploadImage(expenseVm),
                        if (expenseVm.selectedPicture != null) ...[
                          Column(
                            children: [
                              InkWell(
                                  onTap: () async {
                                    String? fileType = expenseVm
                                        .selectedPicture?.path
                                        .split('.')
                                        .last
                                        .toString();
                                    if (fileType != null) {
                                      (fileType == FileTypeEnum.jpg.name ||
                                              fileType ==
                                                  FileTypeEnum.jpeg.name ||
                                              fileType == FileTypeEnum.png.name)
                                          ? Get.to(() => ImageViewScreen(
                                              imageProvider: FileImage(
                                                  expenseVm.selectedPicture!)))
                                          : await OpenFilex.open(
                                              expenseVm.selectedPicture!.path);
                                    }
                                  },
                                  child: Container(
                                    width: 20.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              expenseVm.selectedPicture!),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                        EditAndDeleteSheet(
                                          onDeleteTab: () {
                                            Get.back();
                                            expenseVm.selectedPicture = null;
                                            setState(() {});
                                          },
                                          onEditTab: () async {
                                            Get.back();
                                            await Get.to(ImageView(
                                              path: expenseVm.selectedPicture!,
                                            ));
                                          },
                                        ),
                                        isScrollControlled: true);
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      width: 20.w,
                                      color: R.colors.transparent,
                                      child: Icon(Icons.more_horiz)))
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: AppButton(
                      buttonTitle: "next",
                      textSize: 10.sp,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (expenseVm.addedMembersList.isEmpty) {
                            ZBotToast.showToastError(
                                message: "Add members to split payment");
                          } else {
                            expenseVm.selectedExpenseIndex++;
                            if (expenseVm.selectedSplit != null) {
                              expenseVm
                                  .onMethodSelected(expenseVm.selectedMethod!);
                              expenseVm
                                  .onSplitSelected(expenseVm.selectedSplit!);
                            }
                            expenseVm.update();
                          }
                          // if (expenseVm.selectedPicture != null) {
                          //   String url = await context
                          //       .read<AuthVm>()
                          //       .uploadImageUrl(expenseVm.selectedPicture);
                          //   final details = await expenseVm.selectedPicture!.getFileDetails();
                          //   expenseVm.splitPaymentItems.mediaFiles = [
                          //     MediaFiles(
                          //         fileName: details['name'],
                          //         fileExtension: details['extension'],
                          //         fileSize: details['size'],
                          //         fileType: MessageTypeEnum.image.index,
                          //         fileUrl: url)
                          //   ];
                          // }
                        }
                      },
                      fontWeight: FontWeight.w500,
                      textColor: R.colors.white,
                      color: (expenseVm.titleTC.text.isEmpty ||
                              expenseVm.amountTC.text.isEmpty ||
                              expenseVm.dateTC.text.isEmpty ||
                              expenseVm.addedMembersList.isEmpty)
                          ? R.colors.black.withValues(alpha: .3)
                          : R.colors.black,
                      borderRadius: 25,
                      buttonWidth: 40.w,
                      textPadding: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget uploadImage(ExpenseVm expenseVm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 13.w,
          child: FilePickerWidget(
            showDocument: false,
            list: expenseVm.selectedPicture == null
                ? []
                : [expenseVm.selectedPicture!],
            isDocUpload: true,
            onSelect: (list) {
              FocusManager.instance.primaryFocus?.unfocus();
              expenseVm.selectedPicture = list.last;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'add_picture_optional'.L(),
                style: R.textStyles.inter(
                    color: R.colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'add_picture_optional_des'.L(),
                style: R.textStyles.inter(
                    color: R.colors.black,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        )
      ],
    );
  }

  TextFormField titleField(ExpenseVm expenseVm) {
    return TextFormField(
      controller: expenseVm.titleTC,
      focusNode: titleFN,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateTitle,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      decoration: R.decoration.fieldDecoration(
        hintText: "enter_title",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(amountFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  TextFormField amountField(ExpenseVm expenseVm) {
    return TextFormField(
      controller: expenseVm.amountTC,
      focusNode: amountFN,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateAmount,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: R.decoration.fieldDecoration(
        hintText: "enter_amount",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(dateFN);
        setState(() {});
      },
      onFieldSubmitted: (value) {
        setState(() {});
      },
    );
  }

  TextFormField datePickerField(ExpenseVm expenseVm) {
    return TextFormField(
      readOnly: true,
      controller: expenseVm.dateTC,
      focusNode: dateFN,
      textCapitalization: TextCapitalization.none,
      autofillHints: const [AutofillHints.email],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: FieldValidator.validateChooseDate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "choose_date",
      ),
      onTap: () async {
        expenseVm.selectedDate = await Get.dialog(CustomDatePickerDialog());
        expenseVm.dateTC.text =
            DateFormat("dd/MM/yyyy").format(expenseVm.selectedDate);
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

  Widget MembersField({required ExpenseVm expenseVm}) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
      width: double.infinity,
      decoration: R.decoration.boxDecoration(
          radius: 6,
          useBorder: true,
          giveShadow: true,
          backgroundColor: R.colors.textFieldFillColor.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AddMembersView.route);
            },
            child: Container(
              color: R.colors.transparent,
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        R.images.membersGroup,
                        height: 16,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("add_members".L(),
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w500, fontSize: 10.sp))
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
          if (expenseVm.addedMembersList.isNotEmpty) ...[
            Divider(
              color: R.colors.white,
            ),
            Stack(
              children: [
                for (double index = 0;
                    index <
                        ((expenseVm.addedMembersList.length) > 4
                            ? 4
                            : (expenseVm.addedMembersList.length));
                    index++) ...[
                  Container(
                    height: 37,
                    width: 37,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.only(left: (22 * index)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: R.colors.white,
                        border: Border.all(
                            color: R.colors.primaryColor, width: 1.5)),
                    child: index != 3
                        ? DisplayImage(
                            imageUrl: expenseVm
                                    .addedMembersList[
                                        double.parse(index.toString()).toInt()]
                                    .pictureUrl ??
                                "",
                            borderColor: R.colors.lightGreyColor,
                            isCircle: true,
                            hasMargin: false,
                          )
                        : Center(
                            child: Text(
                            "+${(expenseVm.addedMembersList.length) - 3}",
                            style: R.textStyles.inter(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          )),
                  )
                ]
              ],
            ),
          ],
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
