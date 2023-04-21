// ignore_for_file: avoid_print

import 'dart:async';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/success/email/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  final String title;
  final String? email;
  final String? phone;
  const OtpScreen({super.key, required this.title, this.email, this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              ),
              const SizedBox(height: 20),
              Text("Awaiting ${widget.title} verification.")
            ]),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user!.emailVerified) {
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(user.uid)
          .update({"isEmailVerified": true}).then((value) {
        timer.cancel();
        Get.to(() => const SuccessScreen());
      });
    }
  }
}
