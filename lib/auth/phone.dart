// ignore_for_file: avoid_print

import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/components/custombtn.dart';

class PhoneResetPassword extends StatefulWidget {
  const PhoneResetPassword({ Key? key }) : super(key: key);

  @override
  PhoneResetPasswordState createState() => PhoneResetPasswordState();
}

class PhoneResetPasswordState extends State<PhoneResetPassword> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child:Column(
              children: <Widget>[
                FadeInRightBig(child: Image.network('https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png', fit: BoxFit.cover, width: 280, )),
                const SizedBox(height:10,),
                FadeInDown(
                  child: const Text('Phone Verification', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color:AppColors.kPrimaryColor),),
                ),
                FadeInLeftBig(
                  delay: const Duration(milliseconds: 200),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                    child: Text('Enter your phone number to continue, we will send you OTP to verifiy.', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontSize: 14,),),
                  ),
                ),
                const SizedBox(height:20,),
                FadeInDownBig(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      Form(
                        key:_phoneFormKey,
                        autovalidateMode:AutovalidateMode.onUserInteraction,
                        child:BuildTextInputField(
                          label: 'Phone',
                          hintText: "Your phone",
                          controller: _phoneController,
                          icon: Icons.phone_android_outlined,
                          validatorName: 'phone',
                        ),
                      )
                    ]
                  ),
                ),
                const SizedBox(height:50,),
                FadeInUpBig(
                  delay: const Duration(milliseconds: 600),
                  child: isLoading 
                  ? const CircularProgressIndicator()
                  :CustomBtn(
                    label: 'Request OTP'.toUpperCase(),
                    tag: "phone_btn",
                    onPressed: () {

                    }
                  )
                ),
                const SizedBox(height: 50,),
                FadeInLeftBig(
                  delay: const Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('All rights reserved',),
                      const SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                        },
                        child: const Text('Devme.', style: TextStyle(color: AppColors.kPrimaryColor),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
