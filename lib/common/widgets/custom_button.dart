import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = GlobalVariables.secondaryColor,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: color,
            minimumSize: const Size(double.infinity, 50)),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ));
  }
}
