import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPress;
  const SettingTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  State<SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: widget.color),
        child: Icon(
          widget.icon,
          color: Colors.white,
        ),
      ),
      title: Text(widget.label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.kPrimaryColor.withOpacity(0.2),
        ),
        child: const Icon(
          Ionicons.chevron_forward_outline,
          color: AppColors.kPrimaryColor,
          size: 16,
        ),
      ),
    );
  }
}
