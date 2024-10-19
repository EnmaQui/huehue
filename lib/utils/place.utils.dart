class PlaceUtils {
  static String getTypeFromCategory(String category) {
    switch (category) {
      case 'Iglesias':
        return 'church'; // Tipo correspondiente a Iglesias
      case 'Restaurantes':
        return 'restaurant'; // Tipo correspondiente a Restaurantes
      case 'Monumentos':
        return 'museum'; // Tipo correspondiente a Monumentos
      case 'Edificios históricos':
        return 'point_of_interest'; // Tipo para Edificios históricos
      case 'Playas':
        return 'beach'; // Tipo para Playas
      case 'Reservas Naturales':
        return 'natural_feature'; // Tipo para Reservas Naturales
      case 'Parques':
        return 'park'; // Tipo para Parques
      case 'Tiendas de conveniencia':
        return 'convenience_store'; // Tipo para Tiendas de conveniencia
      case 'Centros comerciales':
        return 'shopping_mall'; // Tipo para Centros comerciales
      case 'Volcanes':
        return 'geological_feature'; // Tipo para Volcanes
      case 'Montañas':
        return 'mountain'; // Tipo para Montañas
      case 'Islas':
        return 'island'; // Tipo para Islas
      default:
        return 'establishment'; // Valor por defecto si no coincide con ninguna categoría
    }
  }
}