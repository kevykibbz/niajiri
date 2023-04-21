// ignore_for_file: avoid_print

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:Niajiri/Notifications/openedNotification.dart';
import 'package:Niajiri/config/themes.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/no%20internet/no_internet.dart';
import 'package:Niajiri/services/notificationService.dart';
import 'package:provider/provider.dart';
import 'auth/social.dart';
import 'package:Niajiri/firebase/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'splash/splash_screen.dart';
import 'config/config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import "package:flutter/services.dart";
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:location/location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MpesaFlutterPlugin.setConsumerKey(MyConfig.mpesaConsumerKey);
  await MpesaFlutterPlugin.setConsumerSecret(MyConfig.mpesaConsumerSecret);

  final client = StreamChatClient(MyConfig.streamKey);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepository()));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    runApp(RootApp(client: client, appTheme: AppTheme()));
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  final routeName = message.data["route"];
  Get.toNamed(routeName);
  if (routeName != null) {
    Get.toNamed(routeName);
  }
}

class RootApp extends StatefulWidget {
  final StreamChatClient client;
  final AppTheme appTheme;
  const RootApp({
    Key? key,
    required this.client,
    required this.appTheme,
  }) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final user = FirebaseAuth.instance.currentUser;
  final String myAppName = MyConfig.appName;
  final Location location = Location();
  final themedata = GetStorage();
  late StreamSubscription subscription;
  late StreamSubscription locationSubscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  initState() {
    getConnectivity();
    getLocationStatus();
    NotificationApi.init();
    listenNotifications();
    super.initState();

    ///give you message when user taps in terminated state
    _firebaseMessaging.getInitialMessage().then((message) async {
      final routeName = message?.data["route"];
      if (routeName != null) {
        Get.toNamed(routeName);
      }
    });

    //foreground
    FirebaseMessaging.onMessage.listen((message) {
      int badgeCount = int.tryParse(message.data['badge'] ?? '0') ?? 0;
      if (badgeCount > 0) {
        SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
              label: myAppName, primaryColor: Colors.blue.value),
        );
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.blue),
        );
        _setNotificationBadge(badgeCount);
      }
      NotificationApi.showNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          payload: "sarah.abs");
    });

    //background and not terminated and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeName = message.data["route"];
      if (routeName != null) {
        Get.toNamed(routeName);
      }
    });
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen((onClickedNotification));
  }

  void onClickedNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const OpenedNotificationPage()));
  }

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        Get.to(() => const NoConnection());
      } else {
        Get.back();
      }
    });
  }

  void getLocationStatus() {
    if (user != null) {
      locationSubscription =
          location.onLocationChanged.listen((LocationData result) async {
        final PermissionStatus permissionGrantedResult =
            await location.hasPermission();
        final service =await location.serviceEnabled();
        if (permissionGrantedResult != PermissionStatus.granted) {
          await location.requestPermission();
        }
        if(!service){
          await location.requestService();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themedata.read("darkmode") ?? false;
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseMessaging.getToken().then((token) {
      //print("tokennnnnnnnnn:$token");
    });
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: GetMaterialApp(
        title: myAppName,
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? widget.appTheme.dark : widget.appTheme.light,
        darkTheme: widget.appTheme.dark,
        themeMode: ThemeMode.light,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 800),
        home: SplashScreen(myAppName: myAppName),
        builder: (context, child) {
          return StreamChatCore(
            client: widget.client,
            child: child!,
          );
        },
        getPages: [
          GetPage(
              name: "/openedNotification",
              page: () => const OpenedNotificationPage())
        ],
      ),
    );
  }

  showDialogBox() => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("No connection"),
            content: const Text("Please check your internet connectivity"),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() {
                        isAlertSet = true;
                      });
                    }
                  },
                  child: const Text('OK')),
            ],
          ));

  _setNotificationBadge(int badgeCount) async {
    if (badgeCount > 0) {
      await FlutterAppBadger.updateBadgeCount(badgeCount);
    } else {
      await FlutterAppBadger.removeBadge();
    }
  }
}
