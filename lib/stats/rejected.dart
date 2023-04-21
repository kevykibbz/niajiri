import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/skills/select_skill.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/components/nodata.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "package:intl/intl.dart";
import 'package:calendar_time/calendar_time.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';



final user = FirebaseAuth.instance.currentUser;
bool isEmployerType = false;

class Rejected extends StatefulWidget {
  const Rejected({super.key});

  @override
  State<Rejected> createState() => _RejectedState();
}

class _RejectedState extends State<Rejected> {
  final Stream<QuerySnapshot> streamData = FirebaseFirestore.instance
      .collection("proposals")
      .where("Processed", isEqualTo: false)
      .where("Proposed", isEqualTo: true)
      .where("IsRejected", isEqualTo: true)
      .where(user!.uid, isEqualTo: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("/users")
        .doc(user!.uid)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      var role = dataRef['Role'];
      if (role == "Employer") {
        setState(() {
          isEmployerType = true;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isEmployerType ? FadeInDownBig(
          child: FloatingActionButton(
            backgroundColor: AppColors.kPrimaryColor,
            child: const Icon(Ionicons.home_outline, color: Colors.white),
            onPressed: () async{
               final cartList = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .collection("cart")
                    .where("Proposed", isEqualTo: false);
                AggregateQuerySnapshot query = await cartList.count().get();
                if (query.count > 0) {
                  Get.to(()=>const SelectSkillPage());
                } else {
                  Get.to(()=>const DashboardPage());
                }
            }
          ),
      ):null,
      body: StreamBuilder<QuerySnapshot>(
        stream: streamData,
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
            final snap = snapshot.data!.docs;
            if (snap.isEmpty) {
              return Nodata(
                  message: isEmployerType ? "No rejected proposals yet." :  "You havent rejected any proposals yet.");
            }
            return buildList(snap);
          }
        },
      ),
    );
  }

  Widget buildList(List<QueryDocumentSnapshot<Object?>> data) {
    return GroupedListView<dynamic, String>(
      elements: data,
      groupBy: (element) => (CalendarTime(element['Date'].toDate()).isToday
              ? "Today"
              : (CalendarTime(element['Date'].toDate()).isYesterday
                  ? "Yesterday"
                  : DateFormat.MMMMEEEEd().format(element['Date'].toDate())))
          .toUpperCase(),
      groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                groupByValue,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kPrimaryColorTwo,
                ),
              ),
            ),
          ])),
      itemBuilder: (context, dynamic element) {
        return createList(element);
      },
      itemComparator: (item1, item2) => item1['Date']
          .toDate()
          .toString()
          .compareTo(item2['Date'].toDate().toString()), // optional
      useStickyGroupSeparators: true, // optional
      floatingHeader: true, // optional
      order: GroupedListOrder.ASC, // optional
    );
  }

  Widget createList(data) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return FadeInLeftBig(
      child: Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.redAccent,
              icon: Ionicons.trash_bin_outline,
              label: "Delete",
              onPressed: (context) {},
            )
          ],
        ),
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
              backgroundColor: Colors.redAccent,
              icon: Ionicons.trash_bin_outline,
              label: "Delete",
              onPressed: (context) {}),
        ]),
        child: Card(
          elevation: 5.0,
          child: ListTile(
            title: Text(isEmployerType ? data['EmployersFullName'] : data['FullName']),
            subtitle: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(text: data['Reason'],style:TextStyle(color:isDarkMode ?Colors.white:Colors.black)),
                ],
              ),
            ),
            leading:
                CircleAvatar(backgroundColor:AppColors.kPrimaryColorTwo, child: Text(isEmployerType ? data['EmployersFullName'][0].toUpperCase() : data['FullName'][0].toUpperCase(),style:const TextStyle(color:Colors.white)),),
            dense: false,
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.kPrimaryColorTwo.withOpacity(0.2),
              ),
              child: const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                child: Text(
                  "Rejected",
                  style: TextStyle(
                      color: AppColors.kPrimaryColorTwo,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}