import 'package:flutter/material.dart';

class PlaceWebsite extends StatelessWidget {
  final String website;

  const PlaceWebsite({required this.website, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sitio web: $website",
      style: const TextStyle(fontSize: 16),
    );
  }
}
