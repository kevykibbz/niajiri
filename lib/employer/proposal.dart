import 'package:Niajiri/dashboard.dart';
import 'package:Niajiri/models/proposal.dart';
import 'package:Niajiri/skills/select_skill.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:Niajiri/components/custombtn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/config.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isloading = false;
String fullName = '';

final user = FirebaseAuth.instance.currentUser!;

class ProposalScreen extends StatefulWidget {
  final String employeeId;
  final String docId;
  const ProposalScreen(
      {super.key, required this.employeeId, required this.docId});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  

  @override
  initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("/users")
        .doc(widget.employeeId)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      setState(() {
        fullName = dataRef["FullName"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile:
              MobileLoginScreen(docId: widget.docId, employeeId: widget.employeeId),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Hello world"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 450,
                        child:
                            CreateFormSegment(docId:widget.docId,employeeId: widget.employeeId)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatefulWidget {
  final String employeeId;
  final String docId;
  const MobileLoginScreen({Key? key, required this.employeeId,required this.docId})
      : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInUpBig(
              child: const Text(
                "Give a detailed description about your work.",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: CreateFormSegment(docId:widget.docId,employeeId: widget.employeeId))
          ],
        ),
      ),
    );
  }
}

class CreateFormSegment extends StatefulWidget {
  final String employeeId;
  final String docId;
  const CreateFormSegment({Key? key, required this.employeeId,required this.docId})
      : super(key: key);

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  final proposalFormKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController priceEstimation = TextEditingController();

  final Stream<QuerySnapshot> streamData = FirebaseFirestore.instance
      .collection("proposals")
      .where("Processed", isEqualTo: false)
      .where("Proposed", isEqualTo: true)
      .where(user.uid, isEqualTo: true)
      .where("IsAccepted", isEqualTo: false)
      .where("IsRejected", isEqualTo: false)
      .snapshots();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: proposalFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Job Description',
            hintText: "Provide your job description here",
            controller: description,
            isTextarea: true,
            icon: Ionicons.mail_open_outline,
            validatorName: 'description',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Proposed payments',
            hintText: "Your proposed full payments",
            controller: priceEstimation,
            isNumber: true,
            icon: Ionicons.keypad_sharp,
            validatorName: 'payments',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        isloading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              )
            : FadeInRightBig(
                child: CustomBtn(
                    label: 'Continue'.toUpperCase(),
                    tag: "Continue_btn",
                    onPressed: () async {
                      if (proposalFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        await AuthRepository.instance
                            .submitProposal(
                          context: context,
                          docId:widget.docId,
                          description: description.text.trim(),
                          employeeId: widget.employeeId,
                          employerId: user.uid,
                          payment: priceEstimation.text.trim(),
                          fullName: fullName,
                        )
                        .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          proposalFormKey.currentState!.reset();
                        }).onError((e, stackTrace) {
                          setState(() {
                            isloading = false;
                          });
                        });
                      }
                    }),
              ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async{
                final cartList = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("cart")
                    .where("Proposed", isEqualTo: false);
                AggregateQuerySnapshot query = await cartList.count().get();
                if (query.count > 0) {
                  Get.to(()=>const SelectSkillPage());
                } else {
                  Get.to(()=>const DashboardPage());
                }
              },
              child: const Text(
                "Go back ",
                style: TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "to market place",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ]),
    );
  }
}
