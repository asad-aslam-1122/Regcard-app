import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:regcard/src/auth/view/login_view.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';

import '../constant/app_user.dart';
import '../src/auth/model/login_model.dart';
import 'hive_db.dart';
import 'my_header.dart';

class ApiRequest {
  Future post(
      {String? url,
      dynamic body,
      Function(String)? onSuccess,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      log("this is url: $url");
      log("this is header: ${MyHeaders.header()}");

      final msg = jsonEncode(body);

      var response = await http
          .post(Uri.parse(url!),
              headers: MyHeaders.header(giveHeader: giveHeader), body: msg)
          .timeout(const Duration(seconds: 90), onTimeout: () {
        throw Exception("Request Time Out");
      });
      log("body ${response.statusCode}");
      log("Response: ${response.body}");
      debugPrint(response.body.toString());
      log("error code ${response.statusCode}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess!(response.body);
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }

  Future put(
      {String? url,
      var body,
      var header,
      Function(String)? onSuccess,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      log("this is put url: $url");
      log("put request body: $body");
      print("this is header: ${MyHeaders.header()}");
      log("header value: $giveHeader");

      final msg = jsonEncode(body);

      var response = await http
          .put(Uri.parse(url!),
              headers: MyHeaders.header(giveHeader: giveHeader), body: msg)
          .timeout(const Duration(seconds: 90), onTimeout: () {
        throw Exception("Request Time Out");
      });
      log("body ${response.statusCode}");
      log(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        log("check ${response.statusCode}");
        onSuccess!(response.body);
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }

  // Get function
  Future get(
      {String? url,
      Function(String)? onSuccess,
      Function(String)? onSuccess204,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      debugPrint("this is get Url: $url");
      debugPrint(
          "this is header: ${jsonEncode(MyHeaders.header(giveHeader: giveHeader))}");
      var response = await http
          .get(Uri.parse(url!), headers: MyHeaders.header())
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw Exception("Request Time Out");
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess!(response.body);
        log("Response: ${response.body}");
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }

  Future getFile(
      {String? url,
      Function(dynamic)? onSuccess,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      debugPrint("this is get Url: $url");
      debugPrint(
          "this is header: ${jsonEncode(MyHeaders.header(giveHeader: giveHeader))}");
      var response = await http
          .get(Uri.parse(url!), headers: MyHeaders.header())
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw Exception("Request Time Out");
      });
      debugPrint(response.statusCode.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess!(response.bodyBytes);
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }

  Future delete(
      {String? url,
      var body,
      Function(String)? onSuccess,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      log("this is delete url: $url");
      log("delete request body: $body");
      final msg = jsonEncode(body);

      var response = await http
          .delete(Uri.parse(url!),
              headers: MyHeaders.header(giveHeader: giveHeader), body: msg)
          .timeout(const Duration(seconds: 90), onTimeout: () {
        throw Exception("Request Time Out");
      });
      log("status code: ${response.statusCode}");

      log(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess!(response.body);
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }

  Future<String> multipartPost({
    required File inputFile,
    required String url,
  }) async {
    try {
      log("url: $url");
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..files.add(await http.MultipartFile.fromPath(
          'inputFile',
          inputFile.path,
        ));
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var responseJson = jsonDecode(responseString);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var imageUrl = responseJson['message'];
        return imageUrl;
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: responseJson["message"]);
        return "";
      } else {
        debugPrint(
            'Error uploading image. Server returned status code ${response.statusCode}');
        return "";
      }
    } on PlatformException catch (e) {
      log('Error uploading image: ${e.message}');
      return "";
    }
  }

  Future patch(
      {String? url,
      var body,
      var header,
      Function(String)? onSuccess,
      Function(String)? onError,
      bool? giveHeader = true}) async {
    try {
      log("this is put url: $url");
      log("put request body: $body");
      print("this is header: ${MyHeaders.header()}");
      log("header value: $giveHeader");

      final msg = jsonEncode(body);

      var response = await http
          .patch(Uri.parse(url!),
              headers: MyHeaders.header(giveHeader: giveHeader), body: msg)
          .timeout(const Duration(seconds: 90), onTimeout: () {
        throw Exception("Request Time Out");
      });
      log("body ${response.statusCode}");
      log(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        log("check");

        onSuccess!(response.body);
      } else if (response.statusCode == 433 || response.statusCode == 401) {
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        Get.context?.read<AuthVm>().clearPersonalizedList();
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      } else {
        onError!(response.body);
      }
    } on PlatformException catch (e) {
      log("i am in error catch ${e.message}");
    }
  }
}
