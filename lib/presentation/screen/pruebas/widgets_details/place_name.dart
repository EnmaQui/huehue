import 'package:flutter/material.dart';

class PlaceName extends StatelessWidget {
  final String name;

  const PlaceName({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}
