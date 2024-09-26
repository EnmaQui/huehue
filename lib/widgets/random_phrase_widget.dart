import 'package:flutter/material.dart';
import '../data/phrases.dart';
import 'dart:math';

class RandomPhraseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final phrase = phrases[random.nextInt(phrases.length)];

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            spreadRadius: 1.0,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Text(
        phrase,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.teal[600]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
