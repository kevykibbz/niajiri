import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/auth/phone.dart';
import 'package:Niajiri/auth/reset.dart';
import 'package:Niajiri/components/bottomsheet.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowBottomSheetModal(BuildContext context,) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight:Radius.circular(20),
          topLeft:Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Make Selection",style:TextStyle(color:AppColors.kPrimaryColor,fontSize:25,fontWeight:FontWeight.bold)),
            Text(
                "Select one of the options given below to reset your password.",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 30.0,
            ),
            BottomSheetModal(
                title: 'E-Mail',
                content: "Reset via email verification",
                icon: Ionicons.mail_open_outline,
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(() => const EmailResetPassword());
                }),
            const SizedBox(
                height: 20.0,
              ),
            BottomSheetModal(
                title: 'Phone No',
                content: "Reset via phone verification",
                icon: Icons.mobile_friendly_rounded,
                onTap: () {
                  Get.to(()=>const PhoneResetPassword());
                }
            ),
          ],
        ),
      ),
    );
  }
}
