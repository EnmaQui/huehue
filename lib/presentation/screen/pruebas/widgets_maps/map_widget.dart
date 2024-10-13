import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onPlaceSelected; // Callback para manejar la selección de lugar

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.markers,
    required this.onMapCreated,
    required this.onPlaceSelected, // Recibe el callback
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 15,
      ),
      markers: markers,
      onTap: (LatLng position) {
        // Manejar el tap en el mapa, por si es necesario
      },
    );
  }
}
