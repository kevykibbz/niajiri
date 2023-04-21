import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/stats.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:Niajiri/stats/completed.dart';
import 'package:badges/badges.dart' as badges;

final user = FirebaseAuth.instance.currentUser!;
int totalStats = 0;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  getTotalStats() async {
    final acceptedProposals = await FirebaseFirestore.instance
        .collection("proposals")
        .where("Processed", isEqualTo: false)
        .where("Proposed", isEqualTo: true)
        .where("IsAccepted", isEqualTo: true)
        .where("InProgress", isEqualTo: false)
        .where(user.uid, isEqualTo: true)
        .snapshots()
        .length;
    final proposals = await FirebaseFirestore.instance
        .collection("proposals")
        .where("Processed", isEqualTo: false)
        .where("Proposed", isEqualTo: true)
        .where(user.uid, isEqualTo: true)
        .where("IsAccepted", isEqualTo: false)
        .where("InProgress", isEqualTo: false)
        .where("IsRejected", isEqualTo: false)
        .snapshots()
        .length;
    final rejectedProposals = await FirebaseFirestore.instance
        .collection("proposals")
        .where("Processed", isEqualTo: false)
        .where("Proposed", isEqualTo: true)
        .where("IsRejected", isEqualTo: true)
        .where("InProgress", isEqualTo: false)
        .where(user.uid, isEqualTo: true)
        .snapshots()
        .length;
    final inProgressProposals = await FirebaseFirestore.instance
        .collection("proposals")
        .where("Processed", isEqualTo: false)
        .where("Proposed", isEqualTo: true)
        .where("InProgress", isEqualTo: true)
        .where("IsAccepted", isEqualTo: true)
        .where(user.uid, isEqualTo: true)
        .snapshots()
        .length;
    setState(() {
      totalStats = acceptedProposals +
          proposals +
          rejectedProposals +
          inProgressProposals;
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeInDownBig(
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: -12),
          showBadge: true,
          ignorePointer: false,
          badgeContent: Text(totalStats.toString(),
              style: const TextStyle(color: Colors.white)),
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
            backgroundColor: AppColors.kPrimaryColor,
            child: const Icon(Ionicons.time_outline, color: Colors.white),
            onPressed: () {
              Get.to(() => const StatsScreen());
            },
          ),
        ),
      ),
      body: const Completed(),
    );
  }
}
