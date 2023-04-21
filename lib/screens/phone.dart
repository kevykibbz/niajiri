import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/screens/roles.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:Niajiri/controllers/signup_controllers.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/config.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/verification/consent.dart';

bool isloading = false;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Provide your mobile number",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 450, child: CreateFormSegment()),
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
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          FadeInUpBig(
            child: const Text("Provide your mobile number",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: CreateFormSegment())
        ]));
  }
}

class CreateFormSegment extends StatefulWidget {
  const CreateFormSegment({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  final phoneNumberFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: phoneNumberFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Mobile number',
            hintText: "Your mobile number",
            controller: controller.phoneController,
            icon: Ionicons.phone_portrait_outline,
            isNumber: true,
            validatorName: 'phone',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        isloading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              )
            : FadeInRightBig(
                child: CustomBtn(
                    label: 'Continue'.toUpperCase(),
                    tag: "Continue_btn",
                    onPressed: () async {
                      if (phoneNumberFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        final user = CustomModel(
                          phone: int.tryParse(
                              controller.phoneController.text.trim()),
                        );
                        await AuthRepository.instance
                        .updatePhoneNumber(context, user)
                        .then((value){
                          setState(() {
                            isloading = false;
                          });
                        })
                        .onError((error, stackTrace){
                          setState(() {
                            isloading = true;
                          });
                        });
                      }
                    }),
              ),
      ]),
    );
  }
}
