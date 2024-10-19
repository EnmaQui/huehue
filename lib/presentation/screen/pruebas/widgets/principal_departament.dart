import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrincipalDepartament extends StatelessWidget {
  const PrincipalDepartament({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(1, 1),
          ),
        ]
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                progressIndicatorBuilder:
                    (context, url, progress) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors
                      .black54, // Color en la parte superior
                  Colors
                      .transparent, // Color en la parte inferior
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
