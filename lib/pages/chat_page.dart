import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:Niajiri/pages/contact.dart';
import 'package:Niajiri/data/chats_json.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:Niajiri/pages/opened_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final themedata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeInDownBig(
        child: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          child: const Icon(Ionicons.person_outline, color: Colors.white),
          onPressed: () {
            Get.to(() => const ContactScreen());
          },
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: FadeInLeftBig(
                child: const Text(
                  "Stories",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kPrimaryColorTwo),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: FadeInLeftBig(
                  child: Row(
                    children: List.generate(
                      chats_json.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Stack(
                                  children: <Widget>[
                                    chats_json[index]['story']
                                        ? Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors
                                                        .kPrimaryColorTwo,
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
                                                            chats_json[index]
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
                                                        chats_json[index]['img']),
                                                    fit: BoxFit.cover)),
                                          ),
                                    chats_json[index]['online']
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
                                height: 10,
                              ),
                              SizedBox(
                                width: 70,
                                child: Align(
                                    child: Text(
                                  chats_json[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                )),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: FadeInUpBig(
                child: Column(
                  children: List.generate(
                    userMessages.length,
                    (index) {
                      return GestureDetector(
                        onTap:(){
                          Get.to(() => const OpenedChatPage());
                        },
                        child: Padding(
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
