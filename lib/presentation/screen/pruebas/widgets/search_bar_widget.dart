import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          // color: Color(0xffF4F6FF),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: const  Row(
          children: [
             Icon(Iconsax.search_normal, color: Colors.white),
             SizedBox(width: 10),
              Text("Buscalo", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}