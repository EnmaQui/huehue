import 'package:flutter/material.dart';

class TopImageWidget extends StatelessWidget {
  final String imagePath;

  const TopImageWidget({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
