import 'package:flutter/material.dart';


class RequestLocationPermissionPage extends StatefulWidget {
  const RequestLocationPermissionPage({
    super.key,
  });

  @override
  State<RequestLocationPermissionPage> createState() => _RequestLocationPermissionPageState();
}

class _RequestLocationPermissionPageState extends State<RequestLocationPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Location permission page"));
  }
}
