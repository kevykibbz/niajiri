import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class _LightColors {
  static const background = Colors.white;
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
  static const card = AppColors.cardDark;
}

class AppTheme {

  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  final darkBase = ThemeData.dark();
  final lightBase = ThemeData.light();

  /// Light theme and its settings.
  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        visualDensity: visualDensity,
        textTheme:GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
        appBarTheme: lightBase.appBarTheme.copyWith(
          iconTheme: lightBase.iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: AppColors.textDark,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        scaffoldBackgroundColor: _LightColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.kPrimaryLightColor,
          iconColor: AppColors.kPrimaryColor,
          prefixIconColor: AppColors.kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: MyConfig.defaultPadding, vertical: MyConfig.defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
        cardColor: _LightColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconDark), colorScheme: lightBase.colorScheme.copyWith(secondary: accentColor).copyWith(background: _LightColors.background),
      );

  /// Dark theme and its settings.
  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        visualDensity: visualDensity,
        textTheme:GoogleFonts.interTextTheme().apply(bodyColor: AppColors.textLigth),
        appBarTheme: darkBase.appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        scaffoldBackgroundColor: _DarkColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 3,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.kPrimaryLightColor,
          iconColor: AppColors.kPrimaryColor,
          prefixIconColor: AppColors.kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: MyConfig.defaultPadding, vertical: MyConfig.defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
        cardColor: _DarkColors.card,
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: AppColors.textLigth),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconLight), colorScheme: darkBase.colorScheme.copyWith(secondary: accentColor).copyWith(background: _DarkColors.background),
      );
}
