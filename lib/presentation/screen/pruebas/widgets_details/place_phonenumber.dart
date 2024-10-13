import 'package:flutter/material.dart';

class PlacePhoneNumber extends StatelessWidget {
  final String phoneNumber;

  const PlacePhoneNumber({required this.phoneNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Teléfono: $phoneNumber",
      style: const TextStyle(fontSize: 16),
    );
  }
}
