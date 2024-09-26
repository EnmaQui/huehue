import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final String reviewerName;
  final String reviewText;
  final double rating;
  final List<String> photos;

  const ReviewWidget({
    Key? key,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.photos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del revisor
            ClipOval(
              child: SizedBox(
                width: 50, // Ajusta el tamaño de la imagen
                height: 50,
                child: Image.network(
                  photos.isNotEmpty ? photos[0] : 'default_image_url', // URL de imagen por defecto si no hay fotos
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10), // Espacio entre la imagen y el texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del revisor
                  Text(
                    reviewerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333), // Color del nombre
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Calificación en forma de estrellas
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFEF476F), // Color de las estrellas
                      );
                    }),
                  ),
                  const SizedBox(height: 5),
                  // Texto de la reseña
                  Text(
                    reviewText,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewListWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reviews.isNotEmpty
        ? ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewWidget(
          reviewerName: review['reviewer_name'],
          reviewText: review['review_text'],
          rating: review['rating'],
          photos: List<String>.from(review['photos']),
        );
      },
    )
        : const Center(child: Text('No hay reseñas disponibles'));
  }
}
