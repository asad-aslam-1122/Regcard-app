import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../resources/localization/app_localization.dart';
import '../../resources/resources.dart';
import '../../utils/app_button.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final bool? isSimple;
  const CustomDatePickerDialog({super.key, this.initialDate, this.isSimple});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? selectedDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        selectedDate = widget.initialDate ?? DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: R.colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationMap.getTranslatedValues('select_date')
                          .toUpperCase(),
                      style: R.textStyles.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: R.colors.black),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.comfortable,
                      onPressed: () {
                        Get.back(result: widget.initialDate);
                      },
                      icon: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: R.colors.black,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: R.textStyles.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: R.colors.black,
                  ))),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: widget.initialDate ?? DateTime.now(),
                    minimumYear: 1950,
                    maximumYear: DateTime.now().year,
                    use24hFormat: false,
                    dateOrder: DatePickerDateOrder.dmy,
                    backgroundColor: CupertinoColors.white,
                    onDateTimeChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  width: Get.width,
                  height: 50,
                  child: AppButton(
                      textColor: R.colors.white,
                      buttonTitle: 'save',
                      onTap: () {
                        Get.back(result: selectedDate);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
