import 'package:Niajiri/config/colors.dart';
import 'package:Niajiri/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BottomSheetBtn extends StatelessWidget {
  final double size;
  final int badgeContent;
  final double iconSize;
  final Color color;
  final IconData icon;
  final VoidCallback onPress;
  final bool isNotificationIcon;
  const BottomSheetBtn(
      {super.key,
      required this.size,
      required this.color,
      required this.icon,
      required this.iconSize,
      this.badgeContent=0,
      this.isNotificationIcon=false,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:Border.all(color:AppColors.kPrimaryColorTwo),
        color: white,
        boxShadow: [
          BoxShadow(
            color: grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: onPress,
          child: isNotificationIcon ?
            badges.Badge(
              position:
                  badges.BadgePosition.topEnd(top: -20, end: -12),
              showBadge: true,
              ignorePointer: false,
              badgeContent: Text(
                badgeContent.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              badgeStyle: badges.BadgeStyle(
                elevation: 2,
                badgeColor: Colors.redAccent,
                shape: badges.BadgeShape.circle,
                borderSide: BorderSide(
                    color:
                        Theme.of(context).scaffoldBackgroundColor,
                    width: 2),
                borderGradient: const badges.BadgeGradient.linear(
                    colors: [
                      AppColors.kPrimaryColor,
                      AppColors.kPrimaryColorTwo
                    ]),
                badgeGradient: const badges.BadgeGradient.linear(
                    colors: [
                      AppColors.kPrimaryColor,
                      AppColors.kPrimaryColorTwo
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: color,
              ),
            )
          :
          Icon(
            icon,
            size: iconSize,
            color: color,
          ),
        ),
      ),
    );
  }
}