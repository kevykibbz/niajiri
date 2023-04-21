// ignore_for_file: use_build_context_synchronously
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:Niajiri/storage/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/components/nodata.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import "dart:math";
import "package:intl/intl.dart";
import "package:calendar_time/calendar_time.dart";

final user = FirebaseAuth.instance.currentUser!;
final themedata = GetStorage();
bool isDarkMode = themedata.read("darkmode") ?? false;
double rating = 0;

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  LikesPageState createState() => LikesPageState();
}

class LikesPageState extends State<LikesPage> {
  bool isEmployee = false;

  String generateRandomString({required int len}) {
    const chars =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    return List.generate(len, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  Future<void> imageSelector(
      {required context,
      required String filePath,
      required String fileName}) async {
    final storage = Storage();
    await FirebaseFirestore.instance
        .collection("/users")
        .doc(user.uid)
        .get()
        .then((value) {
      var t = value.data() as Map;
      rating = double.parse(t["Rating"].toString());
    });

    await storage
        .uploadFile(
      context: context,
      filePath: filePath,
      fileName: fileName,
    )
        .then((value) async {
      final downloadLink = await FirebaseStorage.instance
          .ref("uploads/$fileName")
          .getDownloadURL();
      await FirebaseFirestore.instance.collection("photos").add({
        user.uid: true,
        "UserId": user.uid,
        "Media": downloadLink,
        "Name": user.displayName,
        "Rating": rating,
        "Date": DateTime.now()
      }).then((value) {
        CreateSnackBar.buildSuccessSnackbar(
            context: context,
            message: "Media added successfully.",
            onPress: () {
              Get.back();
            });
      });
    }).onError((error, stackTrace) {
      CreateSnackBar.buildCustomErrorSnackbar(
          context, "Error", "Something went wrong");
    });
  }

  final Stream<QuerySnapshot> mediaStream = FirebaseFirestore.instance
      .collection("photos")
      .where(user.uid, isEqualTo: true)
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
      if (dataRef["Role"] == "Employee") {
        setState(() {
          isEmployee = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isEmployee
          ? FloatingActionButton(
              backgroundColor: AppColors.kPrimaryColor,
              child: const Icon(Ionicons.add, color: Colors.white),
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpeg', 'jpg']);
                if (results == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("No file has been picked"),
                      action: SnackBarAction(
                          label: 'ok',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          }),
                    ),
                  );
                }
                final path = results!.files.single.path;
                final fileName = results.files.single.name;
                imageSelector(
                    context: context,
                    filePath: path as String,
                    fileName: fileName);
              },
            )
          : null,
      body: getBody(),
      bottomSheet: null,
    );
  }

  Widget getBody() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "My Uploads",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.kPrimaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 0.8,
        ),
        StreamBuilder<QuerySnapshot>(
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
                final snap = snapshot.data!.docs;
                if (snap.isEmpty) {
                  return const Nodata(message: "No media found.");
                }
                return buildList(context, snap);
              }
            })
      ],
    );
  }
}

Widget buildList(context, snap) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5),
    child: Wrap(
      spacing: 5,
      runSpacing: 5,
      children: snap.map<Widget>((data) {
        var postedDate = (CalendarTime(data['Date'].toDate()).isToday
            ? "Today"
            : (CalendarTime(data['Date'].toDate()).isYesterday
                ? "Yesterday"
                : DateFormat.MMMMEEEEd().format(data['Date'].toDate())));
        return SizedBox(
          width: (size.width - 15) / 2,
          height: 250,
          child: Stack(
            children: [
              SizedBox(
                width: (size.width - 15) / 2,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: data['Media']!,
                  ),
                ),
              ),
              Container(
                width: (size.width - 15) / 2,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    black.withOpacity(0.25),
                    black.withOpacity(0),
                  ], end: Alignment.topCenter, begin: Alignment.bottomCenter),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: green, shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: postedDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
            ],
          ),
        );
      }).toList(),
    ),
  );
}
