


import '../constant/app_user.dart';

class MyHeaders {
  static Map<String, String> header({bool? giveHeader = true}) {
    return {
      'Content-Type': 'application/json',
      "Authorization": giveHeader! ? "Bearer ${AppUser.login.token}" : "",
    };
  }
}
