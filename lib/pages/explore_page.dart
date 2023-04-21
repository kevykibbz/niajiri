// ignore_for_file: avoid_print

import 'package:Niajiri/Notifications/notifications.dart';
import 'package:Niajiri/auth/components/bottomsheetbtn.dart';
import 'package:Niajiri/auth/login.dart';
import 'package:Niajiri/components/nodata.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/wallet/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:Niajiri/profile/more_details.dart';
import 'package:Niajiri/skills/select_skill.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:floating_draggable_widget/floating_draggable_widget.dart";
import 'package:ionicons/ionicons.dart';
import 'package:badges/badges.dart' as badges;

bool messageCounter = true;
bool isEmployer = false;
bool isLoggedIn = false;
List skills = [];
final user = FirebaseAuth.instance.currentUser;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  int cartCounter = 0;
  final List<SwipeItem> swipeItems = [];
  late MatchEngine _matchEngine;
  final Stream<QuerySnapshot> mediaStream =
      FirebaseFirestore.instance.collection("photos").snapshots();

  final Stream<QuerySnapshot> cartStreamData = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("cart")
      .where("Proposed", isEqualTo: false)
      .snapshots();
  // cartStreamData.listen((event){
  //   if(event.docs.isEmpty){
  //     return;
  //   }
  // });
  @override
  initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection("/users")
          .doc(user!.uid)
          .get()
          .then((value) {
        var dataRef = value.data() as Map;
        setState(() {
          if (dataRef["Role"] == "Employer") {
            isEmployer = true;
          }
        });
      });
      setState(() {
        isLoggedIn = true;
      });
    }
    _matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn && isEmployer) {
      return employersScaffold();
    } else {
      return generalScaffold();
    }
  }

  Widget employersScaffold() {
    return FloatingDraggableWidget(
      autoAlign: true,
      dx: 200,
      dy: 300,
      mainScreenWidget: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: mediaStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Nodata(message: "No media found.");
              }
              documents.map((doc) {
                return swipeItems.add(SwipeItem(
                  content: Content(
                      name: doc["Name"],
                      rating: doc["Rating"],
                      media: doc["Media"],
                      userId: doc["UserId"]),
                  likeAction: () {
                    if (user != null && isEmployer) {
                      AuthRepository.instance.addCart(
                          context: context,
                          fullName: doc["Name"],
                          employeeId: doc["UserId"]);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Liked ${doc["Name"]}"),
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    }
                  },
                  nopeAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Nope ${doc["Name"]}"),
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  onSlideUpdate: (SlideRegion? region) async {
                    print("Region $region");
                  },
                ));
              }).toList();
              return getBody(context, swipeItems);
            }
          },
        ),
        bottomSheet: getBottomSheet(),
      ),
      floatingWidget: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -10, end: -12),
        showBadge: true,
        ignorePointer: false,
        badgeContent: getBadgeCount(),
        badgeStyle: badges.BadgeStyle(
          elevation: 2,
          badgeColor: Colors.redAccent,
          shape: badges.BadgeShape.circle,
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 2,
          ),
          borderGradient: const badges.BadgeGradient.linear(
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kPrimaryColorTwo,
            ],
          ),
          badgeGradient: const badges.BadgeGradient.linear(
            colors: [AppColors.kPrimaryColor, AppColors.kPrimaryColorTwo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColorTwo,
          onPressed: () {
            if (user != null) {
              Get.to(() => const SelectSkillPage());
            }
          },
          tooltip: "cart",
          child: const Icon(
            Ionicons.cart_outline,
            color: Colors.white,
          ),
        ),
      ),
      floatingWidgetHeight: 50,
      floatingWidgetWidth: 50,
    );
  }

  Widget getBadgeCount() {
    if (user != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: cartStreamData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("0", style: TextStyle(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Text("0", style: TextStyle(color: Colors.white));
          } else {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Text(documents.length.toString());
          }
        },
      );
    } else {
      return const Text("0", style: TextStyle(color: Colors.white));
    }
  }

  Widget generalScaffold() {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: mediaStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return const Nodata(message: "No media found.");
            }
            documents.map((doc) {
              return swipeItems.add(SwipeItem(
                content: Content(
                    name: doc["Name"],
                    rating: doc["Rating"],
                    media: doc["Media"],
                    userId: doc["UserId"]),
                likeAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Liked client(${doc["Name"]})"),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                nopeAction: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Noped client (${doc["Name"]})"),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
                },
              ));
            }).toList();
            return getBody(context, swipeItems);
          }
        },
      ),
      bottomSheet: getBottomSheet(),
    );
  }

  Widget getBody(context, swipeItems) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.65,
              child: SwipeCards(
                likeTag: const Text("Add cart"),
                nopeTag: const Text("Nope"),
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => MoreDetailsPage(
                          employeeId: swipeItems[index].content.userId));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              width: size.width,
                              height: size.height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        swipeItems[index].content.media),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              width: size.width,
                              height: size.height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    black.withOpacity(0.4),
                                    black.withOpacity(0),
                                  ],
                                  end: Alignment.topCenter,
                                  begin: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.90,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    swipeItems[index]
                                                        .content
                                                        .name,
                                                    style: const TextStyle(
                                                        color: white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    swipeItems[index]
                                                        .content
                                                        .rating
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: white,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Ionicons
                                                        .information_circle_outline,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              createSkillList(swipeItems[index]
                                                  .content
                                                  .userId)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onStackFinished: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Thats all we have for now"),
                    duration: Duration(milliseconds: 500),
                  ));
                },
                itemChanged: (SwipeItem item, int index) {
                  print("item: ${item.content.name}, index: $index");
                },
                upSwipeAllowed: true,
                fillSpace: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBottomSheet() {
    var size = MediaQuery.of(context).size;
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return Container(
      width: size.width,
      height: 120,
      decoration: BoxDecoration(
          color: isDarkMode ? Colors.black.withOpacity(0.0) : white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomSheetBtn(
              color: Colors.red,
              icon: Ionicons.close,
              size: 58,
              onPress: () {
                print("hello world");
                _matchEngine.currentItem?.nope();
              },
              iconSize: 40,
            ),
            BottomSheetBtn(
              color: Colors.blue,
              icon: Ionicons.notifications_outline,
              isNotificationIcon: true,
              iconSize: 25,
              size: 45,
              onPress: () {
                if (isLoggedIn) {
                  Get.to(() => const NotificationScreen());
                } else {
                  Get.to(() => const LoginScreen());
                }
              },
            ),
            BottomSheetBtn(
              color: AppColors.kPrimaryColorTwo,
              icon: Ionicons.shield_checkmark_outline,
              iconSize: 25,
              size: 45,
              onPress: () {
                if (isLoggedIn) {
                  Get.to(() => const WalletPage());
                } else {
                  Get.to(() => const LoginScreen());
                }
              },
            ),
            BottomSheetBtn(
              color: Colors.green,
              icon: Ionicons.checkmark,
              iconSize: 40,
              size: 58,
              onPress: () {
                _matchEngine.currentItem?.like();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createSkillList(employeeId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(employeeId)
          .collection("skilss")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("loading skills...", style: TextStyle(color: Colors.white))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else {
          List<DocumentSnapshot> skills = snapshot.data!.docs;
          List skillsSet = [];
          String skillsString = '';
          if (skills.isEmpty) {
            return const Text("No skills found");
          }
          skills.map((value) {
            return skillsSet.add(value['SkillName']);
          }).toList();
          skillsString = skillsSet.join(",");
          return buildSkillList(skillsString);
        }
      },
    );
  }
}

class Content {
  final String name;
  final String userId;
  final String media;
  final double rating;

  Content(
      {required this.name,
      required this.rating,
      required this.userId,
      required this.media});
}

Widget buildSkillList(skillsString) {
  return Wrap(
    alignment: WrapAlignment.spaceBetween,
    direction: Axis.horizontal,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.kPrimaryColorTwo.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3, bottom: 8, left: 10, right: 10),
                child: Text(
                  skillsString,
                  style: const TextStyle(
                      color: AppColors.kPrimaryColorTwo,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}
