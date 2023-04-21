// ignore: depend_on_referenced_packages
import "package:intl/intl.dart";
import 'package:Niajiri/components/nodata.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/skills/selected_skill.dart';
import 'package:animate_do/animate_do.dart';
import 'package:calendar_time/calendar_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

final user = FirebaseAuth.instance.currentUser!;
bool isSelected = false;
int counter = 0;

class SelectSkillPage extends StatefulWidget {
  const SelectSkillPage({super.key});

  @override
  SelectSkillPageState createState() => SelectSkillPageState();
}

class SelectSkillPageState extends State<SelectSkillPage> {
  final Stream<QuerySnapshot> myOptionsStream = FirebaseFirestore.instance
      .collection("/users")
      .doc(user.uid)
      .collection("cart")
      .where("Proposed", isEqualTo: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeInDownBig(
        child: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          child: const Icon(Ionicons.home_outline, color: Colors.white),
          onPressed: () {
            Get.to(() => const DashboardPage());
          },
        ),
      ),
      appBar: AppBar(
        title: const Text('Select option.'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: myOptionsStream,
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
                return const Nodata(message: "Cart is empty for now.");
              }
              return buildList(snap);
            }
          },
        ),
      ),
    );
  }

}

Widget buildList(data) {
  return ListView.builder(
    itemCount: data.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      var docId = data[index].reference.id.toString();
      var postedDate = (CalendarTime(data[index]['Date'].toDate()).isToday
          ? "Today"
          : (CalendarTime(data[index]['Date'].toDate()).isYesterday
              ? "Yesterday"
              : DateFormat.MMMMEEEEd().format(data[index]['Date'].toDate())));
      return FadeInLeftBig(
        child: Slidable(
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                backgroundColor: AppColors.kPrimaryColorTwo,
                icon: Ionicons.checkmark,
                label: "Select",
                onPressed: (context) {
                  Get.to(() => SelectedSkillPage(
                        employeeId:data[index]['EmployeeIdId'],
                        docId:docId
                      ));
                },
              )
            ],
          ),
          endActionPane: ActionPane(motion: const StretchMotion(), children: [
            SlidableAction(
                backgroundColor: AppColors.kPrimaryColorTwo,
                icon: Ionicons.checkmark,
                label: "Select",
                onPressed: (context) {
                  Get.to(() => SelectedSkillPage(
                        employeeId:data[index]['EmployeeIdId'],
                        docId:docId
                      ));
                }),
          ]),
          child: Card(
            elevation: 5.0,
            child: ListTile(
              title: Text(data[index]['FullName']),
              subtitle: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children:[
                    const TextSpan(text:"Selected "),
                    TextSpan(text:postedDate,style:const TextStyle(color:AppColors.kPrimaryColorTwo))
                  ],
                ),
              ),
              leading: CircleAvatar(
                  child: Text(data[index]['FullName'][0].toUpperCase()),),
              dense: false,
              trailing: IconButton(
                onPressed: () {
                  Get.to(() => SelectedSkillPage(
                        employeeId:data[index]['EmployeeIdId'],
                        docId:docId
                      ));
                },
                icon: const Icon(Ionicons.arrow_forward_outline,
                    size: 24.0, color: AppColors.kPrimaryColorTwo),
              ),
            ),
          ),
        ),
      );
    },
  );
}
