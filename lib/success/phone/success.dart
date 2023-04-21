import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/screens/full_name.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:get/get.dart';



class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children:  [
             Expanded(
                child: FadeInLeftBig(
                  child: Column(children: [
                    const Text("Success",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    FadeInRightBig(child: const Text("Your phone number has been successfully been verified.")),
                  ]),
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
  const MobileLoginScreen({Key? key})
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeInUpBig(
                child: Image.asset(
                  'assets/images/success.gif',
                  fit: BoxFit.cover,
                  width: 280,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FadeInLeftBig(
                child: const Text("Success",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimaryColor,
                        fontFamily: 'kids_club')),
              ),
              FadeInRightBig(
                child: const Text("Your phone number has been successfully been verified.",
                textAlign:TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              FadeInLeftBig(
                child: CustomBtn(
                    label: 'next'.toUpperCase(),
                    tag: "next_btn",
                    onPressed:(){
                     Get.to(() => const DashboardPage());
                    }
                ),
              )
            ]),
    );
  }
}