// ignore: depend_on_referenced_packages
import 'package:Niajiri/stats/inprogress.dart';
import 'package:Niajiri/stats/rejected.dart';
import 'package:Niajiri/stats/accepted.dart';
import 'package:Niajiri/stats/proposals.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/badge/badge.dart';

final user = FirebaseAuth.instance.currentUser;
int badgeContent = 0;
bool isEmployeeType = false;

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    super.key,
  });

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  List<Tab> tabs = [
    Tab(
      child: Row(
        children: [
          Text(isEmployeeType ? "Received Proposals" : "Sent Proposals"),
          const SizedBox(
            width: 3,
          ),
          CreateBadge(
            badgeContent: badgeContent,
          )
        ],
      ),
    ),
    const Tab(
      child: Text("Accepted Proposals"),
    ),
    const Tab(
      child: Text("Rejected Proposals"),
    ),
    const Tab(
      child: Text("InProgress"),
    ),
  ];

  List<Widget> tabsContent = [
    const ProposalsPage(),
    const Accepted(),
    const Rejected(),
    const InProgress(),
  ];

  getBadgeCount(userId) async {
    final counter = await FirebaseFirestore.instance
        .collection("proposals")
        .where(user!.uid, isEqualTo: true)
        .where("Proposed", isEqualTo: true)
        .snapshots()
        .length;
    setState(() {
      badgeContent = counter;
    });
  }

  @override
  void initState() {
    super.initState();
    getBadgeCount(user!.uid);
    FirebaseFirestore.instance
        .collection("/users")
        .doc(user!.uid)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      var role = dataRef['Role'];
      if (role == "Employee") {
        setState(() {
          isEmployeeType = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Stats"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
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
              tabs: tabs,
            ),
          ),
        ),
        body: TabBarView(
          children: tabsContent,
        ),
      ),
    );
  }
}
