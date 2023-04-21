import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/config/config.dart';
import 'package:flutter/material.dart';

class BuildTextInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String validatorName;
  final String confirmPasswordValue;
  final TextEditingController controller;
  final IconData icon;
  final bool isLogin;
  final bool isPasswordType;
  final bool isTextarea;
  final bool isEnabled;
  final double numberValidator;
  final bool isNumber;
  final bool isPhoneType;
  final bool isConfirmPasswordType;
  const BuildTextInputField({
    Key? key,
    required this.label,
    this.hintText,
    required this.icon,
    required this.controller,
    required this.validatorName,
    this.isTextarea = false,
    this.isLogin = false,
    this.isEnabled = true,
    this.isPasswordType = false,
    this.isPhoneType = false,
    this.isConfirmPasswordType = false,
    this.isNumber = false,
    this.numberValidator = 0.0,
    this.confirmPasswordValue = '',
  }) : super(key: key);

  @override
  State<BuildTextInputField> createState() => _BuildTextInputFieldState();
}

class _BuildTextInputFieldState extends State<BuildTextInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          enabled: widget.isEnabled,
          enableInteractiveSelection: widget.isEnabled,
          obscureText: widget.isPasswordType,
          enableSuggestions: !widget.isPasswordType,
          textInputAction: TextInputAction.done,
          autocorrect: !widget.isPasswordType,
          cursorColor: AppColors.kPrimaryColor,
          controller: widget.controller,
          keyboardType: widget.isPasswordType
              ? TextInputType.visiblePassword
              : (widget.isNumber
                  ? TextInputType.number
                  : TextInputType.emailAddress),
          validator: (value) {
            switch (widget.validatorName) {
              case "amount":
                if (value == null || value.isEmpty) {
                  return "Please enter amount.";
                } else if (double.parse(value) < widget.numberValidator) {
                  var label = widget.label;
                  var amountString = widget.numberValidator.toString();
                  return "$label cant be less than ksh $amountString";
                }
                break;
              case "displayName":
                if (value == null || value.isEmpty) {
                  return "Please enter your full name";
                }
                break;
              case "description":
                if (value == null || value.isEmpty) {
                  return "Please provide your job description.";
                }
                break;
              case "payments":
                if (value == null || value.isEmpty) {
                  return "Please provide your proposed payments.";
                } else if (int.parse(value) < 1) {
                  return "Amount should be greater than 0.";
                }
                break;
              case "payment":
                if (value == null || value.isEmpty) {
                  return "Please enter your preffered payment rates";
                } else if (int.parse(value) < 1) {
                  return "Amount should be greater than 0.";
                }
                break;
              case "skillName":
                if (value == null || value.isEmpty) {
                  return "Please enter your skill.";
                }
                break;
              case "idNumber":
                if (value == null || value.isEmpty) {
                  return "Please enter your ID number";
                } else if (value.length < 8 || value.length > 8) {
                  return "Please enter a valid ID number";
                }
                break;
              case "phone":
                if (value == null || value.isEmpty) {
                  return "Please enter your mobile number";
                } else if (value.length < 9 || value.length > 9) {
                  return "Please enter a valid mobile number eg 796...";
                }
                break;
              case "username":
                if (value == null || value.isEmpty) {
                  return "Please enter your username";
                } else if (value.length < 4) {
                  return "Username too short";
                }
                break;
              case 'email':
                if (value == null || value.isEmpty) {
                  return "Please enter your email address";
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(value)) {
                  return "Enter a valid email address";
                }
                break;
              case 'password':
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else if (!widget.isLogin && value.length < 6) {
                  return "password too short.Max of 6 chars or long";
                }
                break;
              case 'oldpassword':
                if (value == null || value.isEmpty) {
                  return "Please enter your old password";
                }
                break;
              case 'confirm password':
                if (value == null || value.isEmpty) {
                  return "Please enter confirm password";
                }
                break;
              default:
                return null;
            }
            return null;
          },
          style: const TextStyle(color: AppColors.kPrimaryColor),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: AppColors.kPrimaryColor),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColors.kPrimaryColor),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(widget.isTextarea
                  ? const Radius.circular(30)
                  : const Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: MyConfig.defaultPadding,
                vertical: MyConfig.defaultPadding),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kPrimaryColor),
                borderRadius:
                    BorderRadius.circular(widget.isTextarea ? 30 : 10),
                gapPadding: 10),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(MyConfig.defaultPadding),
              child: Icon(widget.icon),
            ),
            filled: true,
            fillColor: AppColors.kPrimaryLightColor,
            iconColor: AppColors.kPrimaryColor,
            prefixIconColor: AppColors.kPrimaryColor,
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
