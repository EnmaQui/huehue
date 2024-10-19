enum PriceLevelEnum { free, cheap, moderate, expensive, veryExpensive }

extension PriceLevelExtension on PriceLevelEnum {
  // Obtener el valor numérico
  int get value {
    switch (this) {
      case PriceLevelEnum.free:
        return 0;
      case PriceLevelEnum.cheap:
        return 1;
      case PriceLevelEnum.moderate:
        return 2;
      case PriceLevelEnum.expensive:
        return 3;
      case PriceLevelEnum.veryExpensive:
        return 4;
      default:
        return 0;
    }
  }

  // Método estático para convertir un número en un enum
  static PriceLevelEnum fromValue(int value) {
    switch (value) {
      case 0:
        return PriceLevelEnum.free;
      case 1:
        return PriceLevelEnum.cheap;
      case 2:
        return PriceLevelEnum.moderate;
      case 3:
        return PriceLevelEnum.expensive;
      case 4:
        return PriceLevelEnum.veryExpensive;
      default:
        throw ArgumentError('Invalid price level value: $value');
    }
  }
}
