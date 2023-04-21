import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/skills/new_skill.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

final user = FirebaseAuth.instance.currentUser!;
String location = "No location found";
String bio = '';
double rating = 0.0;

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  final Stream<QuerySnapshot> skillsStream = FirebaseFirestore.instance
      .collection("/users")
      .doc(user.uid)
      .collection("skilss")
      .snapshots();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
      .collection("/users")
      .doc(user.uid)
      .get()
      .then((value) {
      var dataRef = value.data() as Map;
      setState(() {
        location = dataRef['Location'] ?? "No location found";
        bio = dataRef['Bio'];
        rating =double.parse(dataRef["Rating"].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                //backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height * 0.60,
                floating: true,
                pinned: true,
                snap: true,
                collapsedHeight: 116,
                actionsIconTheme: const IconThemeData(opacity: 0.0),
                toolbarHeight: 56,
                titleSpacing: 0,
                centerTitle: false,
                leading: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(0),
                  title: Container(
                    height: 67,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                FadeInLeftBig(
                                  child: Text(
                                    user.displayName!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      const Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            FadeInRightBig(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.kPrimaryColorTwo,
                                    size: 14,
                                  ),
                                  Text(
                                    '$location . 25km',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 34,
                          width: 34,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimaryColorTwo,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Container(
                                height: 18,
                                width: 18,
                                color: Colors.white,
                              ),
                              Center(
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  background: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 86),
                            child: FadeInImage.assetNetwork(
                              placeholder:"assets/images/placeholder.png",
                              image:user.photoURL!,
                              fit:BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 32,
                      endIndent: 32,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          FadeInLeftBig(
                            child: const Text(
                              'Skills',
                              style: TextStyle(
                                color: AppColors.kPrimaryColorTwo,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                            color: AppColors.kPrimaryColorTwo,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Flexible(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: skillsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor:AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Something went wrong"),
                                );
                              } else {
                                final snap = snapshot.data!.docs;
                                if (snap.isEmpty) {
                                  return const Text("No skills found.",
                                      style: TextStyle(color: Colors.black));
                                }
                                return generateList(context, snap);
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUpBig(
                        child: const Text(
                          "Bio",
                          style: TextStyle(
                              color: AppColors.kPrimaryColorTwo,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      FadeInLeftBig(
                        child: Text(
                          bio,
                          style: TextStyle(
                            color: Colors.grey[600],
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 800),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDownBig(
                    child: Container(
                      height: 64,
                      width: 64,
                      margin: const EdgeInsets.fromLTRB(16, 16, 10, 16),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColorTwo,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => const NewSkillScreen());
                        },
                        icon: const Icon(
                          Ionicons.pencil,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget generateList(context, data) {
  return FadeInLeftBig(
    child: ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.kPrimaryColorTwo.withOpacity(0.2),
                child: Text((index + 1).toString(),
                    style: const TextStyle(color: AppColors.kPrimaryColorTwo)),
              ),
              const SizedBox(width: 5),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                width: MediaQuery.of(context).size.width * 0.72,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColorTwo.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      "${data[index]["SkillName"]}/${data[index]["Payment"]}",
                      style: const TextStyle(
                        color: AppColors.kPrimaryColorTwo,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider()
            ],
          ),
        );
      },
    ),
  );
}
