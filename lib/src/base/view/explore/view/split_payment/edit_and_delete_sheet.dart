import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../utils/app_button.dart';

class EditAndDeleteSheet extends StatefulWidget {
  final VoidCallback onEditTab;
  final VoidCallback onDeleteTab;

  const EditAndDeleteSheet(
      {super.key, required this.onDeleteTab, required this.onEditTab});

  @override
  State<EditAndDeleteSheet> createState() => _EditAndDeleteSheetState();
}

class _EditAndDeleteSheetState extends State<EditAndDeleteSheet> {
  final _formKey = GlobalKey<FormState>();

  List<String> title = ["edit", "delete"];

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
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        onTap: () {
                          if (index == 0) {
                            widget.onEditTab();
                          } else {
                            widget.onDeleteTab();
                          }
                        },
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          title[index].L(),
                          textAlign: TextAlign.start,
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: R.colors.black,
                          size: 16,
                        ),
                      );
                    },
                    itemCount: title.length,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    buttonTitle: 'close',
                    textSize: 10.sp,
                    onTap: () {
                      Get.back();
                    },
                    fontWeight: FontWeight.w500,
                    textColor: R.colors.white,
                    color: R.colors.black,
                    borderRadius: 25,
                    borderColor: R.colors.black,
                    buttonWidth: 40.w,
                    textPadding: 0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
