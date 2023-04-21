import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/terms/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Niajiri/config/config.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final themedata = GetStorage();
bool isDarkMode = themedata.read("darkmode") ?? false;

class WelcomeImage extends StatefulWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcomeImage> createState() => _WelcomeImageState();
}

class _WelcomeImageState extends State<WelcomeImage> {
  bool remember = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FadeInRightBig(
            child: const Text(
              "WELCOME TO ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Text(
            MyConfig.appName.toUpperCase(),
            style: const TextStyle(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: AppColors.kPrimaryColor,
                fontFamily: "kids_club"),
          ),
        ]),
        const SizedBox(height: MyConfig.defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: FadeInDownBig(
                child: SvgPicture.asset("assets/images/icons/chat.svg",
                    width: 250),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: MyConfig.defaultPadding * 2),
        Padding(
          padding: const EdgeInsets.only(left:20),
          child: Row(children: [
            Theme(
              data: ThemeData(
                  unselectedWidgetColor:
                      isDarkMode ? Colors.white : AppColors.kPrimaryColor),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: AppColors.kPrimaryColor,
                value: remember,
                onChanged: ((value) {
                  setState(() {
                    remember = value!;
                  });
                }),
              ),
            ),
            const Text("Accept our "),
            InkWell(
                onTap: () {
                  Get.to(() => const TermsAndConditionsScreen());
                },
                child: const Text("Terms and Conditions",
                    style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold)))
          ]),
        ),
        const SizedBox(height:10),
      ],
    );
  }
}
