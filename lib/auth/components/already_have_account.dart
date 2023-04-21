import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: isDarkMode ? Colors.white : AppColors.kPrimaryColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.kPrimaryColor,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
