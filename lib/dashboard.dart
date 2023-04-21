// ignore_for_file: avoid_print, unused_local_variable

import 'package:Niajiri/auth/login.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Niajiri/mixins/shutdown.dart';
import 'package:Niajiri/pages/explore_page.dart';
import 'package:Niajiri/history.dart';
import 'package:Niajiri/pages/likes_page.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';

bool isloading = false;
bool isNotified = true;
bool isEmployee = false;
var currentIndex = 0;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AppCloser {
  final Location location = Location();
  late PermissionStatus _permissionGranted;
  final user = FirebaseAuth.instance.currentUser;

  List<Tab> employeeTabs = [
    const Tab(
      child: Icon(Ionicons.home_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.cloud_upload_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.time_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.person_outline, size: 25),
    ),
  ];

  List<Tab> nonEmployeeTabs = [
    const Tab(
      child: Icon(Ionicons.home_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.time_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.person_outline, size: 25),
    ),
  ];

  List<Tab> anonymousTabs = [
    const Tab(
      child: Icon(Ionicons.home_outline, size: 25),
    ),
    const Tab(
      child: Icon(Ionicons.log_in_outline, size: 25),
    ),
  ];

  List<Widget> employeeTabContent = [
    const ExplorePage(),
    const LikesPage(),
    const HistoryScreen(),
    const AccountPage()
  ];

  List<Widget> nonEmployeeTabContent = [
    const ExplorePage(),
    const HistoryScreen(),
    const AccountPage()
  ];

  List<Widget> anonymousTabContent = const [
    ExplorePage(),
    LoginPage(),
  ];

  @override
  void initState() {
    super.initState();
    if (user != null) {
      checkLocationPermission();
      FirebaseFirestore.instance
          .collection("/users")
          .doc(user!.uid)
          .get()
          .then((value) {
        var dataRef = value.data() as Map;
        if (dataRef["Role"] == "Employee") {
          setState(() {
            isEmployee = true;
          });
        }
      });
    }
  }

  Future<void> checkLocationPermission() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> requestLocationPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return WillPopScope(
      child: DefaultTabController(
        length: user != null
            ? (isEmployee ? employeeTabs.length : nonEmployeeTabs.length)
            : anonymousTabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: TabBar(
                  labelPadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  indicatorColor: AppColors.kPrimaryColor,
                  labelColor: AppColors.kPrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 2,
                  isScrollable: true,
                  tabs: user != null
                      ? (isEmployee ? employeeTabs : nonEmployeeTabs)
                      : anonymousTabs),
            ),
          ),
          body: TabBarView(
              children: user != null
                  ? (isEmployee ? employeeTabContent : nonEmployeeTabContent)
                  : anonymousTabContent),
        ),
      ),
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
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             FadeInUpBig(child: SvgPicture.asset("assets/images/icons/login.svg"),),
              const Spacer(),
              FadeInLeftBig(
                child: const Text("You have not logged in.",
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              FadeInRightBig(
                child: CustomBtn(
                    label: 'Login'.toUpperCase(),
                    tag: "Login_btn",
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
