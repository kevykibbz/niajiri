import 'package:Niajiri/dashboard.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Niajiri/mpesa/mpesa.dart';


bool isloading = false;
int estimatedPayments = 0;

final user = FirebaseAuth.instance.currentUser!;

class PaymentScreen extends StatefulWidget {
  final String docId;
  const PaymentScreen({
    super.key,
    required this.docId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(docId: widget.docId),
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
                      child: CreateFormSegment(
                        docId: widget.docId,
                      ),
                    ),
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
  final String docId;
  const MobileLoginScreen({
    Key? key,
    required this.docId,
  }) : super(key: key);

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
                "Make your payments now.",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: CreateFormSegment(docId: widget.docId),
            )
          ],
        ),
      ),
    );
  }
}

class CreateFormSegment extends StatefulWidget {
  final String docId;
  const CreateFormSegment({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<CreateFormSegment> createState() => _CreateFormSegmentState();
}

class _CreateFormSegmentState extends State<CreateFormSegment> {
  final paymentFormKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController priceEstimation = TextEditingController();
  TextEditingController serviceCharge = TextEditingController();
  TextEditingController totalCharge = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("/proposals")
        .doc(widget.docId)
        .get()
        .then((value) {
      var data = value.data() as Map;
      var proposedPayment = int.parse(data['ProposedPayment']);
      var serviceChargeFee = 0.02 * proposedPayment;
      var totalPayment = proposedPayment + serviceChargeFee;
      priceEstimation.text = proposedPayment.toString();
      serviceCharge.text =serviceChargeFee.toStringAsFixed(0);
      totalCharge.text = totalPayment.toStringAsFixed(0);
    });
    return Form(
      key: paymentFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        const Text("Payment stage."),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Proposed payment',
            hintText: "Your proposed payments",
            controller: priceEstimation,
            isEnabled: false,
            icon: Ionicons.keypad_sharp,
            validatorName: 'payments',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Service charge(2%)',
            hintText: "Total Service charge",
            controller: serviceCharge,
            isEnabled: false,
            icon: Ionicons.keypad_sharp,
            validatorName: 'payments',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Total payments',
            hintText: "Total payments",
            controller: totalCharge,
            isEnabled: false,
            icon: Ionicons.keypad_sharp,
            validatorName: 'payments',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        FadeInLeftBig(
          child: BuildTextInputField(
            label: 'Phone number',
            hintText: "Your Mpesa Phone number",
            controller: phoneController,
            isNumber:true,
            isPhoneType:true,
            icon: Ionicons.phone_portrait_outline,
            validatorName: 'phone',
          ),
        ),
        const SizedBox(height: MyConfig.defaultPadding),
        isloading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.kPrimaryColor),
              )
            : FadeInRightBig(
                child: CustomBtn(
                    label: 'Pay'.toUpperCase(),
                    tag: "Pay_btn",
                    onPressed: () async {
                      if (paymentFormKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        MpesaManager().startCheckout(
                          context,
                          phoneNumber: "254${phoneController.text}",
                          amount:double.parse(totalCharge.text.trim()));
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
              onTap: () async {
                final cartList = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("cart")
                    .where("Proposed", isEqualTo: false);
                AggregateQuerySnapshot query = await cartList.count().get();
                if (query.count > 0) {
                  Get.to(() => const SelectSkillPage());
                } else {
                  Get.to(() => const DashboardPage());
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
