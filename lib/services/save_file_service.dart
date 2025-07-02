import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';

class SaveFileService {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static Future<void> downloadFile(String url, String name) async {
    AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if (Platform.isAndroid && info.version.sdkInt > 29) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
    Uint8List file = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    String localPath = (await _findLocalPath())!;

    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    final myImagePath = "${savedDir.path}$name";
    File imageFile = File(myImagePath);
    if (!await imageFile.exists()) {
      imageFile.create(recursive: true);
    }
    imageFile.writeAsBytes(file);
    ZBotToast.showToastSuccess(
        message: "\"$name\" ${"saved_to_downloads_successfully".L()}");
  }

  static Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }
}
