import 'package:flutter/material.dart';

class PlaceAddress extends StatelessWidget {
  final String address;

  const PlaceAddress({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Dirección: $address",
      style: const TextStyle(fontSize: 16),
    );
  }
}
