import 'package:flutter/material.dart';
import "package:get/get.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

}
