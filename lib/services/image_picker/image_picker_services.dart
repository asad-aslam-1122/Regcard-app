import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:regcard/utils/localization_extension.dart';

import '../../utils/bot_toast/zbot_toast.dart';

class ImagePickerServices {
  static File? profileImage;

  static Future<bool> checkFileSize(path) async {
    var sizeLimitInKB = 1024 * 5;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > sizeLimitInKB) {
      ZBotToast.showToastError(
          message: "image_size_is_greater_than_the_limit".L());
      return false;
    } else {
      return true;
    }
  }

  static Future getProfileImage({
    bool isCamera = false,
    bool? isSizeOptional = false,
    BuildContext? context,
  }) async {
    final pickedFile = isCamera
        ? await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          )
        : await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
    if (pickedFile != null) {
      File? croppedFile = await cropImage(
          filePath: pickedFile.path, isOptionsEnabled: isSizeOptional!);
      profileImage = File(croppedFile?.path ?? "");
    }
  }

  static Future<File?> cropImage(
      {required String filePath, required bool isOptionsEnabled}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          aspectRatioPresets: isOptionsEnabled
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: isOptionsEnabled
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
        ),
      ],
    );
    File tempFile = File(croppedFile!.path);
    return tempFile;
  }
}
