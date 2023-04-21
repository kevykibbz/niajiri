import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/verification/waiting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/snackbar/snakbar.dart';

final auth = FirebaseAuth.instance.currentUser!;
bool isloading = false;

class ConsentScreen extends StatefulWidget {
  final String title;
  final String text;
  final String type;
  final String value;
  const ConsentScreen(
      {super.key,
      required this.title,
      required this.text,
      required this.type,
      required this.value});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(
              title: widget.title,
              text: widget.text,
              type: widget.type,
              value: widget.value),
          desktop: Row(
            children: [
              Expanded(
                child: FadeInLeftBig(
                  child: Column(children: [
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    FadeInRightBig(child: Text(widget.text)),
                  ]),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 450,
                        child: FadeInRightBig(
                          child: CustomBtn(
                              label: 'Continue'.toUpperCase(),
                              tag: "Continue_btn",
                              onPressed: () {
                                if (widget.type == 'phone') {
                                  processPhone(context, widget.value);
                                } else {
                                  processEmail(context, widget.value);
                                }
                              }),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  final String title;
  final String text;
  final String type;
  final String value;
  const MobileLoginScreen(
      {Key? key,
      required this.title,
      required this.text,
      required this.type,
      required this.value})
      : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          FadeInLeftBig(
            child: Text(widget.title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          FadeInRightBig(child: Text(widget.text)),
          const SizedBox(height: 20),
          FadeInRightBig(
            child: CustomBtn(
                label: 'Continue'.toUpperCase(),
                tag: "Continue_btn",
                onPressed: () {
                  if (widget.type == 'phone') {
                    processPhone(context, widget.value);
                  } else {
                    processEmail(context, widget.value);
                  }
                }),
          )
        ],
      ),
    );
  }
}

void processPhone(context, phone) async {
  final user = CustomModel(
    phone: int.tryParse(phone),
  );
  await AuthRepository.instance.updatePhoneNumber(context, user).then((value) {
    CreateSnackBar.buildSuccessSnackbar(
        context: context,
        message: "Request submitted for processing...",
        onPress: () {
          Get.back();
        });
  }).onError((error, stackTrace) {
    CreateSnackBar.buildCustomErrorSnackbar(
        context, "Error", "Unknown error occured.");
  });
}

void processEmail(context, email) async {
  auth.sendEmailVerification().then((value) async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(auth.uid)
        .update({"isEmailLinkSent": true}).then((value) {
      CreateSnackBar.buildSuccessSnackbar(
          context:context, message: "Verication link has been sent to $email.",onPress:(){
            Get.to(() => const OtpScreen(
                        title: 'email address',
                      ));
          });
    });
  }).onError((error, stackTrace) {
    CreateSnackBar.buildCustomErrorSnackbar(
        context, "Error", "Error sending verification link to your email.");
  });
}
