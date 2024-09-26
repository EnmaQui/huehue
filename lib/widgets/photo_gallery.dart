import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> images; // Para URLs
  final List<ImageProvider> localImages; // Para imágenes locales

  const PhotoGallery({
    Key? key,
    required this.images,
    this.localImages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Comprobar si hay imágenes disponibles
    if (images.isEmpty && localImages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text('No hay imágenes disponibles', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    // Combina ambas listas para el GridView
    final combinedImages = [...images.map((url) => NetworkImage(url)), ...localImages];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Número de columnas
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: combinedImages.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Ampliar la imagen al tocar
              showDialog(
                context: context,
                barrierDismissible: true, // Permite cerrar el diálogo tocando fuera de él
                builder: (BuildContext context) {
                  return Container(
                    color: Colors.black.withOpacity(0.9), // Fondo negro semitransparente
                    child: Stack(
                      children: [
                        PhotoViewGallery.builder(
                          itemCount: combinedImages.length,
                          builder: (BuildContext context, int itemIndex) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: combinedImages[itemIndex],
                              minScale: PhotoViewComputedScale.contained, // Mantiene la imagen en su tamaño original
                              maxScale: PhotoViewComputedScale.covered * 2, // Permite hacer zoom
                            );
                          },
                          scrollPhysics: BouncingScrollPhysics(),
                          pageController: PageController(initialPage: index), // Muestra la imagen seleccionada
                        ),
                        Positioned(
                          top: 30,
                          right: 20,
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.white, size: 30),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
              child: Image(
                image: combinedImages[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ); // Icono de error si la imagen no se carga
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
