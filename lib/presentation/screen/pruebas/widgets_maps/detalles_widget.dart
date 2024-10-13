import 'package:flutter/material.dart';

class PlaceDetailsWidget extends StatelessWidget {
  final String name;
  final double rating;
  final bool openNow;
  final List<String> photos;
  final List<String> reviews; // Cambiado a List<String>
  final Map<String, dynamic> openingHours;

  const PlaceDetailsWidget({
    Key? key,
    required this.name,
    required this.rating,
    required this.openNow,
    required this.photos,
    required this.reviews,
    required this.openingHours,
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

              // Carrusel de imágenes
              if (photos.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navegar a la pantalla de imagen completa
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                imageUrl: photos[index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: photos[index],
                            child: Image.network(
                              photos[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 100);
                              },
                            ),
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

              // Tabla de horarios de apertura
              const Text(
                'Horarios de Apertura',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildOpeningHours(openingHours),

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
                        review, // Asumimos que es un String
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
Widget _buildOpeningHours(Map<String, dynamic> openingHours) {
  final periods = openingHours['periods'] ?? [];
  final weekdayText = openingHours['weekday_text'] ?? [];

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey[300]!),
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1),
        },
        children: [
          // Encabezado de la tabla
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[200]),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Día',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Horario',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Filas de los horarios
          for (var dayInfo in weekdayText)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dayInfo.split(':')[0], // Obtiene el día (antes de los dos puntos)
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dayInfo.substring(dayInfo.indexOf(':') + 1).trim(), // Obtiene el horario (todo después de los dos puntos)
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          // Mensaje si no hay horarios
          if (weekdayText.isEmpty)
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No hay horarios disponibles', style: TextStyle(fontSize: 16)),
                ),
                SizedBox.shrink(),
              ],
            ),
        ],
      ),
    ),
  );
}




class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
