import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../resources/resources.dart';
import 'image_picker_services.dart';

class ImagePickerOption extends StatefulWidget {
  final ValueChanged<File?>? uploadImage;
  final bool? isOptionEnable;
  const ImagePickerOption({
    this.uploadImage,
    super.key,
    this.isOptionEnable = false,
  });

  @override
  ImagePickerOptionState createState() => ImagePickerOptionState();
}

class ImagePickerOptionState extends State<ImagePickerOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: R.colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: Get.height * .05,
                      left: Get.width * .08,
                      right: Get.width * .08),
                  padding: EdgeInsets.only(
                      bottom: Get.height * .05,
                      top: Get.height * .02,
                      left: Get.width * .08,
                      right: Get.width * .08),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: R.colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Choose option",
                          style: R.textStyles.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: R.colors.black)),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      GestureDetector(
                        onTap: () {
                          ImagePickerServices.getProfileImage(
                                  isSizeOptional: widget.isOptionEnable,
                                  isCamera: false,
                                  context: context)
                              .then((value) async {
                            if (ImagePickerServices.profileImage != null) {
                              bool check =
                                  await ImagePickerServices.checkFileSize(
                                      ImagePickerServices.profileImage!.path);

                              if (check) {
                                widget.uploadImage!(
                                    ImagePickerServices.profileImage);
                                ImagePickerServices.profileImage = null;
                              }
                            }
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          color: R.colors.white,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image,
                                size: 25,
                              ),
                              SizedBox(
                                width: Get.width * .03,
                              ),
                              Text("Gallery",
                                  style: R.textStyles.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.sp,
                                      color: R.colors.black)),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      GestureDetector(
                        onTap: () {
                          ImagePickerServices.getProfileImage(
                                  isSizeOptional: widget.isOptionEnable,
                                  isCamera: true,
                                  context: context)
                              .then((value) async {
                            if (ImagePickerServices.profileImage != null) {
                              bool check =
                                  await ImagePickerServices.checkFileSize(
                                      ImagePickerServices.profileImage!.path);
                              if (check) {
                                widget.uploadImage!(
                                    ImagePickerServices.profileImage);
                                ImagePickerServices.profileImage = null;
                              }
                            }
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          color: R.colors.white,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.camera,
                                size: 25,
                              ),
                              SizedBox(
                                width: Get.width * .03,
                              ),
                              Text("Camera",
                                  style: R.textStyles.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.sp,
                                      color: R.colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
