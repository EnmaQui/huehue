import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MapDetailsPlace extends StatelessWidget {
  const MapDetailsPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      snap: true,
      snapSizes: const [0.4, 0.6],
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                   padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        sm: 12,
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
