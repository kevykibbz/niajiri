import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class OpenedNotificationPage extends StatefulWidget {
  const OpenedNotificationPage({super.key});

  @override
  State<OpenedNotificationPage> createState() => _OpenedNotificationPageState();
}

class _OpenedNotificationPageState extends State<OpenedNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
          ),
          title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Icon(
                  Ionicons.mail_open_outline,
                  size: 20,
                ),
                Expanded(child: Text(" Fuel Payment")),
              ]),
        ),
        body: const Center(
          child:Text("Opened notifications page")
        )
    );
  }
}
