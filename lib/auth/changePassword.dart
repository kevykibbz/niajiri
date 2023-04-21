// ignore_for_file: avoid_print
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/snackbar/snakbar.dart';

bool isloading = false;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final newPasswordFormKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) async {
    bool success = false;
    var user = FirebaseAuth.instance.currentUser!;
    final credential = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(credential).then((value) async {
      await user.updatePassword(newPassword).then((value) {
        success = true;
      }).catchError((error) {
        success = false;
      });
    }).catchError((error) {
      success = false;
    });
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Change Password",
            style: TextStyle(
                color: isDarkMode ? Colors.white : AppColors.kPrimaryColorTwo)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: isDarkMode ? Colors.white : AppColors.kPrimaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FadeInUpBig(
                  child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                width: 200,
              )),
              FadeInLeftBig(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.kPrimaryColorTwo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FadeInRightBig(
                delay: const Duration(milliseconds: 200),
                child: const Text(
                  "Wish to change your account password?  Fill the below form to do so.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              FadeInUpBig(
                delay: const Duration(milliseconds: 200),
                child: Form(
                  key: newPasswordFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      FadeInLeftBig(
                        child: BuildTextInputField(
                          label: 'Old Password',
                          controller: oldPasswordController,
                          icon: Ionicons.lock_closed_outline,
                          isPasswordType: true,
                          validatorName: 'oldpassword',
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      FadeInRightBig(
                        child: BuildTextInputField(
                          label: 'New Password',
                          controller: newPasswordController,
                          icon: Ionicons.lock_closed_outline,
                          isPasswordType: true,
                          validatorName: 'password',
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
              isloading
                  ? const CircularProgressIndicator()
                  : FadeInUpBig(
                      delay: const Duration(milliseconds: 200),
                      child: CustomBtn(
                          label: 'Submit'.toUpperCase(),
                          tag: "submit_btn",
                          onPressed: () async {
                            if (newPasswordFormKey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              await changePassword(
                                currentPassword:
                                    oldPasswordController.text.trim(),
                                newPassword: newPasswordController.text.trim(),
                              ).then((value) {
                                setState(() {
                                  isloading = false;
                                });
                                if (value) {
                                  CreateSnackBar.buildSuccessSnackbar(
                                      context: context,
                                      message: "Password changed successfully.",
                                      onPress: () {
                                        Get.back();
                                      });
                                } else {
                                  CreateSnackBar.buildCustomErrorSnackbar(
                                      context,
                                      "Error",
                                      "There was a problem changing your password.Try again later.");
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isloading = false;
                                });
                                CreateSnackBar.buildCustomErrorSnackbar(
                                    context,
                                    "Error",
                                    "There was a prblem changing your password.Try again later.");
                              });
                            }
                          })),
            ]),
      )),
    );
  }
}
