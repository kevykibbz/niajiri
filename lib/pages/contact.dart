import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/data/chats_json.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Niajiri/config/config.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:Niajiri/pages/opened_chat.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  final themedata = GetStorage();
  @override
  Widget build(BuildContext context) {
      bool isDarkMode=themedata.read("darkmode");
      
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Select contact"),
          leading:IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Ionicons.arrow_back_outline,
                color: isDarkMode ? Colors.white : AppColors.kPrimaryColor,
              ),
            ),
        ),
        body:getBody(),
    );
  }

  Widget getBody(){
    bool isDarkMode = themedata.read("darkmode") ?? false;

    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap:(){
            Get.to(() => const OpenedChatPage());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
            child: FadeInLeftBig(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  cursorColor: AppColors.kPrimaryColor,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.kPrimaryLightColor,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: MyConfig.defaultPadding,
                          vertical: MyConfig.defaultPadding),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.kPrimaryColor),
                          borderRadius: BorderRadius.circular(30),
                          gapPadding: 10),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.kPrimaryColor,
                      ),
                      hintText: "Search"),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: FadeInUpBig(
                child: Column(
                  children: List.generate(
                    userMessages.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: Stack(
                                children: <Widget>[
                                  userMessages[index]['story']
                                      ? Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      AppColors.kPrimaryColorTwo,
                                                  width: 3)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          userMessages[index]
                                                              ['img']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      userMessages[index]['img']),
                                                  fit: BoxFit.cover)),
                                        ),
                                  userMessages[index]['online']
                                      ? Positioned(
                                          top: 48,
                                          left: 52,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: green,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: white, width: 3)),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  userMessages[index]['name'],
                                  style: const TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 135,
                                  child: Text(
                                    userMessages[index]['message'] +
                                        " - " +
                                        userMessages[index]['created_at'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isDarkMode
                                            ? Colors.white
                                            : black.withOpacity(0.8)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}