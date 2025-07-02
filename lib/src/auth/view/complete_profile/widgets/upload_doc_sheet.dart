import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/model/temp_list_model.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/image_preview.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/safe_area_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constant/enums.dart';
import '../../../../../resources/resources.dart';
import '../../../../../services/custom_file_picker/file_picker_widget.dart';
import '../../../../../services/custom_file_picker/pdf_view_widget.dart';
import '../../../../../utils/app_button.dart';
import '../../../../../utils/drop_down_widget.dart';
import '../../../../../utils/field_validations.dart';
import '../../../../../utils/heights_widths.dart';
import '../../../view_model/auth_vm.dart';

class UploadDocumentSheet extends StatefulWidget {
  // final String? title;
  // final String? subTitle;
  // final String? firstButtonTitle;
  // final String? secondButtonTitle;
  // final VoidCallback? firstButtonOnTap;
  // final VoidCallback? secondButtonOnTap;
  final bool? isAddToTempList;
  final DocumentType? docType;
  final bool isDocTypeSelected;
  final bool isRecordsDoc;
  final bool isForUpdate;
  final bool isForUpdateTemp;
  final String? documentUrl;
  final String? familyMemberName;
  final String? documentName;
  final int? documentID;
  final int? tempDocIndex;

  // final bool? showSecondButton;
  // final bool willPop;

  const UploadDocumentSheet(
      {super.key,
      // required this.title,
      // required this.subTitle,
      this.docType,
      this.isAddToTempList = false,
      this.isDocTypeSelected = false,
      this.isRecordsDoc = false,
      this.isForUpdate = false,
      this.isForUpdateTemp = false,
      this.documentUrl,
      this.familyMemberName,
      this.documentName,
      this.documentID,
      this.tempDocIndex
      // required this.showSecondButton,
      // this.firstButtonTitle,
      // this.secondButtonTitle,
      // this.firstButtonOnTap,
      // this.secondButtonOnTap,
      // this.willPop = true
      });

  @override
  State<UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends State<UploadDocumentSheet> {
  TextEditingController docController = TextEditingController();
  FocusNode docFN = FocusNode();
  final _formKey = GlobalKey<FormState>();
  File? selectedFile;
  String? existFilePath;
  String? fileName;
  FocusNode docTypeFN = FocusNode();
  FocusNode familyFN = FocusNode();
  String? selectedDocType;
  bool success = false;
  TextEditingController familyController = TextEditingController();

  List<String> listOfDocType = [
    "My Documents",
    "Family Documents",
    "Additional Documents",
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var authVm = Provider.of<AuthVm>(context, listen: false);
      if (widget.isForUpdate || (widget.isRecordsDoc && widget.isForUpdate)) {
        ZBotToast.loadingShow();
        selectedFile = await urlToFile(widget.documentUrl ?? "");
        docController.text = widget.documentName ?? "";
        fileName =
            '${widget.documentName}.${selectedFile?.path.split('.').last.toString()}';
        setState(() {});
        ZBotToast.loadingClose();
      } else if (widget.isForUpdateTemp) {
        selectedFile = authVm.tempDocList[widget.tempDocIndex ?? 0].document;
        docController.text =
            authVm.tempDocList[widget.tempDocIndex ?? 0].docName ?? "";
        fileName =
            "${authVm.tempDocList[widget.tempDocIndex ?? 0].docName}.${authVm.tempDocList[widget.tempDocIndex ?? 0].document?.path.split('.').last.toString()}";
        setState(() {});
      }
    });
    super.initState();
    print("doc type: ${widget.docType?.index}");
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = math.Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(
        '$tempPath${rng.nextInt(100)}.${imageUrl.split('.').last.toString()}');
    existFilePath = file.path;
    print("file path : $existFilePath");
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVm, BaseVm>(
        builder: (context, authVm, baseVm, child) => Container(
              // height: 38.h ,
              width: double.infinity,
              decoration: BoxDecoration(
                color: R.colors.bottomSheetColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                  ) +
                  EdgeInsets.only(top: 3.h),
              child: SafeAreaWidget(
                backgroundColor: R.colors.bottomSheetColor,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.isRecordsDoc
                              ? "add_records".L()
                              : "add_documents".L(),
                          textAlign: TextAlign.center,
                          style: R.textStyles.inter(
                              color: R.colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        h0P5,
                        Text('add_document_desc'.L(),
                            textAlign: TextAlign.center,
                            style: R.textStyles.inter(
                              fontWeight: FontWeight.w300,
                              color: R.colors.black,
                              fontSize: 10.sp,
                            )),
                        h3,
                        if (widget.isDocTypeSelected == false)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('select_type'.L(),
                                    style: R.textStyles.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600)),
                                h1,
                                DropdownWidget(
                                  validator: FieldValidator.validateDocDropdown,
                                  onChanged: (updatedValue) {
                                    selectedDocType = updatedValue;
                                    setState(() {});
                                  },
                                  selectedValue: selectedDocType,
                                  list: listOfDocType,
                                  hintText: "select_document_type",
                                ),
                                if (listOfDocType
                                        .indexOf(selectedDocType ?? "") ==
                                    DocumentType.familyDocuments.index) ...[
                                  h1,
                                  familyField()
                                ],
                                h1,
                              ]),
                        docField(),
                        h2,
                        if (selectedFile == null) addDocumentWidget(),
                        h0P5,
                        if (selectedFile != null)
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              SizedBox(
                                width: 23.w,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        String? fileType = selectedFile?.path
                                            .split('.')
                                            .last
                                            .toString();
                                        if (fileType != null) {
                                          (fileType == FileTypeEnum.jpg.name ||
                                                  fileType ==
                                                      FileTypeEnum.jpeg.name ||
                                                  fileType ==
                                                      FileTypeEnum.png.name)
                                              ? Get.to(() => ImageViewScreen(
                                                  imageProvider:
                                                      FileImage(selectedFile!)))
                                              : (fileType ==
                                                      FileTypeEnum.pdf.name)
                                                  ? Get.to(() => PDFViewWidget(
                                                        path:
                                                            selectedFile!.path,
                                                        isForSubmit: false,
                                                      ))
                                                  : await OpenFilex.open(
                                                      selectedFile!.path);
                                        }
                                      },
                                      child: (selectedFile!.path
                                                  .split('.')
                                                  .last
                                                  .toString() !=
                                              FileTypeEnum.pdf.name)
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, left: 5, right: 2),
                                              width: 15.w,
                                              height: 15.w,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        selectedFile!),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, left: 5, right: 5),
                                              width: Get.width * .145,
                                              height: 15.w,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      (selectedFile!.path
                                                                  .split('.')
                                                                  .last
                                                                  .toString() ==
                                                              FileTypeEnum
                                                                  .pdf.name)
                                                          ? R.images.pdf
                                                          : (selectedFile!.path
                                                                          .split(
                                                                              '.')
                                                                          .last
                                                                          .toString() ==
                                                                      FileTypeEnum
                                                                          .xls
                                                                          .name ||
                                                                  selectedFile!
                                                                          .path
                                                                          .split(
                                                                              '.')
                                                                          .last
                                                                          .toString() ==
                                                                      FileTypeEnum
                                                                          .xlsx
                                                                          .name)
                                                              ? R.images.xls
                                                              : R.images.doc,
                                                    ),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      fileName ?? "",
                                      // "${selectedFile!.path.split('/').last.length >= 5 ? selectedFile!.path.split('/').last.substring(0, 5) : selectedFile!.path.split('/').last}.${selectedFile!.path.split('.').last}",
                                      //  selectedFile!.path.split("/").removeLast(),
                                      style: R.textStyles.inter(
                                        color: R.colors.black,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFile = null;
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          right: (selectedFile!.path
                                                      .split('.')
                                                      .last
                                                      .toString() !=
                                                  FileTypeEnum.pdf.name)
                                              ? 1.w
                                              : 3.w),
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: R.colors.black,
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: R.colors.black),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.close,
                                            color: R.colors.white, size: 14),
                                      )),
                                ),
                              )
                            ],
                          ),
                        h2,
                        AppButton(
                          buttonTitle:
                              widget.isForUpdate || widget.isForUpdateTemp
                                  ? 'update'
                                  : 'save',
                          textSize: 10.sp,
                          onTap: () async {
                            ZBotToast.loadingShow();
                            String url = "";
                            if (selectedDocType == null &&
                                !widget.isDocTypeSelected) {
                              ZBotToast.showToastError(
                                  message: 'Please select document type.');
                            } else if (familyController.text.isEmpty &&
                                !widget.isDocTypeSelected &&
                                listOfDocType.indexOf(selectedDocType ?? "") ==
                                    DocumentType.familyDocuments.index) {
                              ZBotToast.showToastError(
                                  message: 'Please enter Family Member Name.');
                            } else if (docController.text.isEmpty) {
                              ZBotToast.showToastError(
                                  message: 'Please enter document name.');
                            } else if (selectedFile == null) {
                              ZBotToast.showToastError(
                                  message: 'Please add document.');
                            } else if (widget.isForUpdateTemp) {
                              authVm.tempDocList[widget.tempDocIndex ?? 0] =
                                  TempModel(
                                      docName: docController.text.trim(),
                                      document: selectedFile);
                              authVm.update();
                              Get.back();
                            } else if (widget.isAddToTempList == false) {
                              url = existFilePath == selectedFile?.path
                                  ? widget.documentUrl ?? ""
                                  : await authVm.uploadImageUrl(selectedFile);
                              if (widget.isRecordsDoc == false) {
                                Map body = widget.isForUpdate
                                    ? {
                                        'id': widget.documentID,
                                        'documentType': widget.docType?.index,
                                        'name': docController.text,
                                        'documentUrl': url,
                                        'familyMember': widget.familyMemberName
                                      }
                                    : {
                                        "documentType": widget.isDocTypeSelected
                                            ? widget.docType?.index
                                            : listOfDocType
                                                .indexOf(selectedDocType ?? ""),
                                        "name": docController.text,
                                        "documentUrl": url,
                                        "familyMember": widget.isDocTypeSelected
                                            ? widget.familyMemberName
                                            : (familyController.text.isNotEmpty
                                                ? familyController.text.trim()
                                                : null)
                                      };
                                success = widget.isForUpdate
                                    ? await authVm.updateDocument(body: body)
                                    : await authVm.uploadDocument(body: body);
                              } else {
                                Map body = widget.isForUpdate
                                    ? {
                                        'id': widget.documentID,
                                        "name": docController.text,
                                        "recordUrl": url,
                                      }
                                    : {
                                        "name": docController.text,
                                        "recordUrl": url,
                                      };
                                success = widget.isForUpdate
                                    ? await baseVm.updateRecord(body: body)
                                    : await baseVm.createRecord(body: body);
                                baseVm.getRecords();
                              }
                              if (success) {
                                Get.back();
                                // ZBotToast.loadingShow();
                                // if (widget.isDocTypeSelected) {
                                //   widget.uploadedDocList!(authVm.allDocList);
                                // }
                                //   ZBotToast.loadingClose();
                              }
                            } else {
                              authVm.tempDocList.add(TempModel(
                                  docName: docController.text,
                                  document: selectedFile));
                              authVm.update();
                              Get.back();
                            }
                            //     if(selectedFile != null) {
                            //      // url = await authVm.uploadImageUrl(selectedFile);
                            //
                            // Map body = {
                            //       "documentType": selectedDocType?.id,
                            //     "name": docController.text,
                            //     "documentUrl": url,
                            //     "familyMember": familyController.text.isNotEmpty? familyController.text : null
                            //   };
                            //
                            //   //  bool success = await baseVm.uploadDocument(body: body);
                            //   //  if (success) {
                            //   //    baseVm.getDocument();
                            //       if(selectedDocType == null && widget.isDocTypeSelected == true ) {
                            //         ZBotToast.showToastError(message: 'Please select document type.');
                            //       }
                            //       else if(selectedFile == null){
                            //         ZBotToast.showToastError(message: 'Please add document.');
                            //       }
                            //       else {
                            //         Get.back();
                            //         if (widget.isRegcardDoc ?? false)   {
                            //           authVm.tempList.add(NewDocumentModel(name: docController.text,
                            //             documentUrl: url,
                            //             documentType:  selectedDocType?.documentType
                            //         ));}
                            //         else if (widget.isRecordsDoc == true ){
                            //           authVm.myRecordsList.add(NewDocumentModel(name: docController.text, documentUrl: url, documentType: selectedDocType?.documentType));
                            //         }
                            //         else if (selectedDocType?.documentType == DocumentType.myDocuments) {
                            //           authVm.docList.add(NewDocumentModel(name: docController
                            //               .text, documentUrl:  url, documentType: selectedDocType?.documentType ));
                            //         }
                            //         // else {
                            //         //   if(docList.any((element) => element.familyMember == familyController.text)) {
                            //         //     int doc = docList.indexWhere((element) => element.familyMember == familyController.text);
                            //         //     authVm.familyDocuments[doc].docs?.add(DocumentModel(name: docController
                            //         //         .text, file: selectedFile, type: selectedDocType?.documentType ));
                            //         //   }
                            //         //   else {
                            //         //     docList.add(NewDocumentModel(familyMember: familyController.text, docs: [
                            //         //       DocumentModel(name: docController
                            //         //           .text, file: selectedFile, type: selectedDocType?.documentType )]));
                            //         //   }
                            //        // }
                            //
                            //       //};
                            //       authVm.update();
                            //
                            //     }}
                            ////
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
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget addDocumentWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 13.w,
          child: FilePickerWidget(
            documentName: docController.text,
            showDocument: true,
            list: selectedFile == null
                ? []
                : [selectedFile!] /*context.read<AuthVm>().attachmentsList*/,
            isDocUpload: docController.text.isNotEmpty ? true : false,
            onSelect: (list) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {});
              selectedFile = list.last;
              fileName =
                  '${docController.text}.${selectedFile?.path.split('.').last.toString()}';
              //context.read<AuthVm>().attachmentsList = list;
              // context.read<AuthVm>().update();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'add_document'.L(),
                style: R.textStyles.inter(
                    color: R.colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'add_document_desc'.L(),
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

  Widget docField() {
    return TextFormField(
      controller: docController,
      focusNode: docFN,
      textCapitalization: TextCapitalization.none,
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.text,
      validator: FieldValidator.validateDocName,
      inputFormatters: [LengthLimitingTextInputFormatter(9)],
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: R.decoration.fieldDecoration(
        hintText: widget.isRecordsDoc ? "record_name" : "document_name",
      ),
      onTap: () {
        setState(() {});
      },
      onChanged: (val) {
        fileName = '$val.${selectedFile?.path.split('.').last.toString()}';
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

  Widget familyField() {
    return TextFormField(
      controller: familyController,
      focusNode: familyFN,
      maxLength: 12,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      style: R.textStyles.inter(color: R.colors.black, fontSize: 10.sp),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
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
}
