import 'package:flutter/material.dart';

class PlaceListWidget extends StatelessWidget {
  final List<dynamic> places;
  final Function(dynamic) onPlaceSelected;
  final bool isLoading;

  const PlaceListWidget({
    super.key,
    required this.places,
    required this.onPlaceSelected,
    this.isLoading = false, // Estado para indicar carga
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Indicador de carga
    }

    if (places.isEmpty) {
      return const Center(child: Text('No se encontraron lugares.'));
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          elevation: 4, // Sombra para dar efecto de elevación
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10), // Espaciado interno
            title: Text(
              place['name'] ?? 'Nombre no disponible',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              place['vicinity'] ?? 'Ubicación no disponible',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: place['rating'] != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(place['rating'].toString(), style: const TextStyle(fontSize: 16)),
                    ],
                  )
                : null,
            onTap: () => onPlaceSelected(place), // Acción de selección
            leading: place['photos'] != null && place['photos'].isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=${place['photos'][0]['photo_reference']}&key=AIzaSyCNNLly_rF6NkMMgoFAl5dv8lfCmu00mnY',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.location_on, size: 40), // Placeholder si no hay foto
          ),
        );
      },
    );
  }
}
