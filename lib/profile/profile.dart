import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/profile/details_page.dart';
import 'package:Niajiri/profile/updateprofile.dart';
import 'package:Niajiri/setting.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';

final user = FirebaseAuth.instance.currentUser!;
bool isEmployee = false;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("/users")
        .doc(user.uid)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      var role = dataRef['Role'];
      if (role == "Employee") {
        setState((){
          isEmployee = true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: grey.withOpacity(0.2),
      body: getBody(context),
      bottomSheet: isEmployee
          ? FadeInUpBig(
            child:SizedBox(
              width: size.width,
              height: 90,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                      width: size.width - 70,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.kPrimaryColor,
                            AppColors.kPrimaryColorTwo
                          ],
                        ),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const DetailsPage());
                          },
                          child: const Text(
                            "VIEW YOUR WORK SKILLS",
                            style: TextStyle(
                                color: white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          : null,
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        width: size.width,
        height: size.height * 0.60,
        decoration: BoxDecoration(
          color: isDarkMode ? black : white,
          boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.1),
              spreadRadius: 10,
              blurRadius: 10,
              // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInUpBig(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(user.photoURL!), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FadeInLeftBig(
                child: Text(
                  user.displayName!,
                  style: TextStyle(
                      color: isDarkMode ? white : black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FadeInRightBig(
                child: Text(
                  user.email!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInLeftBig(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const SettingsPage());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:Border.all(color:AppColors.kPrimaryColorTwo),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withOpacity(0.1),
                                    spreadRadius: 10,
                                    blurRadius: 15,
                                    // changes position of shadow
                                  ),
                                ]),
                            child: const Icon(
                              Ionicons.settings_outline,
                              size: 35,
                              color:AppColors.kPrimaryColorTwo,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "SETTINGS",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? AppColors.kPrimaryColorTwo
                                    : grey.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInDownBig(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 85,
                            height: 85,
                            child: Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.kPrimaryColor,
                                        AppColors.kPrimaryColorTwo
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: grey.withOpacity(0.1),
                                        spreadRadius: 10,
                                        blurRadius: 15,
                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Ionicons.camera_outline,
                                    size: 45,
                                    color: white,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      Get.to(() => const UpdateProfile());
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: grey.withOpacity(0.1),
                                              spreadRadius: 10,
                                              blurRadius: 15,
                                              // changes position of shadow
                                            ),
                                          ]),
                                      child: const Center(
                                        child: Icon(Icons.add,
                                            color: AppColors.kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ADD MEDIA",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? AppColors.kPrimaryColorTwo
                                    : grey.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FadeInRightBig(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => const UpdateProfile());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:!isDarkMode ? Border.all(color:AppColors.kPrimaryColorTwo):null,
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: grey.withOpacity(0.1),
                                    spreadRadius: 10,
                                    blurRadius: 15,
                                    // changes position of shadow
                                  ),
                                ]),
                            child: const Icon(
                              Ionicons.pencil_outline,
                              size: 35,
                              color:AppColors.kPrimaryColorTwo ,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "EDIT INFO",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? AppColors.kPrimaryColorTwo
                                    : grey.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
