import 'package:Niajiri/auth/changePassword.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/profile/updateprofile.dart';
import 'components/settingtile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Niajiri/exceptions/firebaseauth.dart';




class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themedata=GetStorage();
  
 

  @override
  Widget build(BuildContext context) {
    themedata.writeIfNull("darkmode",false);
    bool isDarkMode=themedata.read("darkmode");

    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Ionicons.arrow_back_outline,
          size: 20,
          color: isDarkMode ? Colors.white : AppColors.kPrimaryColor,
        ),
      ),
        title:Text("Settings",style:TextStyle(color:isDarkMode ? Colors.white : AppColors.kPrimaryColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: <Widget>[
          FadeInLeftBig(
            child: SettingTile(
              color: Colors.green,
              icon: Ionicons.pencil_outline,
              label: "Edit info",
              onPress: () {
                Get.to(()=>const UpdateProfile());
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeInRightBig(
            child: ListTile(
              onTap:(){},
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                child: Icon(
                  isDarkMode ? Ionicons.sunny_outline : Ionicons.moon_outline,
                  color: Colors.white,
                ),
              ),
              title: Text("Theme", style: Theme.of(context).textTheme.bodyLarge),
              trailing:  Switch(
                  activeColor:AppColors.kPrimaryColorTwo,
                  value:isDarkMode,
                  onChanged: (bool value) {
                  setState((){
                    isDarkMode=value;
                  });
                  isDarkMode ? Get.changeTheme(ThemeData.dark()) : Get.changeTheme(ThemeData.light());
                  themedata.write("darkmode",value);
                  }
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeInRightBig(
            child: SettingTile(
              color: Colors.lightBlue,
              icon: Ionicons.language_outline,
              label: "Language",
              onPress: () {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),FadeInRightBig(
            child: SettingTile(
              color: Colors.teal,
              icon: Ionicons.lock_closed_outline,
              label: "Change Password",
              onPress: () {
                Get.to(()=>const ChangePasswordScreen());
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeInLeftBig(
            child: SettingTile(
              color: Colors.red,
              icon: Ionicons.log_out_outline,
              label: "Logout",
              onPress: () async {
                AuthRepository.instance.logout(context);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
