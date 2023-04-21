import 'package:flutter/material.dart';
import 'package:Niajiri/config/colors.dart';
import 'package:badges/badges.dart' as badges;


class CreateBadge extends StatefulWidget {
  final int badgeContent;
  const CreateBadge({super.key, required this.badgeContent});

  @override
  State<CreateBadge> createState() => _CreateBadgeState();
}

class _CreateBadgeState extends State<CreateBadge> {
  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -10, end: -12),
      showBadge: true,
      ignorePointer: false,
      badgeContent: Text(widget.badgeContent.toString(),style:const TextStyle(color:Colors.white)),
      badgeStyle: badges.BadgeStyle(
        elevation: 2,
        badgeColor: Colors.redAccent,
        shape: badges.BadgeShape.circle,
        borderSide: BorderSide(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 2,
        ),
        borderGradient: const badges.BadgeGradient.linear(
          colors: [
            AppColors.kPrimaryColor,
            AppColors.kPrimaryColorTwo,
          ],
        ),
        badgeGradient: const badges.BadgeGradient.linear(
          colors: [AppColors.kPrimaryColor, AppColors.kPrimaryColorTwo],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}