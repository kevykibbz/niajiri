// ignore_for_file: avoid_print

import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/auth/components/sign_up_form.dart';
import 'package:Niajiri/auth/components/sign_up_top_img.dart';
import 'package:Niajiri/auth/login.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/controllers/signup_controllers.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/models/users_model.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Niajiri/verification/waiting.dart';
import 'package:quickalert/quickalert.dart';

bool isloading = false;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Responsive(
        mobile: const MobileSignupScreen(),
        desktop: Row(
          children: [
            const Expanded(
              child: SignUpScreenTopImage(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 450,
                    child: SignUpForm(),
                  ),
                  SizedBox(height: MyConfig.defaultPadding / 2),
                  // SocalSignUp()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatefulWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileSignupScreen> createState() => _MobileSignupScreenState();
}

class _MobileSignupScreenState extends State<MobileSignupScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeInDownBig(child: const SignUpScreenTopImage()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _registerFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: [
              FadeInLeftBig(
                child: BuildTextInputField(
                  label: 'Email',
                  hintText: "Your email",
                  controller: controller.emailController,
                  icon: Icons.email_outlined,
                  validatorName: 'email',
                ),
              ),
              const SizedBox(height: MyConfig.defaultPadding),
              FadeInRightBig(
                child: BuildTextInputField(
                  label: 'Password',
                  hintText: "Enter your password",
                  controller: controller.passwordController,
                  icon: Icons.lock,
                  isPasswordType: true,
                  validatorName: 'password',
                ),
              ),
              const SizedBox(height: MyConfig.defaultPadding),
              isloading
                  ? const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                    )
                  : FadeInLeftBig(
                      child: CustomBtn(
                          label: "Sign up".toUpperCase(),
                          tag: "Signup_btn",
                          onPressed: () {
                            if (_registerFormKey.currentState!.validate()) {
                              //firebase store
                              setState(() {
                                isloading = true;
                              });
                              final user = UserModel(
                                email: controller.emailController.text.trim(),
                                photoUri: MyConfig.photoURI,
                                role: "",
                                rating: 0.0,
                                location:"",
                                fullName: "",
                                balance:0.0,
                                bio:"Some description about you...",
                                isEmailVerified: false,
                                isEmailLinkSent:true,
                                isPhoneVerified: false,
                                password:
                                    controller.passwordController.text.trim(),
                              );
                              AuthRepository.instance
                                  .createUserWithEmailAndPassword(context, user)
                                  .then((value) {
                                setState(() {
                                  isloading = false;
                                });
                                _registerFormKey.currentState!.reset();
                                QuickAlert.show(
                                  context:context,
                                  type:QuickAlertType.success,
                                  onConfirmBtnTap: (){
                                    Get.to(() => OtpScreen(
                                      title: 'email verfication',
                                      email: controller.emailController.text.trim(),
                                    ));
                                  },
                                  text:"Email verification link sent to ${controller.emailController.text.trim()}",
                                  confirmBtnColor:AppColors.kPrimaryColor
                                );
                              }).onError((e, stackTrace) {
                                setState(() {
                                  isloading = false;
                                });
                              });
                            }
                          }),
                    ),
              const SizedBox(height: MyConfig.defaultPadding),
              FadeInRightBig(
                delay: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?",
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.kPrimaryColor)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginScreen())));
                      },
                      child: Text(
                        " Login",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.kPrimaryColor,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
        // const SocalSignUp()
      ],
    );
  }
}
