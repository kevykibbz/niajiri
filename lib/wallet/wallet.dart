import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Niajiri/components/inputField.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController serviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    serviceController.text = "2";
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: FadeInUpBig(
        child: SizedBox(
          width: size.width,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  width: size.width - 70,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.kPrimaryColor,
                        AppColors.kPrimaryColorTwo
                      ],
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        "WITHDRAW",
                        style: TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey.shade50,
            height: size.height / 2,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: <Widget>[
                          Material(
                            elevation: 4,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/bg1.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.3,
                            child: Container(
                              color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                    ),
                    height: size.longestSide <= 775
                        ? size.height / 4
                        : size.height / 4.3,
                    width: size.width,
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        return true;
                      },
                      child: Center(
                        child: FadeInLeftBig(
                          child:const Text(
                            "Wallet Balance is Ksh:1200",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Varela"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Rate employer",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInRightBig(
                        child: _ratingBar(
                          context: context,
                          rating: 0.0.toString(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInLeftBig(
                        child: BuildTextInputField(
                          label: 'Amount to withdraw',
                          hintText: "Enter amount to withdraw",
                          controller: amountController,
                          icon: Ionicons.keypad_sharp,
                          validatorName: 'payments',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInLeftBig(
                        child: BuildTextInputField(
                          label: 'Service charge(2%)',
                          hintText: "Service charge fee(2%)",
                          isEnabled: false,
                          controller: serviceController,
                          icon: Ionicons.keypad_sharp,
                          validatorName: 'payments',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
}
