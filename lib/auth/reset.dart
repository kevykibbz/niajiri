import 'package:Niajiri/config/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';

bool isLoading = false;

class EmailResetPassword extends StatefulWidget {
  const EmailResetPassword({ Key? key }) : super(key: key);

  @override
  EmailResetPasswordState createState() => EmailResetPasswordState();
}

class EmailResetPasswordState extends State<EmailResetPassword> {
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInRightBig(child: Image.network('https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png', fit: BoxFit.cover, width: 280, )),
              FadeInLeftBig(
                child: const Text(
                  "Password Reset",
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10,),
              FadeInUpBig(
                child: const Text(
                  "Enter your email address to reset your password of your account",
                  textAlign:TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FadeInLeftBig(
                child: Form(
                  key: _resetPasswordFormKey,
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      BuildTextInputField(
                        label: 'Email',
                        hintText: "Your email",
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        validatorName: 'email',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FadeInDownBig(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 500),
                child:isLoading 
                  ? const CircularProgressIndicator()
                  :CustomBtn(
                    label: 'Submit'.toUpperCase(),
                    tag: "Login_btn",
                    onPressed: () async{
                      if (_resetPasswordFormKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthRepository.instance.checkEmailAddress(context,_emailController.text.trim()).then((value){
                        setState(() {
                          isLoading = false;
                          }); 
                        });
                      }
                    }
                  ),
              )
          ],)
        ),
      )
    );
  }
}
