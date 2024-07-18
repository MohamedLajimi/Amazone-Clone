import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: GlobalVariables.selectedNavBarColor,
        ),
      ),
    );
  }
}
