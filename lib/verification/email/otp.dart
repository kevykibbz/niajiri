import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:animate_do/animate_do.dart';
import 'package:quickalert/quickalert.dart';
import "package:email_auth/email_auth.dart";
import 'package:Niajiri/exceptions/firebaseauth.dart';

int userOTP = 0;
bool isloading = false;
final _auth = FirebaseAuth.instance;

class EmailOtpScreen extends StatelessWidget {
  final String email;
  const EmailOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(email: email),
          desktop: Row(
            children: [
              Expanded(
                child: FadeInLeftBig(
                  child: const Text("Email Address verfication",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
  final String email;
  const MobileLoginScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: FadeInLeftBig(
                      child: const Text(' Email Address verfication.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
          ),
          const SizedBox(height: 10.0),
          FadeInRightBig(
            child: Text('Enter verfication code send to $widget.email',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 20.0),
          FadeInLeftBig(
            child: OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.2),
                cursorColor: AppColors.kPrimaryColor,
                focusedBorderColor: AppColors.kPrimaryColor,
                filled: true,
                onSubmit: (code) {
                  setState(() {
                    userOTP = int.parse(code);
                  });
                }),
          ),
          const SizedBox(height: 20.0),
          isloading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                )
              : FadeInDownBig(
                  child: CustomBtn(
                    label: 'Next',
                    onPressed: () async {
                      setState(() {
                        isloading = true;
                      });
                      EmailAuth emailAuth =
                          EmailAuth(sessionName: 'Test session');
                      var result = emailAuth.validateOtp(
                          recipientMail: "kibebekevin@gmail.com",
                          userOtp: "1234");
                      if (result) {
                        setState(() {
                          isloading = false;
                        });
                        await FirebaseFirestore.instance
                            .collection("/users")
                            .doc(_auth.currentUser!.uid)
                            .update({"isEmailVerified": true}).then((value) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "Email verified successfully.",
                            confirmBtnColor: AppColors.kPrimaryColor,
                          );
                          AuthRepository.instance.checkUserStatus();
                        }).onError((error, stackTrace) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: "Something went wrong",
                            confirmBtnColor: AppColors.kPrimaryColor,
                          );
                        });
                      } else {
                        setState(() {
                          isloading = false;
                        });
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: "Wrong OTP number given",
                          confirmBtnColor: AppColors.kPrimaryColor,
                        );
                      }
                    },
                    tag: 'next_btn',
                  ),
                ),
        ],
      ),
    );
  }
}
