import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:regcard/constant/app_user.dart';
import 'package:regcard/src/base/view/my_regcard/model/reg_card_model.dart';

import '../../../../../constant/api_urls.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../model/duration_model.dart';

class MyRegCardVm with ChangeNotifier {
  ApiRequest apiRequest = ApiRequest();
  RegCardModel regCardModel = RegCardModel();
  List<DurationModel> durationList = [];

  ////Get Durations
  Future<bool> getAllDurations() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getDuration,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("get durations ---$r");
        List list = jsonDecode(r);
        durationList = list.map((e) => DurationModel.fromJson(e)).toList();
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["title"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  Future<bool> getAllRegCards(
      {required int pageNumber, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getQrCodeData(
          pageNumber: pageNumber, pageSize: AppUser.pageSize),
      giveHeader: true,
      onSuccess: (r) {
        if (isLoading) {
          RegCardModel temp = RegCardModel.fromJson(jsonDecode(r));
          regCardModel.hasNext = temp.hasNext;
          regCardModel.currentPage = temp.currentPage;
          (regCardModel.regCardItems ?? []).addAll(temp.regCardItems ?? []);
        } else {
          regCardModel = RegCardModel.fromJson(jsonDecode(r));
        }
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["title"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  Future<bool> shareQRCodeToggle({required bool value, required int id}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.shareQRCodeData,
      body: {"id": id, "value": value},
      giveHeader: true,
      onSuccess: (r) {
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["message"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  void update() {
    notifyListeners();
  }
}
