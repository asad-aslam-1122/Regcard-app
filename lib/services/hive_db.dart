import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constant/enums.dart';
import '../src/auth/model/login_model.dart';


class HiveDb
{
static final _hive = Hive.box("user");

static Future<void> setLoginData(LoginModel loginData) async {
  _hive.put(HiveKeys.user, jsonEncode(loginData.toJson()));
}
static Future<LoginModel?> getLoginData() async {
  String? data = _hive.get(HiveKeys.user);
  log("this is login Data ${data.toString()}");
  if (data != null) {
    return LoginModel.fromJson(jsonDecode(data));
  } else {
    return null;
  }
}

static deleteData() {
  _hive.delete(HiveKeys.user);
}

static Future<Box> openHiveBox(String boxName) async {
  if (!Hive.isBoxOpen(boxName)) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return await Hive.openBox(boxName);
}

}
class HiveKeys {
  static int user = HiveKeysEnum.authUser.index;
  static int bearer = HiveKeysEnum.bearer.index;
}