import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/already_have_account.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/auth/components/login_form.dart';
import 'package:Niajiri/auth/components/login_screen_top_image.dart';
import 'package:Niajiri/auth/signup.dart';
import 'package:Niajiri/auth/social.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/functions/bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/config/config.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:get/get.dart';

bool isloading = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Responsive(
        mobile: const MobileLoginScreen(),
        desktop: Row(
          children: [
            const Expanded(
              child: LoginScreenTopImage(),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 450,
                    child: LoginForm(),
                  ),
                ],
              ),
            ),
          ],
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
  final _loginFormKey = GlobalKey<FormState>();
  bool remember = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUpBig(child: const LoginScreenTopImage()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _loginFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FadeInLeftBig(
                    child: BuildTextInputField(
                      label: 'Email',
                      hintText: "Your email",
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      validatorName: 'email',
                    ),
                  ),
                  const SizedBox(height: MyConfig.defaultPadding),
                  FadeInRightBig(
                    child: BuildTextInputField(
                      label: 'Password',
                      hintText: "Enter your password",
                      controller: _passwordController,
                      icon: Icons.lock,
                      isLogin: true,
                      isPasswordType: true,
                      validatorName: 'password',
                    ),
                  ),
                  FadeInLeftBig(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Theme(
                          data: ThemeData(
                              unselectedWidgetColor: isDarkMode
                                  ? Colors.white
                                  : AppColors.kPrimaryColor),
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: AppColors.kPrimaryColor,
                            value: remember,
                            onChanged: ((value) {
                              setState(() {
                                remember = value!;
                              });
                            }),
                          ),
                        ),
                        Text('Remember me',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.kPrimaryColor)),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              ForgetPasswordScreen.buildShowBottomSheetModal(
                                  context);
                            },
                            child: Text(
                              'Forgotten password',
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : AppColors.kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  isloading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                        )
                      : FadeInRightBig(
                          child: CustomBtn(
                              label: 'Login'.toUpperCase(),
                              tag: "Login_btn",
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  AuthRepository.instance
                                      .loginUserWithEmailAndPassword(
                                          context,
                                          _emailController.text,
                                          _passwordController.text)
                                      .then((value) {
                                    setState(() {
                                      isloading = false;
                                    });
                                    _loginFormKey.currentState!.reset();
                                    Get.to(()=>const DashboardPage());
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      isloading = false;
                                    });
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.error,
                                        text: error.toString());
                                  });
                                }
                              }),
                        ),
                  const SizedBox(height: MyConfig.defaultPadding),
                  FadeInUpBig(
                    child: AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Expanded(
                child: Divider(
              indent: 20.0,
              endIndent: 10.0,
              thickness: 1,
              color: AppColors.kPrimaryColorTwo,
            )),
            Text('OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:
                        isDarkMode ? Colors.white : AppColors.kPrimaryColor)),
            const Expanded(
                child: Divider(
                    indent: 20.0,
                    endIndent: 10.0,
                    thickness: 1,
                    color: AppColors.kPrimaryColorTwo)),
          ]),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                            'assets/images/facebook-svgrepo-com.svg'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        twitterLogin(context);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                            'assets/images/twitter-svgrepo-com.svg'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin(context);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(
                            'assets/images/google-plus-svgrepo-com.svg'),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
