import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import "package:intl/intl.dart";
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';

String proposalDescription = '';
String estimatedPrice = '';
final formattedValue = NumberFormat("#,##0.00", "en_US");

class AcceptPayments extends StatefulWidget {
  final String employeeId;
  final String docId;
  const AcceptPayments({
    super.key,
    required this.docId,
    required this.employeeId,
  });

  @override
  State<AcceptPayments> createState() => _AcceptPaymentsState();
}

class _AcceptPaymentsState extends State<AcceptPayments> {
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
          title: const Text("Approve payments for work done."),
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

  Widget _ratingBar({required BuildContext context, required String rating}) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          allowHalfRating: true,
          initialRating: double.tryParse(rating) as double,
          itemSize: 25,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
        ),
        Text(
          rating.toString(),
        )
      ],
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
              "Amount Payable to the client",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          FadeInRightBig(child: Text("Ksh:$estimatedPrice")),
          const SizedBox(height: 10),
          const Divider(),
          FadeInLeftBig(
            child: const Text(
              "Rate this client",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          FadeInRightBig(child:_ratingBar(
                          context: context,
                          rating: 0.0.toString(),
          )
          ),
          const SizedBox(height: 10),
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
                                    "Confirm rejecting this payment approval."),
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
                                          .declinePayments(
                                        context: context,
                                        docId: widget.docId,
                                      )
                                          .then((value) {
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
                                    "Confirm accepting this payment approval."),
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
                                          .acceptPayments(
                                        context: context,
                                        docId: widget.docId, 
                                        amount:estimatedPrice, 
                                        employeeId:widget.employeeId,
                                      )
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text(
                                      "ok",
                                      style: TextStyle(
                                        color: AppColors.kPrimaryColorTwo,
                                      ),
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
