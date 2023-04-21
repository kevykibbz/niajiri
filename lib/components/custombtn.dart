import 'package:Niajiri/config/colors.dart';
import 'package:flutter/material.dart';


class CustomBtn extends StatelessWidget {
  final String label;
  final String tag;
  final IconData? icon;
  final Color? color;
  final VoidCallback onPressed;
  const CustomBtn(
    {
      Key? key,
      required this.label,
      required this.tag,
      required this.onPressed,
      this.color,
      this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      height:60,
      padding: const EdgeInsets.only(left: 3),
      child: Hero(
        tag: tag,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
          elevation: 3,
            backgroundColor: AppColors.kPrimaryColor,
            shape: const StadiumBorder(),
            disabledBackgroundColor:Colors.grey,
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
          child:Row(
            mainAxisAlignment:MainAxisAlignment.center,
              children:<Widget>[
              Icon(icon),
              Text(label,style:const TextStyle(fontSize:20))
            ]
          ),
        ),
      ),
    );
  }
}

