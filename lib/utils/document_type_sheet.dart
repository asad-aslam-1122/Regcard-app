import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/utils/heights_widths.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:sizer/sizer.dart';

import '../services/image_picker/image_picker_services.dart';

class DocumentTypeSheet extends StatefulWidget {
  final bool showDocument;
  final ValueChanged<File?>? uploadImage;

  const DocumentTypeSheet(
      {super.key, this.showDocument = true, this.uploadImage});

  @override
  State<DocumentTypeSheet> createState() => _DocumentTypeSheetState();
}

class _DocumentTypeSheetState extends State<DocumentTypeSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: R.colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Row(
          children: [
            uploadType(R.images.camera, 'camera', () {
              ImagePickerServices.getProfileImage(
                      isCamera: true, context: context)
                  .then((value) async {
                if (ImagePickerServices.profileImage != null) {
                  widget.uploadImage!(ImagePickerServices.profileImage);
                  ImagePickerServices.profileImage = null;
                  Get.back();
                }
              });
            }),
            uploadType(R.images.gallery, 'gallery', () {
              ImagePickerServices.getProfileImage(
                      isCamera: false, context: context)
                  .then((value) async {
                if (ImagePickerServices.profileImage != null) {
                  widget.uploadImage!(ImagePickerServices.profileImage);
                  ImagePickerServices.profileImage = null;
                  Get.back();
                }
              });
            })
          ],
        ),
      ),
    );
  }

  Widget uploadType(String image, String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: R.colors.darkBrown, shape: BoxShape.circle),
              child: Image.asset(image, scale: 5),
            ),
          ),
          h0P5,
          Text(
            title.L(),
            style:
                R.textStyles.inter(fontWeight: FontWeight.w300, fontSize: 9.sp),
          )
        ],
      ),
    );
  }
}
