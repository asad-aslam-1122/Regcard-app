import 'package:regcard/src/auth/model/new_document_model.dart';
import 'package:regcard/src/auth/model/profile_forms_model.dart';

import '../src/auth/model/login_model.dart';
import '../src/auth/model/user_profile.dart';

class AppUser {
  static LoginModel login = LoginModel();
  static ProfileFormsModel profileForms = ProfileFormsModel();
  static UserProfile? userProfile = UserProfile();
  static NewDocumentModel? docModel = NewDocumentModel();
  static String url = '';
  static String appVersion = '1.0.0+1';
  static String v1 = '1.0.0';
  static int pageSize = 20;
  static String fcmToken = '';
}
