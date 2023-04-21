// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart" show rootBundle;

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String textFromFile = '';

  getData() async {
    String response;
    response = await rootBundle.loadString("assets/terms/terms.txt");
    setState(() {
      textFromFile = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Terms and Conditions"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              size: 20,
              progress: ProxyAnimation(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInRightBig(child: Text(textFromFile))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
