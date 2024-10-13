import 'package:flutter/material.dart';

class PlaceDetailsWidget extends StatelessWidget {
  final String name;
  final double rating;
  final bool openNow;
  final List<String> photos;
  final List<dynamic> reviews; // Agregado para las reseñas

  const PlaceDetailsWidget({
    Key? key,
    required this.name,
    required this.rating,
    required this.openNow,
    required this.photos,
    required this.reviews, // Requerido
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre del lugar
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Rating y estado abierto/cerrado
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(
                    ' $rating',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const Spacer(),
                  Icon(
                    openNow ? Icons.check_circle : Icons.cancel,
                    color: openNow ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  Text(
                    openNow ? ' Abierto Ahora' : ' Cerrado',
                    style: TextStyle(
                      fontSize: 16,
                      color: openNow ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Visualización de imágenes
              if (photos.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            photos[index],
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 100);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text(
                  'No hay fotos disponibles',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

              const SizedBox(height: 12),

              // Tabla de reseñas
              const Text(
                'Reseñas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Lista de reseñas
              for (var review in reviews) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        review['text'] ?? 'Sin reseña', // Asegúrate de que la clave sea correcta
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
