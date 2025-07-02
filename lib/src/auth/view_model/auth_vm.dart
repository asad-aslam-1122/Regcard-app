import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/services/hive_db.dart';
import 'package:regcard/src/auth/model/login_model.dart';
import 'package:regcard/src/auth/model/new_document_model.dart';
import 'package:regcard/src/auth/model/personalizationOptions.dart';
import 'package:regcard/src/base/model/temp_list_model.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/utils/localization_extension.dart';

import '../../../constant/api_urls.dart';
import '../../../constant/app_user.dart';
import '../../../constant/enums.dart';
import '../../../services/api_service.dart';
import '../../../utils/bot_toast/zbot_toast.dart';
import '../model/profile_forms_model.dart';
import '../view/login_view.dart';

class AuthVm extends ChangeNotifier {
  ApiRequest apiRequest = ApiRequest();
  PageController completeProfilePageController = PageController();
  int completeProfilePageIndex = 0;
  int selectedLanguage = 0;
  List<NewDocumentModel> tempList = [];
  List<TempModel> tempDocList = [];
  // List<DocumentModel> myDocuments = [];
  // List<MemberDocumentModel> familyDocuments = [];
  // List<DocumentModel> additionalDocuments = [];
  List<NewDocumentModel> docViewsList = [];
  List<NewDocumentModel> familyDocsList = [];
  List<NewDocumentModel> allDocList = [];
  PersonalizationOptions personalizationOptions = PersonalizationOptions();
  List<PersonalizationOptions> personalizationType0 = [];
  List<PersonalizationOptions> personalizationType1 = [];
  List<PersonalizationOptions> personalizationType2 = [];
  List<PersonalizationOptions> personalizationType3 = [];
  void update() {
    notifyListeners();
  }

  bool isChecked = false;

/////Authentication

  void clearPersonalizedList() {
    personalizationType0.clear();
    personalizationType1.clear();
    personalizationType2.clear();
    personalizationType3.clear();
    notifyListeners();
  }

  Future<bool> signUp({required Map? body}) async {
    log("req body : $body");
    bool proceed = false;
    await apiRequest.post(
        url: ApiUrl.signUp,
        giveHeader: false,
        body: body,
        onSuccess: (r) async {
          debugPrint("---$r");
          ZBotToast.showToastSuccess(message: jsonDecode(r)["message"]);
          // AppUser.auth = LoginData.fromJson(jsonDecode(r));
          // HiveDb.setLoginData(LoginData.fromJson(jsonDecode(r)));
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> login({required Map? body}) async {
    bool proceed = false;
    print("login body : $body");
    await apiRequest.post(
      url: ApiUrl.login,
      giveHeader: false,
      body: body,
      onSuccess: (r) async {
        debugPrint("---$r");
        AppUser.login = LoginModel.fromJson(jsonDecode(r));
        HiveDb.setLoginData(LoginModel.fromJson(jsonDecode(r)));
        // await Provider.of<BaseVm>(Get.context!, listen: false).getProfile();
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

  Future<bool> otpGenerate({required Map? body}) async {
    bool proceed = false;
    await apiRequest.post(
        url: ApiUrl.otpGenerate,
        giveHeader: false,
        body: body,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          ZBotToast.showToastError(message: jsonDecode(r)["message"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> otpVerify({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.verifyAccount,
        body: body,
        giveHeader: false,
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

  Future<bool> resetPass({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.resetPass,
        body: body,
        giveHeader: false,
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

  Future<bool> logout() async {
    bool proceed = false;
    await apiRequest.put(
      url: ApiUrl.logout,
      giveHeader: true,
      onSuccess: (r) async {
        debugPrint("---$r");
        AppUser.login = LoginModel();
        await HiveDb.deleteData();
        clearPersonalizedList();
        Get.offAllNamed(LoginView.route);
        ZBotToast.showToastSuccess(message: "logout_successfully".L());
        Get.context!.read<BaseVm>().baseSelectedIndex = 1;
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        proceed = false;
        notifyListeners();
        // ZBotToast.showToastError(message: jsonDecode(r)["message"]);
      },
    );
    notifyListeners();
    return proceed;
  }

  //// Complete Profile Forms
  Future<bool> form1({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form1,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["title"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> form2({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form2,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          debugPrint("---$r");
          proceed = true;
          notifyListeners();
        },
        onError: (r) {
          proceed = false;
          ZBotToast.showToastError(message: jsonDecode(r)["title"]);
        });
    notifyListeners();
    return proceed;
  }

  Future<bool> form3({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form3,
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

  Future<bool> form4({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form4,
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

  Future<bool> form5({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form5,
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

  Future<bool> form6({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form6,
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

  Future<bool> form7({required Map? body}) async {
    bool proceed = false;
    await apiRequest.put(
        url: ApiUrl.form7,
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

  Future<void> updateFCM() async {
    AppUser.fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    log("FcmToken: ${AppUser.fcmToken}");
  }

  Future<bool> skipForm({required int? id}) async {
    bool proceed = false;
    String url = '';
    Map<String, dynamic> body = {};

    switch (id) {
      case 1:
        AppUser.profileForms.step1 = Step1.fromJson(body);
        url = ApiUrl.form1;
        body = {"city": '', "country": ''};
        break;
      case 2:
        AppUser.profileForms.step2 = Step2.fromJson(body);
        url = ApiUrl.form2;
        body = {"workPosition": '', "company": ''};
        break;
      case 3:
        AppUser.profileForms.step3 = Step3.fromJson(body);
        url = ApiUrl.form3;
        body = {'kids': [], 'pets': []};
        break;
      case 4:
        AppUser.profileForms.step4 = Step4.fromJson(body);
        url = ApiUrl.form4;
        body = {'allergies': []};
        break;
      case 5:
        AppUser.profileForms.step5 = Step5.fromJson(body);
        url = ApiUrl.form5;
        body = {'foodPersonalityIds': []};
        break;
      case 6:
        AppUser.profileForms.step6 = Step6.fromJson(body);
        url = ApiUrl.form6;
        body = {'gastronomyTypeIds': [], 'restaurantTypeIds': []};
        break;
      case 7:
        url = ApiUrl.form7;
        body = {'activityTypeIds': []};
        break;
    }

    await apiRequest.put(
      url: url,
      body: body,
      giveHeader: true,
      onSuccess: (r) async {
        debugPrint("---$r");
        proceed = true;
        notifyListeners();
      },
      onError: (r) {
        proceed = false;
        ZBotToast.showToastError(message: jsonDecode(r)["title"]);
      },
    );

    notifyListeners();
    return proceed;
  }

  Future<bool> getPersonalizationOptions({int? id}) async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.getPersonalizationOptions(id: id ?? 0),
      giveHeader: true,
      onSuccess: (r) {
        for (var element in jsonDecode(r) as List) {
          personalizationOptions = PersonalizationOptions.fromJson(element);
          if (id == 0) {
            personalizationType0.add(personalizationOptions);
          } else if (id == 1) {
            personalizationType1.add(personalizationOptions);
          } else if (id == 2) {
            personalizationType2.add(personalizationOptions);
          } else {
            personalizationType3.add(personalizationOptions);
          }
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

  Future<bool> getProfileWithSteps() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.profileWithSteps,
      giveHeader: true,
      onSuccess: (r) {
        debugPrint("---$r");
        AppUser.profileForms = ProfileFormsModel.fromJson(jsonDecode(r));
        AppUser.userProfile?.id = AppUser.profileForms.id;
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

  //// Upload File
  Future<String> uploadImageUrl(File? profileImage) async {
    return await apiRequest.multipartPost(
        url: ApiUrl.uploadFile, inputFile: profileImage ?? File(""));
  }

  Future<bool> uploadDocument(
      {required Map? body,
      bool changeDocs = true,
      bool changeFamilyDocs = true}) async {
    bool proceed = false;
    log("body : $body");
    await apiRequest.post(
        url: ApiUrl.documents,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          allDocList.add(NewDocumentModel(
            id: int.parse(jsonDecode(r)["message"]),
            documentType: DocumentType.values[body?['documentType']],
            name: body?['name'],
            documentUrl: body?['documentUrl'],
            familyMember: body?['familyMember'],
          ));
          if (changeDocs) {
            docViewsList.add(NewDocumentModel(
              id: int.parse(jsonDecode(r)["message"]),
              documentType: DocumentType.values[body?['documentType']],
              name: body?['name'],
              documentUrl: body?['documentUrl'],
              familyMember: body?['familyMember'],
            ));
          }
          if (changeFamilyDocs) {
            familyDocsList.add(NewDocumentModel(
              id: int.parse(jsonDecode(r)["message"]),
              documentType: DocumentType.values[body?['documentType']],
              name: body?['name'],
              documentUrl: body?['documentUrl'],
              familyMember: body?['familyMember'],
            ));
          }
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

  Future<bool> updateDocument(
      {required Map? body,
      bool changeDocs = true,
      bool changeFamilyDocs = true}) async {
    bool proceed = false;
    log("body : $body");
    await apiRequest.put(
        url: ApiUrl.documents,
        body: body,
        giveHeader: true,
        onSuccess: (r) async {
          var docToUpdate =
              allDocList.firstWhere((element) => element.id == body?['id']);
          docToUpdate.name = body?['name'];
          docToUpdate.documentUrl = body?['documentUrl'];
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

  Future<bool> getDocument() async {
    bool proceed = false;
    await apiRequest.get(
      url: ApiUrl.documents,
      giveHeader: true,
      onSuccess: (r) {
        allDocList.clear();
        for (var element in jsonDecode(r) as List) {
          NewDocumentModel doc = NewDocumentModel.fromJson(element);
          allDocList.add(doc);
        }
        debugPrint("---$r");
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

  Future<bool> deleteDocument(
      {required int id,
      bool changeDocs = true,
      bool changeFamilyDocs = true}) async {
    bool proceed = false;
    await apiRequest.delete(
      url: ApiUrl.deleteDocument(id: id),
      giveHeader: true,
      onSuccess: (r) {
        allDocList.removeWhere((element) => element.id == id);
        if (changeDocs) {
          docViewsList.removeWhere((element) => element.id == id);
        }
        if (changeFamilyDocs) {
          familyDocsList.removeWhere((element) => element.id == id);
        }
        debugPrint("---$r");
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
}
