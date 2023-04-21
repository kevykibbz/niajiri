import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:get/get.dart';
import 'package:Niajiri/success/phone/success.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:animate_do/animate_do.dart';
import "dart:async";

bool isloading = false;

class PhoneOtpScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  const PhoneOtpScreen(
      {Key? key, required this.phone, required this.verificationId})
      : super(key: key);

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(
              phone: widget.phone, verificationId: widget.verificationId),
          desktop: Row(
            children: const [
              Expanded(
                child: Text("Phone number verfication",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  const MobileLoginScreen(
      {Key? key, required this.phone, required this.verificationId})
      : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String finalCode = '';

  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    timer.cancel();
  }

  void resendCode() async {
    final user = CustomModel(phone: int.parse(widget.phone));
    await AuthRepository.instance
        .updatePhoneNumber(context, user)
        .then((value) {
      setState(() {
        isloading = false;
        secondsRemaining = 30;
        enableResend = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isloading = false;
      });
    });
  }

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
                  FadeInLeftBig(
                    child: const Expanded(
                      child: Text(' Phone number Verfication.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
          ),
          const SizedBox(height: 10.0),
          FadeInRightBig(
            child: Text('Enter verfication code send to ${widget.phone}',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: 20.0),
          FadeInRightBig(
            child: OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.2),
              cursorColor: AppColors.kPrimaryColor,
              focusedBorderColor: AppColors.kPrimaryColor,
              filled: true,
              onCodeChanged: (value) {
                setState(() {
                  isloading = false;
                });
              },
              onSubmit: (code) {
                setState(() {
                  finalCode = code;
                });
              },
            ),
          ),
          const SizedBox(height: 20.0),
          isloading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                )
              : FadeInUpBig(
                  child: CustomBtn(
                    label: 'Next',
                    onPressed: () async {
                      if (finalCode.length == 6) {
                        setState(() {
                          isloading = true;
                        });
                        await AuthRepository.instance
                            .verifyOtp(
                          context: context,
                          verifyId: widget.verificationId,
                          otpNumber: finalCode,
                        )
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          CreateSnackBar.buildSuccessSnackbar(
                              context: context,
                              message: "OTP verified successfully",
                              onPress: () {
                                Get.to(() => const SuccessScreen());
                              });
                        }).onError((error, stackTrace) {
                          setState(() {
                            isloading = false;
                          });
                        });
                      }
                    },
                    tag: 'next_btn',
                  ),
                ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    if (enableResend) {
                      resendCode();
                    }
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                        color: enableResend
                            ? AppColors.kPrimaryColor
                            : Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  " after $secondsRemaining seconds",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
