import 'package:Niajiri/screens/full_name.dart';
import 'package:Niajiri/screens/id_number.dart';
import 'package:Niajiri/screens/phone.dart';
import 'package:Niajiri/screens/roles.dart';
import 'package:Niajiri/verification/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard.dart';
import 'boarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckerPage extends StatefulWidget {
  const CheckerPage({super.key});

  @override
  State<CheckerPage> createState() => _CheckerPageState();
}

class _CheckerPageState extends State<CheckerPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      print("checker page talkinggggggggggggggggggggggggggggggg");
      return const DashboardPage();
    } else {
      return const BoardingScreen();
    }
  }
}
