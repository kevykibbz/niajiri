// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:Niajiri/Welcome/welcome.dart';
import 'package:Niajiri/models/custom_model.dart';
import 'package:Niajiri/screens/full_name.dart';
import 'package:Niajiri/screens/id_number.dart';
import 'package:Niajiri/screens/phone.dart';
import 'package:Niajiri/screens/roles.dart';
import 'package:Niajiri/verification/consent.dart';
import 'package:Niajiri/verification/phone/otp.dart';
import 'package:Niajiri/verification/waiting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/models/profile_model.dart';
import 'package:Niajiri/models/users_model.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'exceptions.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  final _firestoreInstance = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;
  User? user;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : checkUserStatus();
  }

  //sign up
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, UserModel user) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password)
          .then((userCredential) async {
        await userCredential.user?.updateDisplayName(user.fullName);
        await userCredential.user?.updatePhotoURL(MyConfig.photoURI);
        await userCredential.user?.sendEmailVerification();
        await FirebaseFirestore.instance
            .collection('/users')
            .doc(userCredential.user?.uid)
            .set(user.toJson());
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  //login
  Future<void> loginUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  //check email address
  Future<bool> checkEmailAddress(BuildContext context, String email) async {
    final list = await _auth.fetchSignInMethodsForEmail(email);
    try {
      if (list.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        Get.back();
        return true;
      } else {
        Get.snackbar("Error.", "Email not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      // ignore: use_build_context_synchronously
      CreateSnackBar.buildErrorSnackbar(context, ex);
      return false;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      // ignore: use_build_context_synchronously
      CreateSnackBar.buildErrorSnackbar(context, ex);
      return false;
    }
  }

  //check phone
  Future<bool> checkPhoneNumber(BuildContext context, String phone) async {
    final list = await _auth.fetchSignInMethodsForEmail(phone);
    try {
      if (list.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: phone);
        Get.back();
        return true;
      } else {
        Get.snackbar("Error.", "Phone number not found.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
        return false;
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      // ignore: use_build_context_synchronously
      CreateSnackBar.buildErrorSnackbar(context, ex);
      return false;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      // ignore: use_build_context_synchronously
      CreateSnackBar.buildErrorSnackbar(context, ex);
      return false;
    }
  }

  //logout
  Future<void> logout(BuildContext context) async =>
      await _auth.signOut().then((value) {
        CreateSnackBar.buildSuccessSnackbar(
            context: context,
            message: "Logged out successfully.",
            onPress: () {
              Get.back();
            });
      });

  Future<void> updateUser(BuildContext context, ProfileModel user) async {
    try {
      await _auth.currentUser!.updateDisplayName(user.fullName);
      await _auth.currentUser!.updateEmail(user.email);
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({
        "FullName": user.fullName,
        "IdNumber": user.idNumber,
        "Email": user.email,
        "Phone": user.phone
      }).then((value) {
        CreateSnackBar.buildSuccessSnackbar(
            context: context,
            message: "Profile infomation updated successfully.",
            onPress: () {
              Get.back();
            });
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  checkUserStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestoreInstance.collection("/users").doc(user.uid).get().then((value) {
        print("DATAAAAAAAAAAAAAAAAAA:$value");
        if (value != null) {
          var dataRef = value.data() as Map;
          if (!dataRef["isEmailVerified"]) {
            if (dataRef["isEmailLinkSent"]) {
              Get.to(() => const OtpScreen(
                    title: 'email address',
                  ));
            } else {
              Get.to(() => ConsentScreen(
                    type: "email",
                    value: user.email.toString(),
                    text:
                        'This email has not been verified.Click continue in order to verify it.',
                    title: 'Email verification',
                  ));
            }
          }else if (dataRef['FullName'] == null) {
            Get.to(() => const FullNameScreen());
          } else if (dataRef['IdNumber'] == null) {
            Get.to(() => const IdNumberScreen());
          } else if (dataRef['Role'] == null) {
            Get.to(() => const RolesScreen());
          } else if (!dataRef['isPhoneVerified']) {
            if (dataRef['Phone'] == null) {
              Get.to(() => const PhoneScreen());
            } else {
              Get.to(() => ConsentScreen(
                    type: "phone",
                    value: dataRef['Phone'].toString(),
                    title: 'Phone number verification',
                    text:
                        'This phone number is not verified.Click on continue button in order to verify it.',
                  ));
            }
          } else {
            Get.to(() => const DashboardPage());
          }
        }else{
          Get.to(() => const DashboardPage());
        }
      });
    } else {
      Get.to(() => const DashboardPage());
    }
  }

  Future<void> updateFullName(BuildContext context, CustomModel user) async {
    try {
      await _auth.currentUser!.updateDisplayName(user.fullName);
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({"FullName": user.fullName});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> updateIdNumber(BuildContext context, CustomModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({"IdNumber": user.idNumber});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> updateRole(BuildContext context, CustomModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({"Role": user.role});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> updatePhoneNumber(BuildContext context, CustomModel user) async {
    await _firestoreInstance
        .collection("/users")
        .doc(_auth.currentUser!.uid)
        .update({"Phone": user.phone});
    await _auth.verifyPhoneNumber(
        phoneNumber: '+254${user.phone.toString()}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credentials) {},
        verificationFailed: (FirebaseAuthException e) {
          CreateSnackBar.buildCustomErrorSnackbar(
              context, "Error", e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.snackbar("Success", "OTP number sent to +254${user.phone}",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              colorText: Colors.green);
          Get.to(() => PhoneOtpScreen(
              phone: user.phone.toString(), verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> verifyOtp(
      {required BuildContext context,
      required verifyId,
      required otpNumber}) async {
    try {
      PhoneAuthProvider.credential(
          verificationId: verifyId, smsCode: otpNumber);
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_auth.currentUser!.uid)
          .update({"isPhoneVerified": true});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
    } catch (error) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> addNewSkill(
      {required BuildContext context,
      required String skillName,
      required String payment}) async {
    try {
      await _firestoreInstance
          .collection("/users")
          .doc(_auth.currentUser!.uid)
          .collection("skilss")
          .add({"SkillName": skillName, "Payment": payment});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> editSkill(
      {required BuildContext context,
      required String skillName,
      required String payment,
      required String skillId}) async {
    try {
      await _firestoreInstance
          .collection("/users")
          .doc(_auth.currentUser!.uid)
          .collection("skilss")
          .doc(skillId)
          .update({"SkillName": skillName, "Payment": payment});
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> addCart(
      {required BuildContext context,
      required String fullName,
      required String employeeId}) async {
    try {
      FirebaseFirestore.instance
          .collection("/users")
          .doc(employeeId)
          .get()
          .then((value) async {
        var dataRef = value.data() as Map;
        if (dataRef['IsBusy']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This client is currently busy somewhere else"),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          await FirebaseFirestore.instance
              .collection('/users')
              .doc(_auth.currentUser!.uid)
              .collection('cart')
              .where(employeeId, isEqualTo: true)
              .where("Proposed", isEqualTo: false)
              .get()
              .then((value) async {
            if (value.size == 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You have already added this to the cart"),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              await FirebaseFirestore.instance
                  .collection('proposals')
                  .where(employeeId, isEqualTo: true)
                  .where("Proposed", isEqualTo: true)
                  .get()
                  .then((value) async {
                if (value.size == 1) {
                  CreateSnackBar.buildCustomErrorSnackbar(context, "error",
                      "You have already placed proposal on this client.");
                } else {
                  await FirebaseFirestore.instance
                      .collection('/users')
                      .doc(_auth.currentUser!.uid)
                      .collection('cart')
                      .add({
                    "EmployeeIdId": employeeId,
                    employeeId: true,
                    "FullName": fullName,
                    "Proposed": false,
                    "Date": DateTime.now(),
                    "IsSelected": false,
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Added to cart successfully"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                }
              });
            }
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> submitProposal(
      {required BuildContext context,
      required String employerId,
      required String fullName,
      required String employeeId,
      required String docId,
      required String description,
      required String payment}) async {
    try {
      FirebaseFirestore.instance
          .collection('proposals')
          .where(employeeId, isEqualTo: true)
          .get()
          .then((value) async {
        if (value.size == 1) {
          CreateSnackBar.buildCustomErrorSnackbar(
              context, "error", "You have already placed proposal");
        } else {
          await FirebaseFirestore.instance
              .collection('/users')
              .doc(_auth.currentUser!.uid)
              .collection('cart')
              .doc(docId)
              .update({"Proposed": true});
          await FirebaseFirestore.instance.collection('proposals').add({
            "EmployerId": employerId,
            employerId: true,
            employeeId: true,
            "EmployeeId": employeeId,
            "JobDescription": description,
            "ProposedPayment": payment,
            "FullName": fullName,
            "EmployersFullName": _auth.currentUser!.displayName,
            "IsRead": false,
            "InProgress": false,
            "IsRequestingPayments": false,
            "PaymentsAccepted": false,
            "PaymentsRejected": false,
            "Reason": "",
            "Processed": false,
            "Proposed": true,
            "Date": DateTime.now(),
            "IsAccepted": false,
            "IsRejected": false,
          }).then((value) {
            CreateSnackBar.buildSuccessSnackbar(
                context: context,
                message: "Job Proposal submitted successfully.",
                onPress: () {
                  Get.back();
                });
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> updateProposalStatusIsAccepted(
      {required BuildContext context, required String docId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(docId)
          .update({
        "IsAccepted": true,
        "IsRejected": false,
        "Reason": "Proposal accepted by you"
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have accepted this proposal"),
            duration: Duration(seconds: 2),
          ),
        );
      }).onError((error, stacktrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("unknown error ocurred"),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> updateProposalStatusIsRejected(
      {required BuildContext context, required String docId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(docId)
          .update({
        "IsRejected": true,
        "IsAccepted": false,
        "Reason": "Proposal rejected by you"
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have rejected this proposal"),
            duration: Duration(milliseconds: 500),
          ),
        );
      }).onError((error, stacktrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("unknown error ocurred"),
            duration: Duration(milliseconds: 500),
          ),
        );
      });
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> requestPayments(
      {required BuildContext context, required String docId}) async {
    await FirebaseFirestore.instance.collection('proposals').doc(docId).update({
      "IsRequestingPayments": true,
    });
  }

  Future<void> declinePayments(
      {required BuildContext context, required String docId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(docId)
          .update({
        "PaymentsAccepted": false,
        "PaymentsRejected": true,
        "Processed": true,
        "Reason": "Payments approval was rejected by the employer"
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Client Payments approval rejected."),
            duration: Duration(milliseconds: 3000),
          ),
        );
      }).onError((error, stacktrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("unknown error ocurred"),
            duration: Duration(milliseconds: 1000),
          ),
        );
      });
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }

  Future<void> acceptPayments(
      {required BuildContext context,
      required String docId,
      required String employeeId,
      required String amount}) async {
    try {
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(docId)
          .update({
        "PaymentsAccepted": true,
        "PaymentsRejected": false,
        "Processed": true,
        "Reason": "Payments approval was approved by the employer"
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('/users')
            .doc(employeeId)
            .get()
            .then((results) async {
          var dataRef = results.data() as Map;
          var totalBalance = int.parse(dataRef["Wallet"]) + int.parse(amount);
          await FirebaseFirestore.instance
              .collection('/users')
              .doc(employeeId)
              .update({"Wallet": totalBalance}).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Client Payments approval accepted."),
                duration: Duration(milliseconds: 3000),
              ),
            );
          });
        });
      }).onError((error, stacktrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("unknown error ocurred"),
            duration: Duration(milliseconds: 1000),
          ),
        );
      });
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      CreateSnackBar.buildErrorSnackbar(context, ex);
      throw ex;
    }
  }
}
