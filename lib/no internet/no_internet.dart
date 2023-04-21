import 'package:Niajiri/components/custombtn.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isloading = false;

class NoConnection extends StatefulWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  NoConnectionState createState() => NoConnectionState();
}

class NoConnectionState extends State<NoConnection> {
 

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FadeInUpBig(child: Image.asset('assets/images/no-connection.gif',)),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  FadeInRightBig(
                    child: const Text(
                      "Ooops! 😓",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kPrimaryColor),
                    ),
                  ),
                  const SizedBox(
                    height:10,
                  ),
                  FadeInLeftBig(
                    child: const Text(
                      "No internet connection found. Check your connection or try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeInDown(
                    child: isloading
                        ? const CircularProgressIndicator()
                        :  CustomBtn(
                            label: 'Try again'.toUpperCase(),
                            tag: "retry_btn",
                            onPressed: () async{
                                await Connectivity()
                                  .checkConnectivity()
                                  .then((subscription) {
                                setState(() {
                                  isloading = true;
                                });
                                if (subscription == ConnectivityResult.mobile) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.wifi) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.bluetooth) {
                                  Get.back();
                                } else if (subscription ==
                                    ConnectivityResult.ethernet) {
                                  Get.back();
                                } else {
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              }).then((value){
                                setState(() {
                                    isloading = false;
                                });
                              });
                            }
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
