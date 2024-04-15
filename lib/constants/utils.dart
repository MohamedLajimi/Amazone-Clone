import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: GlobalVariables.selectedNavBarColor,
    content: Text(text),
  ));
}
