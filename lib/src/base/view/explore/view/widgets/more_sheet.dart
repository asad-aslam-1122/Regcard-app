import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/src/auth/view/complete_profile/widgets/upload_doc_sheet.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/app_button.dart';
import '../../../../../../utils/heights_widths.dart';

class MoreOptionSheet extends StatefulWidget {
  final int? id;
  final bool? isRecords;
  final DocumentType? docType;
  final String? familyMemberName;
  final String? documentUrl;
  final String? documentName;
  final bool? fromTempList;
  final int? tempListIndex;
  const MoreOptionSheet(
      {super.key,
      this.id,
      this.isRecords = false,
      this.docType,
      this.familyMemberName,
      this.documentUrl,
      this.documentName,
      this.fromTempList = false,
      this.tempListIndex});

  @override
  State<MoreOptionSheet> createState() => _MoreOptionSheetState();
}

class _MoreOptionSheetState extends State<MoreOptionSheet> {
  FocusNode aboutFN = FocusNode();
  TextEditingController aboutC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(
        builder: (context, authVm, baseVm, child) => SafeAreaWidget(
              child: Container(
                // height: (widget.showFirstButton  ?? false) || (widget.showSecondButton ?? false)  ? 28.h : 22.h ,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: R.colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                    ) +
                    EdgeInsets.only(top: 4.h, bottom: 1.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    tileWidget('edit_record', () async {
                      if (widget.fromTempList == true) {
                        Get.back();
                        Get.bottomSheet(UploadDocumentSheet(
                          isDocTypeSelected: true,
                          isForUpdateTemp: true,
                          tempDocIndex: widget.tempListIndex,
                        ));
                      } else {
                        Get.back();
                        await Get.bottomSheet(UploadDocumentSheet(
                          isDocTypeSelected: true,
                          isForUpdate: true,
                          isRecordsDoc: widget.isRecords ?? false,
                          docType: widget.docType,
                          familyMemberName: widget.familyMemberName,
                          documentUrl: widget.documentUrl,
                          documentID: widget.id,
                          documentName: widget.documentName,
                        ));
                      }
                    }),
                    tileWidget('delete_record', () async {
                      if (widget.fromTempList == true) {
                        authVm.tempDocList.removeAt(widget.tempListIndex ?? 0);
                        authVm.update();
                        Get.back();
                      } else if (widget.isRecords == true) {
                        Get.back();
                        ZBotToast.loadingShow();
                        await baseVm.deleteRecord(id: widget.id ?? 0);
                        baseVm.getRecords();
                        ZBotToast.showToastSuccess(
                            message:
                                'record_has_been_deleted_successfully'.L());
                        ZBotToast.loadingClose();
                      } else {
                        ZBotToast.loadingShow();
                        await authVm.deleteDocument(id: widget.id ?? 0);
                        ZBotToast.showToastSuccess(
                            message:
                                'document_has_been_deleted_successfully'.L());
                        ZBotToast.loadingClose();
                        Get.back();
                      }
                    }),
                    h1,
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
                      //horizentalPadding: 18.w,
                      textPadding: 0,
                      buttonWidth: 40.w,
                    )
                  ],
                ),
              ),
            ));
  }

  Widget tileWidget(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        color: R.colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.L(),
              style: R.textStyles.inter(
                  color: R.colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp),
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: R.colors.black,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
