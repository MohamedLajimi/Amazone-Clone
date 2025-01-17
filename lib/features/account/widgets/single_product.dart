import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  const SingleProduct({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1.5),
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(10),
        child: Image.network(
          image,
          fit: BoxFit.fitHeight,
          width: 180,
        ),
      ),
    );
  }
}
