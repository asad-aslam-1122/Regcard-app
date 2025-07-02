import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/src/base/view/home/model/chat_head_model.dart';
import 'package:regcard/src/base/view/home/model/chat_model.dart';
import 'package:regcard/src/base/view/home/model/notifications_model.dart';
import 'package:regcard/src/base/view/home/view/conversation_view.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../../../constant/api_urls.dart';
import '../../../../../constant/app_user.dart';
import '../../../../../services/api_service.dart';
import '../../../../../utils/bot_toast/zbot_toast.dart';
import '../model/members_model.dart';
import '../model/travel_guides_model.dart';

class HomeVm extends ChangeNotifier {
  ScrollController controller = ScrollController();
  ApiRequest apiRequest = ApiRequest();
  TravelGuidesModel travelGuidesModel = TravelGuidesModel();
  MembersModel membersModel = MembersModel();
  MembersModel homeMembersModel = MembersModel();
  NotificationModel notificationModel = NotificationModel();
  ChatModel chatModel = ChatModel();
  ChatModel adminChatModel = ChatModel();
  ChatHeadModel chatHeadModel = ChatHeadModel();
  ChatHead chatHead = ChatHead();
  Sender? otherUser;

  void update() {
    notifyListeners();
  }

  ////Home

  Future<bool> getTravelGuides(
      {int? pageNumber, String? searchText, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getTravelGuides(
          pageNumber: pageNumber ?? 1,
          pageSize: AppUser.pageSize,
          searchText: searchText ?? ''),
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("--travel Guides-$r");
        if (isLoading) {
          TravelGuidesModel temp = TravelGuidesModel.fromJson(jsonDecode(r));
          travelGuidesModel.hasNext = temp.hasNext;
          travelGuidesModel.currentPage = temp.currentPage;
          (travelGuidesModel.travelItems ?? []).addAll(temp.travelItems ?? []);
        } else {
          travelGuidesModel = TravelGuidesModel.fromJson(jsonDecode(r));
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

  Future<bool> getMembers(
      {int? pageNumber, String? searchText, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getMembers(
          pageNumber: pageNumber ?? 1,
          pageSize: AppUser.pageSize,
          searchText: searchText ?? ''),
      giveHeader: true,
      onSuccess: (r) {
        log("--member-$r");
        if (isLoading) {
          MembersModel temp = MembersModel.fromJson(jsonDecode(r));
          membersModel.hasNext = temp.hasNext;
          membersModel.currentPage = temp.currentPage;
          (membersModel.membersItems ?? []).addAll(temp.membersItems ?? []);
        } else {
          membersModel = MembersModel.fromJson(jsonDecode(r));
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

  Future<bool> getHomeMembers() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getMembers(pageNumber: 1, pageSize: 10, searchText: ''),
      giveHeader: true,
      onSuccess: (r) {
        log("--homeMembers-$r");
        homeMembersModel = MembersModel.fromJson(jsonDecode(r));
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

  Future<bool> sendRequest(String requestedToId) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.sendConnectionRequest,
      body: {
        'requestedToId': requestedToId,
      },
      giveHeader: true,
      onSuccess: (r) {
        log("--sendRequest-$r");
        ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
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

  Future<bool> acceptOrRejectConnectionRequest({required var body}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.acceptOrRejectConnectionRequest,
      body: body,
      giveHeader: true,
      onSuccess: (r) {
        ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
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

  Future<bool> removeConnection(num id) async {
    bool proceed = false;
    await apiRequest.delete(
      url: ApiUrl.removeConnection(id),
      giveHeader: true,
      onSuccess: (r) {
        ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
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

  Future<bool> createChatHead(String secondUserId) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.createChatHead,
      body: {"secondUserId": secondUserId},
      giveHeader: true,
      onSuccess: (r) async {
        log("--createChatHead $r");
        chatHead = ChatHead.fromJson(jsonDecode(r));
        await getChatById(pageNumber: 1, isLoading: false);
        ZBotToast.loadingClose();
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

  Future<bool> deleteChatHead(num id) async {
    bool proceed = false;
    await apiRequest.delete(
      url: ApiUrl.deleteChatHead(id),
      giveHeader: true,
      onSuccess: (r) {
        ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
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

  Future<bool> readChat() async {
    bool proceed = false;
    await apiRequest.put(
      url: ApiUrl.readChat,
      body: {"chatHeadId": chatHead.chatHeadId},
      giveHeader: true,
      onSuccess: (r) {
        Get.context!.read<BaseVm>().getProfile();
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

  Future<bool> getChatById(
      {required int pageNumber, required bool isLoading}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.getChatById,
      body: {
        "request": {"pageNumber": pageNumber, "pageSize": AppUser.pageSize},
        "chatHeadId": chatHead.chatHeadId
      },
      giveHeader: true,
      onSuccess: (r) {
        log("--getChatById $r");

        if (isLoading) {
          ChatModel temp = ChatModel.fromJson(jsonDecode(r));
          (chatModel.message ?? []).insertAll(0, temp.message ?? []);
        } else {
          chatModel = ChatModel.fromJson(jsonDecode(r));
        }

        otherUser = (chatHead.users ?? [])[0].id == AppUser.userProfile?.id
            ? (chatHead.users ?? [])[1]
            : (chatHead.users ?? [])[0];
        Get.toNamed(
          ConversationView.route,
          arguments: {"otherUser": otherUser},
        );
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

  Future<bool> getChatHead({int? pageNumber, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.getChatHead,
      body: {
        "query": {
          "pageNumber": pageNumber ?? 1,
          "pageSize": AppUser.pageSize,
          "data": {
            "filters": [
              {"actionType": 1, "val": "0"}
            ]
          }
        }
      },
      giveHeader: true,
      onSuccess: (r) {
        log("--getChatHead $r");
        if (isLoading) {
          ChatHeadModel temp = ChatHeadModel.fromJson(jsonDecode(r));
          (chatHeadModel.chatHead ?? []).addAll(temp.chatHead ?? []);
        } else {
          chatHeadModel = ChatHeadModel.fromJson(jsonDecode(r));
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

  Future<int> getProfileCompletionPercentage() async {
    int percentage = 0;

    await apiRequest.get(
      url: ApiUrl.getProfileCompletionPercentage,
      giveHeader: true,
      onSuccess: (r) {
        String decodedResponse = jsonDecode(r)['message'];
        percentage = int.parse(decodedResponse);
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["message"]);
      },
    );
    notifyListeners();
    return percentage;
  }

  Future<bool> getAllNotifications(
      {int? pageNumber, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getAllNotifications(
          pageNumber: pageNumber ?? 1, pageSize: AppUser.pageSize),
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("--notifications-$r");
        if (isLoading) {
          NotificationModel temp = NotificationModel.fromJson(jsonDecode(r));
          notificationModel.hasNext = temp.hasNext;
          notificationModel.currentPage = temp.currentPage;
          (notificationModel.items ?? []).addAll(temp.items ?? []);
        } else {
          notificationModel = NotificationModel.fromJson(jsonDecode(r));
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

  Future<bool> markAsSeen({int? notificationId}) async {
    bool proceed = false;

    await apiRequest.put(
      url: ApiUrl.markAsSeen(id: notificationId ?? 0),
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

  Future<bool> sendMessage(var body) async {
    bool proceed = false;

    await apiRequest.post(
      url: ApiUrl.sendMessage,
      body: body,
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

  Future<bool> blockUser(var body) async {
    bool proceed = false;

    await apiRequest.put(
      url: ApiUrl.blockUser,
      body: body,
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

  Future<bool> reportUser(var body) async {
    bool proceed = false;

    await apiRequest.post(
      url: ApiUrl.reportUser,
      body: body,
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

  HubConnection? hubConnection;

  Future<void> initializeSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
            ApiUrl.chatHub,
            HttpConnectionOptions(
              logging: (level, message) => log("HubConnectionBuilder $message"),
            ))
        .withAutomaticReconnect()
        .build();

    hubConnection?.on('ReceiveMessage', (message) {
      log('ReceiveMessage: $message');
      Message msg = Message.fromJson(message?.first);
      if (chatHead.chatHeadId == msg.chatHeadId) {
        chatHead.lastMsg = msg;
        (chatModel.message ?? []).add(msg);
        scrollToEnd();
        update();
      }
    });

    await startHubConnection();
  }

  Future<void> startHubConnection() async {
    try {
      await hubConnection?.start();
      log('Hub connection started');
    } catch (e) {
      log('Failed to start hub connection: $e');
    }
  }

  Future<void> stopHubConnection() async {
    try {
      await hubConnection?.stop();
      log('Hub connection stopped');
    } catch (e) {
      log('Failed to stop hub connection: $e');
    }
  }

  void scrollToEnd() {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent * 100,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      log("Scroll to end");
    }
  }
}
