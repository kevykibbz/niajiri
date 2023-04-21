import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:Niajiri/boarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final String myAppName;
  const SplashScreen({Key? key, required this.myAppName}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset("assets/images/splash.json",
              width: 300, controller: _controller, onLoaded: (compos) {
            _controller
              ..duration = compos.duration
              ..forward().then(
                (value) {
                  _controller
                    ..duration = compos.duration
                    ..reverse().then(
                      (value) {
                        Get.to(() => const BoardingScreen());
                      },
                    );
                },
              );
          }),
          Center(
            child: Text(
              widget.myAppName,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.purple,
                fontSize: 50,
                letterSpacing: 1.8,
                fontFamily: "kids_club",
                fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
