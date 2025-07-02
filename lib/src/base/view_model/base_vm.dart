import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:regcard/constant/api_urls.dart';
import 'package:regcard/services/api_service.dart';
import 'package:regcard/src/auth/model/legal_docs_model.dart';
import 'package:regcard/src/auth/model/new_document_model.dart';
import 'package:regcard/src/auth/model/user_profile.dart';
import 'package:regcard/src/base/model/info_regcard_model.dart';
import 'package:regcard/src/base/model/social_link_model.dart';
import 'package:regcard/src/base/view/account/model/personalized_model.dart';
import 'package:regcard/src/base/view/account/model/preferences_model.dart';
import 'package:regcard/src/base/view/explore/model/records_model.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';

import '../../../constant/app_user.dart';
import '../../../services/hive_db.dart';
import '../../../services/my_header.dart';
import '../../auth/view/login_view.dart';
import '../../auth/view_model/auth_vm.dart';

class BaseVm extends ChangeNotifier {
  PageController basePageController = PageController();
  ApiRequest apiRequest = ApiRequest();
  List<SocialLink> socialLinks = [];
  LegalDocsModel? legalDocsModel;
  PreferencesModel preferencesModel = PreferencesModel();
  PersonalizedModel personalizedModel = PersonalizedModel();
  NewDocumentModel newDocumentModel = NewDocumentModel();
  RecordsModel recordsModel = RecordsModel();
  InfoRegCardModel infoCardModel = InfoRegCardModel();

  int baseSelectedIndex = 1;

  void update() {
    notifyListeners();
  }

  Future<bool> getLegalDocs() async {
    bool proceed = false;
    await apiRequest.get(
        url: ApiUrl.getLegalDocs,
        giveHeader: false,
        onSuccess: (r) async {
          debugPrint("---$r");
          legalDocsModel = LegalDocsModel.fromJson(jsonDecode(r));
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> getSocialLinks() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getSocialLinks,
      giveHeader: false,
      onSuccess: (r) {
        socialLinks.clear();
        for (var item in jsonDecode(r) as List) {
          SocialLink link = SocialLink.fromJson(item);
          socialLinks.add(link);
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

  Future<bool> createHelpRequest({required Map? body}) async {
    bool proceed = false;
    await apiRequest.post(
      url: ApiUrl.createHelpRequest,
      body: body,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("---$r");
        Get.back();
        ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["message"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  Future<String> shareMyRegCard() async {
    String regCardLink = '';

    await apiRequest.get(
      url: ApiUrl.getsShareMyRegCard,
      giveHeader: true,
      onSuccess: (r) {
        regCardLink = jsonDecode(r)['message'];
        notifyListeners();
      },
      onError: (r) {
        ZBotToast.showToastError(message: jsonDecode(r)["message"]);
      },
    );
    notifyListeners();
    return regCardLink;
  }

  Future<bool> getRegCardInfo() async {
    bool proceed = false;
    await apiRequest.get(
        url: ApiUrl.getInfoMyRegCard,
        giveHeader: false,
        onSuccess: (r) async {
          debugPrint("---$r");
          infoCardModel = InfoRegCardModel.fromJson(jsonDecode(r));
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  /////Settings

  Future<void> deleteAccount({Map? body, required BuildContext context}) async {
    try {
      var response = await http
          .delete(Uri.parse(ApiUrl.deleteAccount),
              headers: MyHeaders.header(giveHeader: true),
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 90), onTimeout: () {
        throw Exception("Request Time Out");
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.back();
        await HiveDb.deleteData();
        context.read<AuthVm>().clearPersonalizedList();
        ZBotToast.loadingClose();
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastSuccess(
            message: jsonDecode(response.body)["message"]);
        context.read<BaseVm>().baseSelectedIndex = 1;
      } else {
        ZBotToast.showToastError(message: jsonDecode(response.body)["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  ////Profile
  Future<bool> getProfile() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getProfile,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("get profile ---$r");
        AppUser.userProfile = UserProfile.fromJson(jsonDecode(r));
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

  Future<bool> contactDetails({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.contactDetails,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> billingDetails({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.billingDetails,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> getPreferences() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getPreferences,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("---$r");
        preferencesModel = PreferencesModel.fromJson(jsonDecode(r));
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

  Future<bool> getPersonalized() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getPersonalized,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("---$r");
        personalizedModel = PersonalizedModel.fromJson(jsonDecode(r));
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

  Future<bool> updatePreferences({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.getPreferences,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> updatePersonalized({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.getPersonalized,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> updateProfilePic({required Map? body}) async {
    bool proceed = false;
    await apiRequest.patch(
        url: ApiUrl.getProfilePic,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  ////Documents

  Future<String> getMyRegCard({required bool isEditable}) async {
    String htmlData = '';

    await apiRequest.get(
        url: ApiUrl.myRegcard(isEditable: isEditable),
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");

          htmlData = r;
          notifyListeners();
        },
        onError: (r) {
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return htmlData;
  }

////My Records

  Future<bool> getRecords({int? pageNumber, bool isLoading = false}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getRecords(
          pageNumber: pageNumber ?? 1, pageSize: AppUser.pageSize),
      giveHeader: false,
      onSuccess: (r) {
        debugPrint("---$r");
        if (isLoading) {
          RecordsModel temp = RecordsModel.fromJson(jsonDecode(r));
          recordsModel.hasNext = temp.hasNext;
          recordsModel.currentPage = temp.currentPage;
          (recordsModel.items ?? []).addAll(temp.items ?? []);
        } else {
          recordsModel = RecordsModel.fromJson(jsonDecode(r));
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

  Future<bool> deleteRecord({required int id}) async {
    bool proceed = false;
    await apiRequest.delete(
      url: ApiUrl.deleteRecord(id: id),
      onSuccess: (r) {
        recordsModel.items?.removeWhere((element) => element.id == id);
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        proceed = false;
        ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        notifyListeners();
      },
    );
    notifyListeners();
    return proceed;
  }

  Future<bool> createRecord({required Map? body}) async {
    bool proceed = false;
    await apiRequest.post(
        url: ApiUrl.createRecord,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          recordsModel.items?.add(RecordsItems(
            id: int.parse(jsonDecode(r)["message"]),
            name: body?['name'],
            recordUrl: body?['recordUrl'],
          ));
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> updateRecord({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.createRecord,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          var docToUpdate = recordsModel.items
              ?.firstWhere((element) => element.id == body?['id']);
          docToUpdate?.name = body?['name'];
          docToUpdate?.recordUrl = body?['recordUrl'];
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }
}
