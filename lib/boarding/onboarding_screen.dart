import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import 'package:Niajiri/welcome/welcome.dart';
import 'package:Niajiri/boarding/card_planet.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:lottie/lottie.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final String myAppName = MyConfig.appName;

  final data = [
    CardPlanetData(
      title: "SkillMatch",
      subtitle:
          "Connecting skilled workers with job opportunities",
      image: const AssetImage("assets/images/onboarding_screen/img-1.png"),
      backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
      titleColor: Colors.pink,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-1.json"),
    ),
    CardPlanetData(
      title: "JobBridge",
      subtitle: "Bridging the gap between skilled workers and job opportunities",
      image: const AssetImage("assets/images/onboarding_screen/img-2.png"),
      backgroundColor: Colors.white,
      titleColor: Colors.purple,
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: LottieBuilder.asset("assets/animation/bg-2.json"),
    ),
    CardPlanetData(
      title: "HireMe",
      subtitle: "Finding jobs for skilled workers one hire at a time.",
      image: const AssetImage("assets/images/onboarding_screen/img-3.png"),
      backgroundColor: const Color.fromRGBO(71, 59, 117, 1),
      titleColor: Colors.yellow,
      subtitleColor: Colors.white,
      background: LottieBuilder.asset("assets/animation/bg-3.json"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return FadeInLeftBig(child: CardPlanet(data: data[index]));
        },
        onFinish: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        },
      ),
    );
  }
}
