import 'package:Niajiri/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Niajiri/Welcome/components/background.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'components/welcome_image.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/mixins/shutdown.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/config/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FadeInLeft(
                  child: const Expanded(
                    child: WelcomeImage(),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 450,
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: Column(
                            children: <Widget>[
                              FadeInLeftBig(
                                child: Hero(
                                  tag: "get_started_btn",
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AuthRepository.instance.checkUserStatus();
                                    },
                                    child: Text(
                                      "GET STARTED".toUpperCase(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: const MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatefulWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileWelcomeScreen> createState() => _MobileWelcomeScreenState();
}

class _MobileWelcomeScreenState extends State<MobileWelcomeScreen>
    with AppCloser {
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Icon(
                          Ionicons.warning_outline,
                          size: 20,
                          color: AppColors.kPrimaryColorTwo,
                        ),
                        Expanded(child: Text("Warning")),
                      ]),
                  content: const Text('Do you wish to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        closeApp();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: AppColors.kPrimaryColorTwo),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No',
                            style:
                                TextStyle(color: AppColors.kPrimaryColorTwo))),
                  ]);
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const WelcomeImage(),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        CustomBtn(
                            label: 'get started'.toUpperCase(),
                            tag: "get_started_btn",
                            onPressed: () {
                              FirebaseAuth.instance.currentUser == null
                                  ? Get.offAll(() => const DashboardPage())
                                  : AuthRepository.instance.checkUserStatus();
                            }),
                        const SizedBox(height: 10),
                      ],
                    )),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
