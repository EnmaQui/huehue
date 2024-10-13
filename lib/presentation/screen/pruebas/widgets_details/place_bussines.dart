import 'package:flutter/material.dart';

class BusinessStatus extends StatelessWidget {
  final String status;

  const BusinessStatus({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Estado del negocio: $status",
      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }
}
