import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class LocalAuthApi {
  static final _auth=LocalAuthentication();

  static Future<bool> hasBiometrics() async{
    try{
      return await _auth.canCheckBiometrics;
    // ignore: unused_catch_clause
    }on PlatformException catch (e){
      return false;
    }
  }

  static Future<bool> authenticate() async{
    final isAvailable=await hasBiometrics();

    if(!isAvailable) return false;

    try{
      return await _auth.authenticate(
        localizedReason:'Scan fingerprint to authenticate payment',
        options:const AuthenticationOptions(
          useErrorDialogs:true,
          stickyAuth:true,
        ),
      );
    // ignore: unused_catch_clause
    }on PlatformException catch (e){
      return false;
    }
  }
}