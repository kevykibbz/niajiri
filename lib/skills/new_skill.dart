import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/config/config.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import 'package:Niajiri/skills/edit_skill.dart';
import 'package:Niajiri/snackbar/snakbar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/Welcome/components/responsive.dart';
import 'package:Niajiri/auth/components/background.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Niajiri/components/nodata.dart';

bool isloading = false;
final user = FirebaseAuth.instance.currentUser!;

class NewSkillScreen extends StatefulWidget {
  const NewSkillScreen({super.key});

  @override
  State<NewSkillScreen> createState() => _NewSkillScreenState();
}

class _NewSkillScreenState extends State<NewSkillScreen> {
  List<Tab> tabs = [
    const Tab(
      child: Text(
        "New Skill",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    const Tab(
      child: Text(
        "Edit Skill",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
  ];

  List<Widget> tabContent = [
    const NewSkillContainer(),
    const EditSkillContainer()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: TabBar(
                indicatorColor: AppColors.kPrimaryColor,
                labelColor: AppColors.kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 2,
                isScrollable: true,
                tabs: tabs),
          ),
        ),
        body: TabBarView(children: tabContent),
      ),
    );
  }
}

class NewSkillContainer extends StatefulWidget {
  const NewSkillContainer({super.key});

  @override
  State<NewSkillContainer> createState() => _NewSkillContainerState();
}

class _NewSkillContainerState extends State<NewSkillContainer> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: Text("Hello world"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 450, child: CreateFormSegment()),
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
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInUpBig(
            child: const Text("Enter new skill",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: CreateFormSegment())
        ],
      ),
    );
  }
}

class CreateFormSegment extends StatefulWidget {
  const CreateFormSegment({super.key});

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  final newSkillFormKey = GlobalKey<FormState>();
  TextEditingController newSkillController = TextEditingController();
  TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: newSkillFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Skill name',
            hintText: "Enter your skill name eg laundry etc",
            controller: newSkillController,
            icon: Ionicons.shield_checkmark_outline,
            validatorName: 'skillName',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Preferred payments',
            hintText: "Enter your preffered rate of payment eg ksh 200/basin",
            controller: paymentController,
            icon: Ionicons.document_outline,
            validatorName: 'payment',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        isloading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              )
            : FadeInRightBig(
                child: CustomBtn(
                    label: 'Submit'.toUpperCase(),
                    tag: "submit_btn",
                    onPressed: () async {
                      if (newSkillFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        await AuthRepository.instance
                            .addNewSkill(
                          context: context,
                          skillName: newSkillController.text.trim(),
                          payment: paymentController.text.trim(),
                        )
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          newSkillFormKey.currentState!.reset();
                          CreateSnackBar.buildSuccessSnackbar(
                              context: context,
                              message: "Skill added successfully",
                              onPress: () {
                                Get.back();
                              });
                        }).onError((error, stackTrace) {
                          setState(() {
                            isloading = true;
                          });
                          CreateSnackBar.buildCustomErrorSnackbar(
                              context,
                              "Error",
                              "Something went wrong while adding your skill.");
                        });
                      }
                    }),
              ),
      ]),
    );
  }
}

class EditSkillContainer extends StatefulWidget {
  const EditSkillContainer({super.key});

  @override
  State<EditSkillContainer> createState() => _EditSkillContainerState();
}

class _EditSkillContainerState extends State<EditSkillContainer> {
  final Stream<QuerySnapshot> skillsStream = FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection("skilss")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: skillsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            final snap = snapshot.data!.docs;
            if (snap.isEmpty) {
              return const Nodata(message: "No skills found.");
            }
            return buildList(snap);
          }
        });
  }
}

Widget buildList(data) {
  final themedata = GetStorage();
  bool isDarkMode = themedata.read("darkmode") ?? false;
  return ListView.builder(
    itemCount: data.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      var id = data[index].reference.id.toString();
      return Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: AppColors.kPrimaryColorTwo,
              icon: Ionicons.pencil,
              label: "Edit",
              onPressed: (context) {
                Get.to(() => EditSkillPage(
                      skillId: id,
                    ));
              },
            )
          ],
        ),
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
              backgroundColor: Colors.redAccent,
              icon: Ionicons.arrow_forward_outline,
              label: "Delete",
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Delete"),
                    content: const Text("Confirm deleting item"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("/users")
                              .doc(user.uid)
                              .collection("skilss")
                              .doc(id)
                              .delete()
                              .then((value) async {
                            Get.back(closeOverlays: true);
                            CreateSnackBar.buildSuccessSnackbar(
                                context: context,
                                message: "Station name deleted successfully.",
                                onPress: () {
                                  Get.back();
                                });
                          }).onError((error, stackTrace) {
                            CreateSnackBar.buildCustomErrorSnackbar(
                                context,
                                "Error",
                                "There was an error deleting the item");
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
        ]),
        child: Card(
          elevation: 5.0,
          child: ListTile(
            title: Text(data[index]['SkillName']),
            subtitle: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style:TextStyle(color: isDarkMode ?Colors.white:Colors.black),
                text: data[index]['Payment'],
              ),
            ),
            leading: CircleAvatar(
              backgroundColor:AppColors.kPrimaryColorTwo,
                child: Text(data[index]['SkillName'][0].toUpperCase(),style:const TextStyle(color:Colors.white),)),
            dense: false,
            trailing: IconButton(
              onPressed: () {
                Get.to(() => EditSkillPage(
                      skillId: id,
                    ));
              },
              icon: const Icon(Ionicons.arrow_forward_outline,
                  size: 24.0, color: AppColors.kPrimaryColorTwo),
            ),
          ),
        ),
      );
    },
  );
}
