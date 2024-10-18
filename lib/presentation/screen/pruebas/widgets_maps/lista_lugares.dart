import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huehue/domain/entity/place/PlaceEntity.dart';
import 'package:huehue/presentation/widgets/list/BaseListWidget.dart';

class PlaceListWidget extends StatelessWidget {
  final List<PlaceEntity> places;
  final Function(dynamic, LatLng) onPlaceSelected; // Actualiza el tipo de función
  final bool isLoading;

  const PlaceListWidget({
    super.key,
    required this.places,
    required this.onPlaceSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (places.isEmpty) {
      return const Center(child: Text('No se encontraron lugares.'));
    }

    return BaseListWidget(
      itemCount: places.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final place = places[index];
        final LatLng position = place.coordinates;

        return Card(
          elevation: 4,
          // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              place.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              place.vicinity,
              style: const TextStyle(color: Colors.grey),
            ),
            // trailing: place['rating'] != null
            //     ? Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           const Icon(Icons.star, color: Colors.amber, size: 20),
            //           Text(place['rating'].toString(),
            //               style: const TextStyle(fontSize: 16)),
            //         ],
            //       )
            //     : null,
            onTap: () {
              onPlaceSelected(place, position); // Pasa la posición del lugar seleccionado
            },
            // leading: place. != null && place['photos'].isNotEmpty
            //     ? ClipOval(
            //         child: Image.network(
            //           'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place['photos'][0]['photo_reference']}&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY',
            //           width: 50,
            //           height: 50,
            //           fit: BoxFit.cover,
            //         ),
            //       )
            //     : const CircleAvatar(
            //         backgroundColor: Colors.grey,
            //         child: Icon(Icons.place, color: Colors.white),
            //       ),
          ),
        );
      },
    );
  }
}
