/// Constantes y datos relacionados con Venezuela
library;

/// Estados de Venezuela
class VenezuelaStates {
  static const List<String> states = [
    'Amazonas',
    'Anzoátegui',
    'Apure',
    'Aragua',
    'Barinas',
    'Bolívar',
    'Carabobo',
    'Cojedes',
    'Delta Amacuro',
    'Distrito Capital',
    'Falcón',
    'Guárico',
    'Lara',
    'Mérida',
    'Miranda',
    'Monagas',
    'Nueva Esparta',
    'Portuguesa',
    'Sucre',
    'Táchira',
    'Trujillo',
    'Vargas',
    'Yaracuy',
    'Zulia',
  ];
}

/// Tipos de documento de identidad
class DocumentTypes {
  static const List<String> types = ['V', 'E', 'J', 'P'];

  static String getFullName(String type) {
    switch (type) {
      case 'V':
        return 'Venezolano';
      case 'E':
        return 'Extranjero';
      case 'J':
        return 'Jurídico';
      case 'P':
        return 'Pasaporte';
      default:
        return type;
    }
  }
}

/// Opciones de género
class GenderOptions {
  static const List<String> genders = [
    'Masculino',
    'Femenino',
    'Otro',
    'Prefiero no decir',
  ];
}

/// Tasa de cambio BCV (mock)
class ExchangeRate {
  static const double bcvRate = 36.45; // Bs. por USD (valor de ejemplo)
}

/// Operadores telefónicos móviles de Venezuela
class PhoneOperators {
  static const List<String> mobileCodes = [
    '0412',
    '0414',
    '0416',
    '0424',
    '0426',
  ];

  static const List<String> landlineCodes = [
    '0212', // Caracas
    '0241', // Valencia
    '0243', // Maracay
    '0261', // Maracaibo
    '0281', // Barcelona
    '0295', // Maturín
    // Agregar más según necesidad
  ];

  static bool isMobileCode(String code) {
    return mobileCodes.contains(code);
  }

  static bool isLandlineCode(String code) {
    return landlineCodes.contains(code);
  }

  static bool isValidPhoneCode(String code) {
    return isMobileCode(code) || isLandlineCode(code);
  }
}
