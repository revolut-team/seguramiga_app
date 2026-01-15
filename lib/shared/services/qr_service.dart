import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import '../models/user_insurance_model.dart';

/// Resultado de validación de datos QR
class QRValidationResult {
  final bool isValid;
  final String? errorMessage;

  const QRValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}

/// Servicio para generación y gestión de códigos QR
///
/// SEGURIDAD: Este servicio implementa varias medidas de seguridad:
/// 1. Los datos se comprimen usando claves abreviadas para reducir tamaño
/// 2. Se recomienda NO incluir datos extremadamente sensibles (contraseñas, tokens)
/// 3. Para producción, considerar encriptación del payload antes de codificar
class QRService {
  QRService._();

  /// Genera el string de datos para el código QR desde el modelo de usuario
  ///
  /// El formato es JSON compacto con claves abreviadas para optimizar
  /// el tamaño del código QR y mejorar la legibilidad al escanear
  static String generateQRData(UserInsuranceModel user) {
    return user.toJson();
  }

  /// Genera datos QR con una firma de verificación simple
  ///
  /// NOTA: Para producción, usar firma criptográfica real (HMAC, JWT, etc.)
  static String generateSignedQRData(UserInsuranceModel user, {String? secretKey}) {
    final data = user.toMap();

    // Agregar timestamp para validación temporal
    data['ts'] = DateTime.now().millisecondsSinceEpoch;

    // Agregar versión del esquema para compatibilidad futura
    data['v'] = '1.0';

    // En producción, aquí se agregaría una firma HMAC o similar
    // data['sig'] = _generateHMAC(jsonEncode(data), secretKey);

    return jsonEncode(data);
  }

  /// Valida si los datos del QR son válidos
  /// Retorna un resultado con estado y mensaje de error si aplica
  static QRValidationResult validateQRDataWithMessage(String qrData) {
    try {
      // Intentar parsear como JSON
      final dynamic decoded = jsonDecode(qrData);

      if (decoded is! Map<String, dynamic>) {
        return QRValidationResult(
          isValid: false,
          errorMessage: 'El código QR no contiene datos de seguro válidos',
        );
      }

      final data = decoded;

      // Verificar campos requeridos mínimos (usando claves abreviadas)
      final requiredFields = ['n', 'mid', 'pn'];
      final missingFields = <String>[];

      for (final field in requiredFields) {
        if (!data.containsKey(field) || data[field] == null || data[field].toString().isEmpty) {
          missingFields.add(field);
        }
      }

      if (missingFields.isNotEmpty) {
        return QRValidationResult(
          isValid: false,
          errorMessage: 'Este código QR no pertenece a un carnet de Seguramiga',
        );
      }

      return QRValidationResult(isValid: true);
    } on FormatException {
      return QRValidationResult(
        isValid: false,
        errorMessage: 'Este código QR no contiene información de seguro. '
            'Asegúrate de escanear un carnet digital de Seguramiga.',
      );
    } catch (e) {
      return QRValidationResult(
        isValid: false,
        errorMessage: 'Error al leer el código QR',
      );
    }
  }

  /// Valida si los datos del QR son válidos (versión simple, retorna bool)
  static bool validateQRData(String qrData, {Duration maxAge = const Duration(days: 365)}) {
    return validateQRDataWithMessage(qrData).isValid;
  }

  /// Decodifica datos del QR a un modelo de usuario
  static UserInsuranceModel? decodeQRData(String qrData) {
    try {
      return UserInsuranceModel.fromJson(qrData);
    } catch (e) {
      debugPrint('Error decoding QR data: $e');
      return null;
    }
  }

  /// Captura el widget QR como imagen (para compartir/guardar)
  static Future<Uint8List?> captureQRAsImage(GlobalKey qrKey) async {
    try {
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing QR image: $e');
      return null;
    }
  }

  /// Calcula el nivel óptimo de corrección de errores basado en el tamaño de datos
  ///
  /// - L: ~7% de corrección, mejor para datos pequeños
  /// - M: ~15% de corrección, balance general
  /// - Q: ~25% de corrección, bueno para impresión
  /// - H: ~30% de corrección, máxima resistencia
  static int getOptimalErrorCorrectionLevel(int dataLength) {
    if (dataLength < 100) return 3; // High
    if (dataLength < 300) return 2; // Quartile
    if (dataLength < 500) return 1; // Medium
    return 0; // Low - para datos grandes
  }
}

/// Extensión para formateo de datos del QR
extension QRDataFormatter on UserInsuranceModel {
  /// Genera un resumen legible de los datos para mostrar junto al QR
  String get formattedSummary {
    return '''
Titular: $fullName
ID: $memberId
Plan: $planName
Vigencia: ${_formatDate(expirationDate)}
''';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
