import 'package:flutter/material.dart';
import 'package:regcard/resources/localization/app_localization.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../src/base/model/DropDownModel.dart';

Widget dropDownMenu(
    {required FocusNode focusNode,
    required String hintText,
    required ValueChanged previousSelectedCategory,
    required DropDownModel? selectedCategory,
    required List<DropDownModel> listOfCategory,
    Color? fillColor}) {
  return StatefulBuilder(builder: (context, setState) {
    return DropdownButtonFormField(
      focusNode: focusNode,
      value: selectedCategory,
      onTap: () {
        setState(() {});
      },
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: R.colors.black,
        size: 25,
      ),
      borderRadius: BorderRadius.circular(10),
      hint: Text(
        hintText.L(),
        style: R.textStyles.inter(
          fontWeight: FontWeight.w300,
          color: R.colors.black,
          fontSize: 10.sp,
        ),
      ),
      decoration: R.decoration.dropDownDecoration(
        fillColor: fillColor ?? R.colors.textFieldFillColor,
        verticalPadding: 10,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (selectedCategory == null) {
          return "select_document_type".L();
        }
        return null;
      },
      onChanged: (DropDownModel? newValue) {
        selectedCategory = newValue;
        setState(() {});
        // if (selectedCategory != null) {}
        previousSelectedCategory(selectedCategory);
        setState(() {});
      },
      items: List.generate(
          listOfCategory.length,
          (index) => DropdownMenuItem(
                value: listOfCategory[index],
                child: Text(
                  LocalizationMap.getTranslatedValues(
                          listOfCategory[index].text!) ??
                      '',
                  style: R.textStyles.inter(
                    fontSize: 9.sp,
                    color: R.colors.black,
                  ),
                ),
              )),
    );
  });
}
