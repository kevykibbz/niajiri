import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:Niajiri/exceptions/exceptions.dart';

class CreateSnackBar{

  //error snackbar
  static buildErrorSnackbar(BuildContext context,SignUpWithEmailAndPasswordFailure ex) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.error,
      text:ex.message,
      confirmBtnColor:AppColors.kPrimaryColor,
    );
  }

  //succcess
  static buildSuccessSnackbar({required BuildContext context,required String message,required VoidCallback onPress}) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.success,
      text:message,
      confirmBtnColor:AppColors.kPrimaryColor,
      onConfirmBtnTap:onPress
    );
  }

  //error
  static buildCustomErrorSnackbar(context,String title,String message) {
    return QuickAlert.show(
      context:context,
      type:QuickAlertType.error,
      text:message,
      confirmBtnColor:AppColors.kPrimaryColor
    );
  }
}