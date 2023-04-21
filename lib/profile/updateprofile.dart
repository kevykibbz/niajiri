// ignore_for_file: use_build_context_synchronously

import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/controllers/signup_controllers.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/models/profile_model.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:animate_do/animate_do.dart';
import "dart:io";
import 'package:Niajiri/snackbar/snakbar.dart';

bool isloading = false;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final updateFormKey = GlobalKey<FormState>();
    final controller = Get.put(SignUpController());
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;

    FirebaseFirestore.instance
        .collection("/users")
        .doc(user.uid)
        .get()
        .then((value) {
      var data = value.data() as Map;
      controller.fullNameController.text = data['FullName'];
      controller.emailController.text = data['Email'];
      controller.idNumberController.text = data['IdNumber'].toString();
      controller.phoneController.text = data['Phone'].toString();
    });

    Future<void> imageSelector({
      required context,
      required String filePath,
    }) async {
      Reference ref = FirebaseStorage.instance
          .ref("profiles/${user.uid}")
          .child("profilepic.jpg");
      await ref.putFile(File(filePath));
      ref.getDownloadURL().then((downloadUrl) async {
        await user.updatePhotoURL(downloadUrl);
        await FirebaseFirestore.instance
            .collection("/users")
            .doc(user.uid)
            .update({"PhotoURI": downloadUrl}).then((value) {
          CreateSnackBar.buildSuccessSnackbar(
              context: context,
              message: "Profile changed successfully.",
              onPress: () {
                Get.back();
              });
        }).onError((error, stackTrace) {
          CreateSnackBar.buildCustomErrorSnackbar(
              context, "Error", "Something went wrong");
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
           Ionicons.arrow_back_outline,
            size: 20,
            color: isDarkMode ? Colors.white : AppColors.kPrimaryColor,
          ),
        ),
        title: Text(
          " Update Profile",
          style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              FadeInUp(
                child: Stack(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: user.photoURL!,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            color: AppColors.kPrimaryColorTwo),
                        child: GestureDetector(
                          onTap: () async {
                            final results = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpeg', 'jpg'],
                            );
                            if (results == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text("No file has been picked"),
                                  action: SnackBarAction(
                                      label: 'ok',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      }),
                                ),
                              );
                            }
                            final path = results!.files.single.path;
                            imageSelector(
                              context: context,
                              filePath: path as String,
                            );
                          },
                          child: const Icon(Ionicons.camera_outline,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text("Edit details",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 10.0,
              ),
              Form(
                key: updateFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: <Widget>[
                  FadeInLeftBig(
                    child: BuildTextInputField(
                      label: 'Full name',
                      controller: controller.fullNameController,
                      icon: Icons.person_add_alt,
                      validatorName: 'username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInRightBig(
                    child: BuildTextInputField(
                      label: 'Email',
                      controller: controller.emailController,
                      icon: Icons.email_outlined,
                      validatorName: 'email',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInRightBig(
                    child: BuildTextInputField(
                      label: 'ID number',
                      hintText: "Your ID number",
                      controller: controller.idNumberController,
                      icon: Ionicons.keypad_outline,
                      isNumber: true,
                      validatorName: 'idNumber',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInRightBig(
                    child: BuildTextInputField(
                      label: 'Phone',
                      controller: controller.phoneController,
                      icon: Icons.phone_android_outlined,
                      validatorName: 'phone',
                    ),
                  ),
                  const SizedBox(height: 10),
                ]),
              ),
              const SizedBox(height: 20),
              isloading
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor))
                  : FadeInDownBig(
                      delay: const Duration(milliseconds: 200),
                      child: CustomBtn(
                        label: 'Update'.toUpperCase(),
                        tag: "submit_btn",
                        onPressed: () async {
                          if (updateFormKey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                            final user = ProfileModel(
                              fullName:
                                  controller.fullNameController.text.trim(),
                              email: controller.emailController.text.trim(),
                              idNumber: int.parse(
                                  controller.idNumberController.text.trim()),
                              phone: int.parse(
                                  controller.phoneController.text.trim()),
                            );
                            await AuthRepository.instance
                                .updateUser(context, user)
                                .then((value) {
                              setState(() {
                                isloading = false;
                              });
                            }).onError((e, stackTrace) {
                              setState(() {
                                isloading = false;
                              });
                            });
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
