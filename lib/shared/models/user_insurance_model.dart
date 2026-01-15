import 'dart:convert';

/// Modelo de datos del usuario y su información de seguro
/// Contiene toda la información necesaria para generar el código QR
class UserInsuranceModel {
  final String fullName;
  final String documentId;
  final String documentType;
  final String phone;
  final String email;
  final String policyNumber;
  final String planType;
  final String planName;
  final DateTime expirationDate;
  final String memberId;
  final String? bloodType;
  final List<String>? allergies;
  final String? emergencyContact;
  final String? emergencyPhone;

  const UserInsuranceModel({
    required this.fullName,
    required this.documentId,
    required this.documentType,
    required this.phone,
    required this.email,
    required this.policyNumber,
    required this.planType,
    required this.planName,
    required this.expirationDate,
    required this.memberId,
    this.bloodType,
    this.allergies,
    this.emergencyContact,
    this.emergencyPhone,
  });

  /// Convierte el modelo a un Map para serialización
  Map<String, dynamic> toMap() {
    return {
      'n': fullName,
      'di': documentId,
      'dt': documentType,
      'p': phone,
      'e': email,
      'pn': policyNumber,
      'pt': planType,
      'pl': planName,
      'exp': expirationDate.toIso8601String(),
      'mid': memberId,
      if (bloodType != null) 'bt': bloodType,
      if (allergies != null && allergies!.isNotEmpty) 'al': allergies,
      if (emergencyContact != null) 'ec': emergencyContact,
      if (emergencyPhone != null) 'ep': emergencyPhone,
    };
  }

  /// Convierte el modelo a JSON compacto para el QR
  String toJson() => jsonEncode(toMap());

  /// Crea una instancia desde un Map
  factory UserInsuranceModel.fromMap(Map<String, dynamic> map) {
    return UserInsuranceModel(
      fullName: map['n'] ?? map['fullName'] ?? '',
      documentId: map['di'] ?? map['documentId'] ?? '',
      documentType: map['dt'] ?? map['documentType'] ?? '',
      phone: map['p'] ?? map['phone'] ?? '',
      email: map['e'] ?? map['email'] ?? '',
      policyNumber: map['pn'] ?? map['policyNumber'] ?? '',
      planType: map['pt'] ?? map['planType'] ?? '',
      planName: map['pl'] ?? map['planName'] ?? '',
      expirationDate: DateTime.parse(
        map['exp'] ?? map['expirationDate'] ?? DateTime.now().toIso8601String(),
      ),
      memberId: map['mid'] ?? map['memberId'] ?? '',
      bloodType: map['bt'] ?? map['bloodType'],
      allergies: (map['al'] ?? map['allergies'])?.cast<String>(),
      emergencyContact: map['ec'] ?? map['emergencyContact'],
      emergencyPhone: map['ep'] ?? map['emergencyPhone'],
    );
  }

  /// Crea una instancia desde JSON
  factory UserInsuranceModel.fromJson(String source) =>
      UserInsuranceModel.fromMap(jsonDecode(source));

  /// Verifica si el seguro está vigente
  bool get isActive => expirationDate.isAfter(DateTime.now());

  /// Días restantes hasta el vencimiento
  int get daysUntilExpiration =>
      expirationDate.difference(DateTime.now()).inDays;

  /// Datos de ejemplo para desarrollo (Venezuela)
  static UserInsuranceModel get mockUser => UserInsuranceModel(
        fullName: 'Carlos García Mendoza',
        documentId: 'V-12345678',
        documentType: 'Cédula',
        phone: '0414-123-4567',
        email: 'carlos.garcia@email.com',
        policyNumber: 'POL-2024-00012345',
        planType: 'PREMIUM',
        planName: 'Plan Premium Plus',
        expirationDate: DateTime(2025, 12, 31),
        memberId: 'SEG-2024-001234',
        bloodType: 'O+',
        allergies: ['Penicilina', 'Mariscos'],
        emergencyContact: 'María García',
        emergencyPhone: '0424-987-6543',
      );

  @override
  String toString() {
    return 'UserInsuranceModel(fullName: $fullName, memberId: $memberId, planName: $planName)';
  }
}
