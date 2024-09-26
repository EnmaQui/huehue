import 'package:google_maps_flutter/google_maps_flutter.dart';

class Department {
  final String name;
  final String description;
  final LatLng coordinates;

  const Department({
    required this.name,
    required this.description,
    required this.coordinates,
  });
}

List<Department> getDepartments() {
  return const [
    Department(
      name: 'Boaco',
      description: 'Departamento ubicado al centro del país...',
      coordinates: LatLng(12.4667, -85.6667),
    ),
    Department(
      name: 'Carazo',
      description: 'Pequeño departamento ubicado en el Pacífico...',
      coordinates: LatLng(11.8500, -86.2000),
    ),
    Department(
      name: 'Chinandega',
      description: 'Famoso por sus playas y volcanes...',
      coordinates: LatLng(12.6296, -87.1325),
    ),
    Department(
      name: 'Chontales',
      description: 'Región ganadera y minera...',
      coordinates: LatLng(12.0833, -85.4000),
    ),
    Department(
      name: 'Estelí',
      description: 'Famoso por su producción de tabaco...',
      coordinates: LatLng(13.0833, -86.3667),
    ),
    Department(
      name: 'Granada',
      description: 'Ciudad colonial y turística...',
      coordinates: LatLng(11.9333, -85.9500),
    ),
    Department(
      name: 'Jinotega',
      description: 'Zona montañosa y productora de café...',
      coordinates: LatLng(13.1000, -85.9967),
    ),
    Department(
      name: 'León',
      description: 'Ciudad universitaria con historia colonial...',
      coordinates: LatLng(12.4344, -86.8780),
    ),
    Department(
      name: 'Madriz',
      description: 'Pequeño departamento montañoso...',
      coordinates: LatLng(13.5000, -86.5833),
    ),
    Department(
      name: 'Managua',
      description: 'Capital del país y centro económico...',
      coordinates: LatLng(12.1364, -86.2514),
    ),
    Department(
      name: 'Masaya',
      description: 'Famoso por su artesanía y volcán...',
      coordinates: LatLng(11.9667, -86.1000),
    ),
    Department(
      name: 'Matagalpa',
      description: 'Famoso por su producción de café...',
      coordinates: LatLng(12.9167, -85.9167),
    ),
    Department(
      name: 'Nueva Segovia',
      description: 'Zona fronteriza y productora de tabaco...',
      coordinates: LatLng(13.6333, -86.4833),
    ),
    Department(
      name: 'Rivas',
      description: 'Famoso por sus playas y turismo...',
      coordinates: LatLng(11.4399, -85.8259),
    ),
    Department(
      name: 'Río San Juan',
      description: 'Rico en biodiversidad y naturaleza...',
      coordinates: LatLng(11.0333, -84.7833),
    ),
    Department(
      name: 'Región Autónoma de la Costa Caribe Norte',
      description: 'Zona rica en recursos naturales...',
      coordinates: LatLng(14.0387, -83.3872),
    ),
    Department(
      name: 'Región Autónoma de la Costa Caribe Sur',
      description: 'Conocida por su cultura diversa...',
      coordinates: LatLng(12.1401, -83.5793),
    ),
  ];
}
