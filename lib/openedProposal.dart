import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';
import "package:intl/intl.dart";

String proposalDescription = '';
String estimatedPrice = '';
final formattedValue = NumberFormat("#,##0.00", "en_US");

class OpenedScreen extends StatefulWidget {
  final String docId;
  const OpenedScreen({
    super.key,
    required this.docId,
  });

  @override
  State<OpenedScreen> createState() => _OpenedScreenState();
}

class _OpenedScreenState extends State<OpenedScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("/proposals")
        .doc(widget.docId)
        .get()
        .then((value) {
      var dataRef = value.data() as Map;
      setState(() {
        proposalDescription = dataRef['JobDescription'];
        estimatedPrice =
            formattedValue.format(int.parse(dataRef['ProposedPayment']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Make a decision"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          elevation: 0,
        ),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          FadeInLeftBig(
            child: const Text(
              "Job Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          FadeInRightBig(child: Text(proposalDescription)),
          const SizedBox(height: 10),
          const Divider(),
          FadeInLeftBig(
            child: const Text(
              "Estimated payments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          FadeInRightBig(child: Text("Ksh:$estimatedPrice")),
          const SizedBox(height: 10),
          const Divider(),
          const Spacer(),
          Row(
            children: [
              FadeInLeftBig(
                child: Hero(
                  tag: "reject_btn",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 60,
                    padding: const EdgeInsets.only(left: 3),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm decision."),
                                content: const Text(
                                    "Confirm rejecting this proposal."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "cancel",
                                      style: TextStyle(
                                          color: AppColors.kPrimaryColorTwo),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AuthRepository.instance
                                          .updateProposalStatusIsRejected(
                                        context: context,
                                        docId: widget.docId,
                                      ).then((value){
                                        Navigator.of(context).pop();
                                      });
                                      
                                    },
                                    child: const Text(
                                      "ok",
                                      style: TextStyle(
                                          color: AppColors.kPrimaryColorTwo),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: const StadiumBorder(),
                          disabledBackgroundColor: Colors.grey,
                          maximumSize: const Size(double.infinity, 56),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text("REJECT")),
                  ),
                ),
              ),
              const Spacer(),
              FadeInRightBig(
                child: Hero(
                  tag: "accept_btn",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 60,
                    padding: const EdgeInsets.only(left: 3),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm decision."),
                                content: const Text(
                                    "Confirm accepting this proposal."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("cancel",
                                          style: TextStyle(
                                              color:
                                                  AppColors.kPrimaryColorTwo))),
                                  TextButton(
                                      onPressed: () {
                                        AuthRepository.instance
                                            .updateProposalStatusIsAccepted(
                                          context: context,
                                          docId: widget.docId,
                                        )
                                            .then((value) {
                                        Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Text("ok",
                                          style: TextStyle(
                                              color:
                                                  AppColors.kPrimaryColorTwo,),),)
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: AppColors.kPrimaryColor,
                          shape: const StadiumBorder(),
                          disabledBackgroundColor: Colors.grey,
                          maximumSize: const Size(double.infinity, 56),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Text("ACCEPT")),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
