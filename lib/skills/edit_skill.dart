import 'package:Niajiri/Welcome/components/background.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isloading = false;
final user = FirebaseAuth.instance.currentUser!;

class EditSkillPage extends StatefulWidget {
  final String skillId;
  const EditSkillPage({super.key, required this.skillId});

  @override
  State<EditSkillPage> createState() => _EditSkillPageState();
}

class _EditSkillPageState extends State<EditSkillPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(
            skillId: widget.skillId,
          ),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Hello world"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 450,
                        child: CreateFormSegment(skillId: widget.skillId)),
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
  final String skillId;
  const MobileLoginScreen({super.key, required this.skillId});

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
            child: const Text("Edit skill",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: CreateFormSegment(
                skillId: widget.skillId,
              ))
        ],
      ),
    );
  }
}

class CreateFormSegment extends StatefulWidget {
  final String skillId;
  const CreateFormSegment({super.key, required this.skillId});

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  final editSkillFormKey = GlobalKey<FormState>();
  TextEditingController newSkillController = TextEditingController();
  TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final results = FirebaseFirestore.instance
        .collection("/users")
        .doc(user.uid)
        .collection("skilss")
        .doc(widget.skillId)
        .get();
    results.then((value) {
      var dataRef = value.data() as Map;
      newSkillController.text = dataRef['SkillName'];
    });
    return Form(
      key: editSkillFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          FadeInLeftBig(
            child: BuildTextInputField(
              label: 'Skill name',
              hintText: "Enter your skill name eg laundry etc",
              controller: newSkillController,
              icon: Ionicons.shield_checkmark_outline,
              validatorName: 'skillName',
            ),
          ),
          const SizedBox(height: MyConfig.defaultPadding),
          FadeInLeftBig(
            child: BuildTextInputField(
              label: 'Preferred payments',
              hintText: "Enter your preffered rate of payment eg ksh 200/basin",
              controller: paymentController,
              icon: Ionicons.document_outline,
              validatorName: 'payment',
            ),
          ),
          const SizedBox(height: MyConfig.defaultPadding),
          isloading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                )
              : FadeInRightBig(
                  child: CustomBtn(
                    label: 'Submit'.toUpperCase(),
                    tag: "submit_btn",
                    onPressed: () async {
                      if (editSkillFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        await AuthRepository.instance
                            .editSkill(
                          context: context,
                          skillName: newSkillController.text.trim(),
                          payment: paymentController.text.trim(),
                          skillId: widget.skillId,
                        )
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          editSkillFormKey.currentState!.reset();
                          CreateSnackBar.buildSuccessSnackbar(
                              context: context,
                              message: "Skill changed successfully",
                              onPress: () {
                                Get.back();
                              });
                        }).onError((error, stackTrace) {
                          setState(() {
                            isloading = true;
                          });
                          CreateSnackBar.buildCustomErrorSnackbar(
                              context,
                              "Error",
                              "Something went wrong while editing your skill.");
                        });
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
