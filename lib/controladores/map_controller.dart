import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  static late GoogleMapController _mapController;

  // Método que se llama cuando el mapa es creado
  static void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Método para mover la cámara a una posición específica
  static void moveCameraToPosition(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  // Método para hacer zoom
  static void zoomIn() {
    _mapController.animateCamera(CameraUpdate.zoomIn());
  }

  static void zoomOut() {
    _mapController.animateCamera(CameraUpdate.zoomOut());
  }

  // Método para dibujar una polilínea en el mapa
  static void drawPolyline(Polyline polyline) {
    // Puedes agregar la lógica para dibujar la polilínea aquí
  }

  // Método para limpiar las polilíneas
  static void clearPolylines() {
    // Lógica para limpiar las polilíneas del mapa
  }
}
