import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/screens/id_number.dart';
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
import 'package:Niajiri/exceptions/firebaseauth.dart';

bool isloading = false;

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({super.key});

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Hello world"),
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
            child: const Text(
              "Whats your name",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: CreateFormSegment())
        ],
      ),
    );
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
  final fullNameFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: fullNameFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Full name',
            hintText: "Your name",
            controller: controller.fullNameController,
            icon: Ionicons.shield_checkmark_outline,
            validatorName: 'displayName',
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
                      if (fullNameFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        final user = CustomModel(
                          fullName: controller.fullNameController.text.trim(),
                        );
                        await AuthRepository.instance
                            .updateFullName(context, user)
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          fullNameFormKey.currentState!.reset();
                          Get.to(() => const IdNumberScreen());
                        }).onError((e, stackTrace) {
                          setState(() {
                            isloading = false;
                          });
                        });
                      }
                    }),
              ),
      ]),
    );
  }
}
