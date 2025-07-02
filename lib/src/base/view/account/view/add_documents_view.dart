import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/field_validations.dart';
import 'package:regcard/utils/image_preview.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/custom_file_picker/pdf_view_widget.dart';
import '../../../../../utils/app_bars.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/drop_down_widget.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../../auth/view/complete_profile/widgets/upload_doc_sheet.dart';
import '../../../../auth/view_model/auth_vm.dart';
import '../../explore/view/widgets/more_sheet.dart';

class AddDocumentsView extends StatefulWidget {
  static String route = "/add_documents_view";
  const AddDocumentsView({super.key});

  @override
  State<AddDocumentsView> createState() => _AddDocumentsViewState();
}

class _AddDocumentsViewState extends State<AddDocumentsView> {
  final _formKey = GlobalKey<FormState>();
  FocusNode docTypeFN = FocusNode();
  FocusNode familyFN = FocusNode();
  String? selectedDocType;
  bool isDocTypeSelected = false;
  DocumentType? docType;
  TextEditingController familyController = TextEditingController();
  List<String> listOfDocType = [
    "My Documents",
    "Family Documents",
    "Additional Documents",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var authVm = Provider.of<AuthVm>(context, listen: false);
      authVm.tempDocList.clear();
      dynamic args = Get.arguments;
      if (args != null) {
        isDocTypeSelected = args['docTypeSelected'];
        docType = args['docType'];
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(
        builder: (context, authVm, baseVm, child) => SafeAreaWidget(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  backgroundColor: R.colors.white,
                  appBar: titleAppBar(
                    title: 'add_document',
                    titleCenter: true,
                    icon: Icons.arrow_back_ios_sharp,
                    // actions: [
                    //   if(authVm.attachmentsList.isNotEmpty) InkWell(
                    //     onTap: () {
                    //       Get.bottomSheet(const UploadDocumentSheet());
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: R.colors.primaryColor
                    //       ),
                    //       padding: const EdgeInsets.all(3),
                    //       margin: const EdgeInsets.only(right: 10),
                    //       child: Icon(
                    //         Icons.add,
                    //         color: R.colors.white,
                    //         size: 23,
                    //       ),
                    //     ),
                    //   ),
                    // ]
                  ),
                  body: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: Column(
                      children: [
                        h3,
                        isDocTypeSelected
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.5.h) +
                                    EdgeInsets.only(bottom: 0.5.h),
                                margin: EdgeInsets.only(bottom: 1.5.h),
                                decoration: BoxDecoration(
                                  color: R.colors.greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [familyField()],
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 1.5.h) +
                                    EdgeInsets.only(bottom: 0.5.h),
                                margin: EdgeInsets.only(bottom: 1.5.h),
                                decoration: BoxDecoration(
                                  color: R.colors.greyBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'select_type'.L(),
                                        style: R.textStyles.inter(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      h1,
                                      DropdownWidget(
                                        validator:
                                            FieldValidator.validateDocDropdown,
                                        onChanged: (updatedValue) {
                                          selectedDocType = updatedValue;
                                          setState(() {});
                                        },
                                        selectedValue: selectedDocType,
                                        list: listOfDocType,
                                        hintText: "select_document_type",
                                      ),
                                      if (selectedDocType ==
                                          listOfDocType[1]) ...{
                                        h1,
                                        familyField()
                                      }
                                    ],
                                  ),
                                ),
                              ),
                        Flexible(child: myDocsWidget(authVm))
                      ],
                    ),
                  ),
                  bottomNavigationBar: AppButton(
                    buttonTitle: 'save',
                    textSize: 10.sp,
                    onTap: () {
                      onSaveTap(authVm, baseVm);
                    },
                    fontWeight: FontWeight.w500,
                    textColor: R.colors.black,
                    color: R.colors.textFieldFillColor,
                    borderRadius: 25,
                    borderColor: R.colors.black,
                    horizentalPadding: 18.w,
                    textPadding: 1.3.h,
                    horizontalMargin: 27.w,
                    verticalMargin: 1.h,
                  ),
                ),
              ),
            ));
  }

  Future<void> onSaveTap(
    AuthVm authVm,
    BaseVm baseVm,
  ) async {
    if (isDocTypeSelected) {
      ZBotToast.loadingShow();
      if (authVm.tempDocList.isEmpty) {
        ZBotToast.showToastError(message: "Please Add any Document");
      } else {
        for (var element in authVm.tempDocList) {
          String url = "";
          url = await authVm.uploadImageUrl(element.document);
          Map body = {
            "documentType": docType?.index,
            "name": element.docName,
            "documentUrl": url,
            "familyMember": familyController.text.isNotEmpty
                ? familyController.text.trim()
                : null
          };
          bool success = await authVm.uploadDocument(body: body);
          if (success == false) {
            return;
          }
        }
        Get.back();
      }
    } else {
      ZBotToast.loadingShow();
      if (selectedDocType == null) {
        ZBotToast.showToastError(message: 'Please select document type.');
      } else if (authVm.tempDocList.isEmpty) {
        ZBotToast.showToastError(message: "Please Add any Document");
      } else {
        for (var element in authVm.tempDocList) {
          String url = "";
          url = await authVm.uploadImageUrl(element.document);
          Map body = {
            "documentType": listOfDocType.indexOf(selectedDocType ?? ""),
            "name": element.docName,
            "documentUrl": url,
            "familyMember": familyController.text.isNotEmpty
                ? familyController.text.trim()
                : null
          };
          bool success = await authVm.uploadDocument(body: body);
          if (success == false) {
            return;
          }
        }
        Get.back();
      }
    }

    // if( selectedDocType?.documentType == DocumentType.myDocuments) {
    //   authVm.docList.addAll(authVm.tempList);
    // }
    // else if (
    // selectedDocType?.documentType == DocumentType.additionalDocuments){
    //   authVm.docList.addAll(authVm.tempList);
    //   // authVm.additionalDocuments.addAll(authVm.tempList);
    // }
    // else
    // {
    //   // if(authVm.familyDocuments.any((element) => element.name == familyController.text)) {
    //   //   int doc = authVm.familyDocuments.indexWhere((element) => element.name == familyController.text);
    //   //   authVm.familyDocuments[doc].docs?.addAll(authVm.tempList);
    //   // }
    //   // else {
    //   //authVm.familyDocuments.add(MemberDocumentModel(name: familyController.text, docs: authVm.tempList));
    // }
    //}
    // authVm.update();
    // authVm.tempList.clear();
    // Get.back();
  }

  Widget myDocsWidget(AuthVm authVm) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: R.colors.greyBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                ) +
                EdgeInsets.only(bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'add_documents'.L(),
                      style: R.textStyles.inter(
                          color: R.colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                    ),
                    h0P5,
                    Text(
                      'add_documents_desc'.L(),
                      style: R.textStyles.inter(
                          color: R.colors.black,
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                AppButton(
                  buttonTitle: 'add',
                  onTap: isDocTypeSelected
                      ? () {
                          if (familyController.text.isEmpty) {
                            ZBotToast.showToastError(
                                message: "Please enter Family Member Name");
                          } else {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Get.bottomSheet(UploadDocumentSheet(
                              isDocTypeSelected: true,
                              docType: docType,
                              isAddToTempList: true,
                            ));
                          }
                        }
                      : () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          (selectedDocType == null ||
                                  (selectedDocType == listOfDocType[1] &&
                                      !_formKey.currentState!.validate()))
                              ? () {}
                              : Get.bottomSheet(UploadDocumentSheet(
                                  isAddToTempList: true,
                                  docType: getDocType(),
                                  isDocTypeSelected: true,
                                ));
                        },
                  borderRadius: 25,
                  color: isDocTypeSelected
                      ? (familyController.text.isEmpty
                          ? R.colors.lightGreyColor
                          : R.colors.black)
                      : ((selectedDocType == null ||
                              (selectedDocType == listOfDocType[1] &&
                                  !_formKey.currentState!.validate()))
                          ? R.colors.lightGreyColor
                          : R.colors.black),
                  textSize: 8.sp,
                  fontWeight: FontWeight.w400,
                  textColor: R.colors.white,
                  buttonWidth: 17.w,
                  buttonHeight: 3.2.h,
                  textPadding: 0,
                )
              ],
            ),
          ),
          documentsView(authVm)
        ],
      ),
    );
  }

  Widget documentsView(AuthVm authVm) {
    return Flexible(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
        shrinkWrap: true,
        children: List.generate(authVm.tempDocList.length, (index) {
          final document = authVm.tempDocList[index];
          final fileType = document.document?.path.split('.').last.toString();
          print("file type : $fileType");
          return Column(
            children: [
              // InkWell(
              //   onTap: () async {
              //       if ( fileType== FileTypeEnum.jpg.name ||
              //           fileType == FileTypeEnum.jpeg.name ||
              //           fileType == FileTypeEnum.png.name) {
              //         Get.dialog(
              //           ImageSlider(
              //             index: index,
              //             sliderList: listOfDoc.map((e) => e.file).toList()
              //             // id == 0 ? authVm.myDocuments.map((e) => e.file).toList() : authVm.additionalDocuments.map((e) => e.file).toList(),
              //           ),
              //         );
              //       } else if (fileType == FileTypeEnum.pdf.name) {
              //         Get.to(
              //           () => PDFViewWidget(
              //             path: document?.file!.path??"",
              //             isForSubmit: false,
              //           ),
              //         );
              //       } else {
              //         await OpenFilex.open(document?.file!.path);
              //       }
              //
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
              //     width: Get.width * .40,
              //     height: 40.w,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: AssetImage(
              //           (fileType == FileTypeEnum.jpg.name ||
              //                   fileType == FileTypeEnum.jpeg.name ||
              //                   fileType == FileTypeEnum.png.name
              //               ? R.images.image
              //               : fileType == FileTypeEnum.pdf.name
              //                   ? R.images.pdf
              //                   : (fileType == FileTypeEnum.xls.name ||
              //                           fileType == FileTypeEnum.xlsx.name)
              //                       ? R.images.xls
              //                       : R.images.doc),
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
              // if (fileType == FileTypeEnum.jpg.name ||
              //     fileType == FileTypeEnum.jpeg.name ||
              //     fileType == FileTypeEnum.png.name)
              Expanded(
                child: InkWell(
                  onTap: () async {
                    String? fileType =
                        document.document?.path.split('.').last.toString();
                    if (fileType != null) {
                      (fileType == FileTypeEnum.jpg.name ||
                              fileType == FileTypeEnum.jpeg.name ||
                              fileType == FileTypeEnum.png.name)
                          ? Get.to(() => ImageViewScreen(
                              imageProvider: FileImage(document.document!)))
                          : (fileType == FileTypeEnum.pdf.name)
                              ? Get.to(() => PDFViewWidget(
                                    path: document.document!.path,
                                    isForSubmit: false,
                                  ))
                              : await OpenFilex.open(document.document!.path);
                    }
                  },
                  child: (document.document!.path.split('.').last.toString() ==
                              FileTypeEnum.jpg.name ||
                          document.document!.path.split('.').last.toString() ==
                              FileTypeEnum.jpeg.name ||
                          document.document!.path.split('.').last.toString() ==
                              FileTypeEnum.png.name)
                      ? Container(
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 2),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(document.document!),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                      : Container(
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  (document.document!.path
                                              .split('.')
                                              .last
                                              .toString() ==
                                          FileTypeEnum.pdf.name)
                                      ? R.images.pdfPage
                                      : (document.document!.path
                                                      .split('.')
                                                      .last
                                                      .toString() ==
                                                  FileTypeEnum.xls.name ||
                                              document.document!.path
                                                      .split('.')
                                                      .last
                                                      .toString() ==
                                                  FileTypeEnum.xlsx.name)
                                          ? R.images.xlsPage
                                          : R.images.docPage,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                ),
              ),
              h1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      '${document.docName}.$fileType',
                      style: R.textStyles.inter(
                        color: R.colors.black,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Get.bottomSheet(MoreOptionSheet(
                          fromTempList: true,
                          tempListIndex: index,
                        ));
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: R.colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.more_horiz_outlined,
                          color: R.colors.black,
                          size: 14,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  Widget familyField() {
    return TextFormField(
      controller: familyController,
      focusNode: familyFN,
      maxLength: 15,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.done,
      validator: FieldValidator.validateName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: "family_member_name",
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

  DocumentType getDocType() {
    if (selectedDocType == listOfDocType[0].L()) {
      return DocumentType.myDocuments;
    } else if (selectedDocType == listOfDocType[1].L()) {
      return DocumentType.familyDocuments;
    } else {
      return DocumentType.additionalDocuments;
    }
  }
}
