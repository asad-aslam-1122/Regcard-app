import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/account/view/add_documents_view.dart';
import 'package:regcard/src/base/view/account/view/documents_view.dart';
import 'package:regcard/src/base/view/account/view/family_member.dart';
import 'package:regcard/src/base/view/explore/view/widgets/more_sheet.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';
import '../../../../../constant/enums.dart';
import '../../../../../resources/localization/app_localization.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/custom_file_picker/image_slider.dart';
import '../../../../../services/custom_file_picker/pdf_view_widget.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../auth/model/new_document_model.dart';
import '../../../../auth/view/complete_profile/widgets/upload_doc_sheet.dart';

class MyRegcardDocumentView extends StatefulWidget {
  static String route = '/my_regcard_document_view';

  const MyRegcardDocumentView({super.key});

  @override
  State<MyRegcardDocumentView> createState() => _MyRegcardDocumentViewState();
}

class _MyRegcardDocumentViewState extends State<MyRegcardDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Scaffold(
              backgroundColor: R.colors.white,
              appBar: titleAppBar(
                title: 'my_regcard_documents',
                titleCenter: true,
                icon: Icons.arrow_back_ios_sharp,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: Column(
                  mainAxisAlignment: authVm.allDocList.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    h3,
                    authVm.allDocList.isEmpty    ? emptyScreen()
                        : addDocument(),
                    h3,
                    if (authVm.allDocList.where((e) => e.documentType == DocumentType.myDocuments).toList().isNotEmpty)
                      InkWell(
                        onTap: () {
                          authVm.docViewsList = authVm.allDocList.where((e) => e.documentType == DocumentType.myDocuments).toList();
                          Get.toNamed(DocumentsView.route, arguments: {
                            'docType': DocumentType.myDocuments,
                            'title' : 'my_documents'.L(),
                            'documents': authVm.allDocList.where((e) => e.documentType == DocumentType.myDocuments).toList(),
                          });
                        },
                        child: tile('my_documents'),
                      ),
                    if (authVm.allDocList.where((e) => e.documentType == DocumentType.familyDocuments).toList().isNotEmpty)
                      InkWell(
                        onTap: () {
                          authVm.familyDocsList = authVm.allDocList.where((e) => e.documentType == DocumentType.familyDocuments).toList();
                          Get.toNamed(FamilyMemberView.route, arguments: {
                            'docType': DocumentType.familyDocuments,
                            'title' : 'family_documents'.L(),
                            'documents': authVm.allDocList.where((e) => e.documentType == DocumentType.familyDocuments).toList(),
                          });
                        },
                        child: tile('family_documents'),
                      ),
                    if (authVm.allDocList.where((e) => e.documentType == DocumentType.additionalDocuments).toList().isNotEmpty)
                      InkWell(
                        onTap: () {
                          authVm.docViewsList = authVm.allDocList.where((e) => e.documentType == DocumentType.additionalDocuments).toList();
                          Get.toNamed(DocumentsView.route, arguments: {
                            'docType': DocumentType.additionalDocuments,
                            'title' : 'additional_documents'.L(),
                            'documents': authVm.allDocList.where((e) => e.documentType == DocumentType.additionalDocuments).toList(),
                          });
                        },
                        child: tile('additional_documents'),
                      ),

                  ],
                ),
              ),
            ));
  }

  Widget tile(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: R.colors.greyBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              title.L(),
              style: R.textStyles.inter(fontSize: 10.sp)),
          Icon(Icons.arrow_forward_ios_rounded, color: R.colors.black, size: 15)
        ],
      ),
    );
  }

  Widget addDocument() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'add_documents'.L(),
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w600, fontSize: 11.sp),
            ),
            Text(
              'you_can_add_your_documents_any_time'.L(),
              style: R.textStyles
                  .inter(fontWeight: FontWeight.w400, fontSize: 6.sp),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.toNamed(AddDocumentsView.route);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: R.colors.primaryColor),
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add,
              color: R.colors.white,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget emptyScreen() {
    return Center(
      child: Column(
        children: [
          Text(
            'my_regcard_documents'.L(),
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600),
          ),
          h1,
          Text(
            'my_regcard_doc_desc'.L(),
            textAlign: TextAlign.center,
            style: R.textStyles.inter(
                color: R.colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w300),
          ),
          h5,
          AppButton(
            buttonTitle: 'add_document',
            textSize: 9.sp,
            onTap: () {
              Get.toNamed(AddDocumentsView.route);
            },
            fontWeight: FontWeight.w500,
            textColor: R.colors.black,
            color: R.colors.textFieldFillColor,
            borderRadius: 25,
            borderColor: R.colors.black,
            horizentalPadding: 13.w,
            textPadding: 1.5.h,
          ),
        ],
      ),
    );
  }

}
