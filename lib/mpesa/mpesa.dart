// ignore_for_file: avoid_print

import 'package:Niajiri/payment/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Niajiri/config/config.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:get/get.dart';

final user = FirebaseAuth.instance.currentUser!;

class MpesaManager {
  DateTime currentDate = DateTime.now();
  String? mUserMail = user.email;

  Future<dynamic> startCheckout(BuildContext context,
      {required String phoneNumber,
      required double amount,
     }) async {
    dynamic transactionInitialisation;
    try {
      //Run it
      final callBackUri = Uri.https(MyConfig.mpesaCallbackUrl);
      final baseUri = Uri.https("api.safaricom.co.ke");
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: MyConfig.shortCode.toString(),
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: amount,
              partyA: phoneNumber,
              partyB: MyConfig.shortCode,
              callBackURL: callBackUri,
              accountReference: phoneNumber,
              phoneNumber: phoneNumber,
              baseUri: baseUri,
              transactionDesc: "Niajiri casual service subscribtion.",
              passKey: MyConfig.mpesaPassKey);
      var result = transactionInitialisation as Map<String, dynamic>;
      if (result.keys.contains("ResponseCode")) {
        String mResponseCode = result["ResponseCode"];
        if (mResponseCode == '0') {
          //request successfully accepted for processing.
          var checkOutId = result["CheckoutRequestID"];
          FirebaseFirestore.instance
              .collection("transactions")
              .doc(checkOutId)
              .set({
            "CheckoutRequestId": checkOutId,
            "userId": user.uid,
             user.uid:true,
            "Status": "Transaction initiated",
            "Date Initiated": currentDate.toString(),
          }).then((value) {
            CreateSnackBar.buildSuccessSnackbar(
                context: context,
                message: result["CustomerMessage"],
                onPress: () {
                  Get.to(()=>const SuccessScreen());
                });
          }).catchError((error) {
            CreateSnackBar.buildCustomErrorSnackbar(
                context, "Error", error.toString());
          });
        } else {
          // ignore: use_build_context_synchronously
          CreateSnackBar.buildCustomErrorSnackbar(
              context, "Error", "Unknown problem occured");
        }
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }
}
