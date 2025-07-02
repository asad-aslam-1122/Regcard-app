import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/resources.dart';

class DropdownWidget extends StatefulWidget {
  final String? selectedValue;
  final String hintText;
  final bool isDisable;
  final List list;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;

  const DropdownWidget(
      {super.key,
      required this.selectedValue,
      required this.hintText,
      required this.onChanged,
      required this.list,
      this.isDisable = false,
      required this.validator});

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  String? selectedValue;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedValue = widget.selectedValue;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        isExpanded: true,
        iconStyleData: IconStyleData(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: R.colors.black,
                size: 24,
              ),
            ),
            openMenuIcon: Transform.flip(
              flipY: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: R.colors.black,
                  size: 24,
                ),
              ),
            )),
        style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          offset: const Offset(0, -6),
          decoration: BoxDecoration(
              color: R.colors.white,
              border: Border.all(
                color: R.colors.transparent,
              ),
              borderRadius: BorderRadius.circular(8)),
        ),
        hint: Text(
          widget.hintText.L(),
          overflow: TextOverflow.ellipsis,
          style: R.textStyles.inter(
            fontWeight: FontWeight.w300,
            color: R.colors.black,
            fontSize: 10.sp,
          ),
        ),
        validator: widget.validator,
        items: widget.list
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: R.textStyles.inter(
                      fontSize: 9.sp,
                      color: R.colors.black,
                    ),
                  ),
                ))
            .toList(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: selectedValue,
        onChanged: widget.isDisable == true ? null : widget.onChanged,
        menuItemStyleData: const MenuItemStyleData(
          height: 30,
        ),
        isDense: true,
        decoration: R.decoration
            .dropDownDecoration(horizontalPadding: -2, verticalPadding: 10),
      ),
    );
  }
}
