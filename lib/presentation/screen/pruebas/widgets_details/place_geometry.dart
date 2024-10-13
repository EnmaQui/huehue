import 'package:flutter/material.dart';

class PlaceGeometry extends StatelessWidget {
  final Map<String, dynamic> location;

  const PlaceGeometry({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ubicación",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Latitud: ${location['lat']}", style: const TextStyle(fontSize: 16)),
            Text("Longitud: ${location['lng']}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
