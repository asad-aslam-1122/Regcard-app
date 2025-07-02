// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:regcard/constant/enums.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/services/custom_file_picker/image_view.dart';
import 'package:regcard/services/custom_file_picker/pdf_view_widget.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

class FilePickerWidget extends StatefulWidget {
  List<File> list;
  ValueSetter<dynamic> onSelect;
  final bool showDocument;
  final bool? isDocUpload;
  final String? documentName;

  FilePickerWidget({
    super.key,
    required this.list,
    required this.onSelect,
    required this.showDocument,
    this.documentName,
    this.isDocUpload,
  });

  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  List<File> list = [];
  final picker = ImagePicker();

  Future<FilePickerResult?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
      ],
    );
    return result;
  }

  Future<File?> getImage(bool fromCamera) async {
    File? image;
    final pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        String fileType = pickedFile.path.split(".").last.toString();
        if ((fileType == FileTypeEnum.jpg.name ||
            fileType == FileTypeEnum.jpeg.name ||
            fileType == FileTypeEnum.png.name)) {
          image = File(pickedFile.path);
        } else {
          ZBotToast.showToastError(message: "File format not supported");
        }
      } else {
        ZBotToast.showToastError(message: "No image selected");
      }
    });
    return image;
  }

  Future<void> renameFile(File file, String newName) async {
    String newPath = newName;
    await file.rename(newPath);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        for (var element in widget.list) {
          list.add(element);
          widget.onSelect(list);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
        builder: (context, authVm, child) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    widget.isDocUpload ?? false
                        ? Get.bottomSheet(uploadSheet())
                        : ZBotToast.showToastError(
                            message: 'Please enter the document name.');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: DottedBorder(
                            radius: const Radius.circular(2),
                            dashPattern: [6, 6],
                            color: R.colors.black,
                            borderType: BorderType.Rect,
                            padding: EdgeInsets.all(0),
                            strokeWidth: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: R.colors.white.withOpacity(0.5),
                                // borderRadius: BorderRadius.circular(10)
                              ),
                              child: Icon(
                                Icons.add,
                                color: R.colors.black,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                        h3,
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }

  Widget uploadSheet() {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: Get.height * .02, horizontal: Get.width * 0.07),
        decoration: BoxDecoration(
          color: R.colors.bottomSheetColor,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(26), topLeft: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h2,
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                if (widget.showDocument) ...{
                  uploadType(
                      image: R.images.document, title: 'document', index: 0),
                  w3,
                },
                uploadType(image: R.images.camera, title: 'camera', index: 1),
                w3,
                uploadType(image: R.images.gallery, title: 'gallery', index: 2),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ));
  }

  Widget uploadType(
      {required String image, required String title, required int index}) {
    return GestureDetector(
      onTap: () async {
        switch (index) {
          case 0:
            {
              bool isSubmitted = false;

              FilePickerResult? result = await pickFiles();

              if (result != null) {
                String fileType =
                    result.files.first.path!.split('.').last.toString();
                if ((fileType == FileTypeEnum.jpg.name ||
                    fileType == FileTypeEnum.jpeg.name ||
                    fileType == FileTypeEnum.png.name ||
                    fileType == FileTypeEnum.pdf.name)) {
                  if (fileType == FileTypeEnum.pdf.name) {
                    isSubmitted = await Get.to(
                        () => PDFViewWidget(path: result.files.first.path!));
                  } else {
                    isSubmitted = await Get.to(ImageView(
                      path: File(result.files.first.path!),
                    ));
                  }
                  if (isSubmitted) {
                    setState(() {
                      List<File> selectedFiles = [];
                      selectedFiles =
                          result.paths.map((path) => File(path!)).toList();
                      selectedFiles.forEach((element) {
                        renameFile(element, widget.documentName ?? 'new file');
                        list.add(element);
                      });
                      widget.onSelect(list);
                    });
                  }
                  Get.back();
                } else {
                  ZBotToast.showToastError(
                      message: "File format not supported");
                }
              } else {
                ZBotToast.showToastError(message: "No file selected");
              }
            }
            break;
          case 1:
            File? file = await getImage(true);

            if (file != null) {
              bool isSubmitted = await Get.to(ImageView(
                path: File(file.path),
              ));

              if (isSubmitted) {
                setState(() {
                  List<File> selectedFiles = [];
                  selectedFiles = [File(file.path)];
                  selectedFiles.forEach((element) {
                    renameFile(element, widget.documentName ?? 'new file');
                    list.add(element);
                  });
                  widget.onSelect(list);
                });
              }

              Get.back();
            }
            break;
          case 2:
            File? file = await getImage(false);
            if (file != null) {
              bool isSubmitted = await Get.to(ImageView(
                path: File(file.path),
              ));

              String fileType = file.path.split('.').last.toString();

              if (isSubmitted &&
                  (fileType == FileTypeEnum.jpg.name ||
                      fileType == FileTypeEnum.jpeg.name ||
                      fileType == FileTypeEnum.png.name)) {
                setState(() {
                  List<File> selectedFiles = [];
                  selectedFiles = [File(file.path)];
                  selectedFiles.forEach((element) {
                    renameFile(element, widget.documentName ?? 'new file');
                    list.add(element);
                  });
                  widget.onSelect(list);
                });
              }

              Get.back();
            }
            break;
        }
      },
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: R.colors.primaryColor,
            ),
            child: Image.asset(
              image,
              scale: 5,
              //color: R.colors.primaryColor,
              // height: 22,
              // width: 22,
            ),
          ),
          Text(
            title.L(),
            style: R.textStyles.inter().copyWith(
                  color: R.colors.black,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
          ),
        ],
      ),
    );
  }
}
