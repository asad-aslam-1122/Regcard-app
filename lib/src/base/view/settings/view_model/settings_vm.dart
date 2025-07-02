import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:regcard/src/base/view/settings/model/connections_model.dart';

import '../../../../../constant/api_urls.dart';
import '../../../../../constant/app_user.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../model/notification_setting_model.dart';

class SettingsVm extends ChangeNotifier {
  ApiRequest apiRequest = ApiRequest();
  ConnectionsModel connectionsModel = ConnectionsModel();

  List<NotificationSettingModel> notificationSettingsList = [
    NotificationSettingModel(
        title: "chat_replies",
        isEnable: AppUser.userProfile?.isChatReplies ?? false),
    NotificationSettingModel(
        title: "connection_request",
        isEnable: AppUser.userProfile?.isConnectionRequest ?? false),
    NotificationSettingModel(title: "connection_accepted", isEnable: false),
    NotificationSettingModel(
        title: "news_article_uploaded",
        isEnable: AppUser.userProfile?.isNewsArticleUploaded ?? false),
    NotificationSettingModel(
        title: "sharing_history",
        isEnable: AppUser.userProfile?.isSharingHistory ?? false),
    NotificationSettingModel(
        title: "sharing_request_to_confirm",
        isEnable:
            AppUser.userProfile?.isRequiresSharingRequestConfirmation ?? false),
  ];

  Future<bool> getAllConnectionRequest(
      {int? pageNumber, String? searchText, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getAllConnectionRequest(
          pageNumber: pageNumber ?? 1,
          pageSize: AppUser.pageSize,
          searchText: searchText ?? ''),
      giveHeader: true,
      onSuccess: (r) {
        log("--Connection Request-$r");
        if (isLoading) {
          ConnectionsModel temp = ConnectionsModel.fromJson(jsonDecode(r));
          connectionsModel.hasNext = temp.hasNext;
          connectionsModel.currentPage = temp.currentPage;
          (connectionsModel.connectionsItems ?? [])
              .addAll(temp.connectionsItems ?? []);
        } else {
          connectionsModel = ConnectionsModel.fromJson(jsonDecode(r));
        }
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

  Future<bool> userSettingsToggle({int? type, bool? value}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.userSettingsToggle,
      body: {"type": type, "value": value},
      giveHeader: true,
      onSuccess: (r) {
        //ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
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

  bool isBiometricEnabled = false;

  update() {
    notifyListeners();
  }
}
