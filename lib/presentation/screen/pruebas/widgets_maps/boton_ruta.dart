// show_route_button.dart
import 'package:flutter/material.dart';

class ShowRouteButton extends StatelessWidget {
  final List<dynamic> places;
  final Function(double, double) onShowRoute;

  const ShowRouteButton({
    required this.places,
    required this.onShowRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (places.isNotEmpty) {
          final location = places[0]['geometry']['location'];
          onShowRoute(location['lat'], location['lng']);
        }
      },
      child: const Icon(Icons.directions),
    );
  }
}
