import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      {required context,
      required String filePath,
      required String fileName}) async {
    File file = File(filePath);
    try {
      await storage.ref("uploads/$fileName").putFile(file);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
        ),
      );
    }
  }


  Future<String> getDownloadUrl({required String fileName}) async {
    String downloadUrl =await storage.ref("uploads/$fileName").getDownloadURL();
    return downloadUrl;
  }
}
