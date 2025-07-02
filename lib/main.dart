import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:regcard/resources/resources.dart';
import 'package:regcard/routes/app_routes.dart';
import 'package:regcard/services/hive_db.dart';
import 'package:regcard/src/auth/view_model/auth_vm.dart';
import 'package:regcard/src/base/view/explore/view_model/expense_vm.dart';
import 'package:regcard/src/base/view/home/view_model/home_vm.dart';
import 'package:regcard/src/base/view/my_regcard/view_model/my_reg_card_vm.dart';
import 'package:regcard/src/base/view/settings/view_model/settings_vm.dart';
import 'package:regcard/src/base/view_model/base_vm.dart';
import 'package:regcard/src/landing/view/splash_view.dart';
import 'package:regcard/utils/bot_toast/zbot_toast.dart';
import 'package:regcard/utils/localization_extension.dart';
import 'package:regcard/utils/widgets/no_internet_screen.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAhuHjlouyEIbzfh1Q297HoWKOiZS0vh-4",
            appId: "1:216532796630:android:c075743eaff818942e3577",
            messagingSenderId: "216532796630",
            projectId: "reg-card"));
  } else {
    await Firebase.initializeApp();
  }
  await HiveDb.openHiveBox("user");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: R.colors.primaryColor));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthVm()),
    ChangeNotifierProvider(create: (context) => BaseVm()),
    ChangeNotifierProvider(create: (context) => HomeVm()),
    ChangeNotifierProvider(create: (context) => SettingsVm()),
    ChangeNotifierProvider(create: (context) => ExpenseVm()),
    ChangeNotifierProvider(create: (context) => MyRegCardVm()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          title: 'Regcard',
          builder: BotToastInit(),
          theme: ThemeData(
              splashColor: Colors.transparent,
              appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
              highlightColor: Colors.transparent,
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: R.colors.primaryColor,
                  selectionHandleColor: R.colors.primaryColor,
                  selectionColor: R.colors.primaryColor)),
          // Provide light theme.
          navigatorObservers: [BotToastNavigatorObserver()],

          fallbackLocale: const Locale('en', 'US'),

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en', 'US'),
          ],
          localeResolutionCallback:
              (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale?.languageCode &&
                  locale.countryCode == deviceLocale?.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: false,
          getPages: AppRoutes.pages,
          initialRoute: SplashView.route,
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      startConnectionStream();
    });
    super.initState();
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    switch (result.first) {
      case ConnectivityResult.wifi:
        {
          debugPrint(result.toString());
        }
        break;
      case ConnectivityResult.mobile:
        {
          debugPrint(result.toString());
        }
        break;
      case ConnectivityResult.none:
        {
          ZBotToast.showToastError(message: "no_internet_connection".L());
          Get.to(const NoInternetScreen());
        }
        break;
      default:
        break;
    }
  }

  void startConnectionStream() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
}
