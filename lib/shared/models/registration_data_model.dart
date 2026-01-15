/// Modelo de datos para el proceso de registro
class RegistrationData {
  // Información personal
  String? firstName;
  String? lastName;
  String? documentType; // V, E, J, P
  String? documentId;
  DateTime? birthDate;
  String? gender;

  // Información de contacto
  String? phone;
  String? email;

  // Dirección
  String? state;
  String? city;
  String? address;
  String? zipCode;

  // PIN de seguridad
  String? pin;

  // Plan seleccionado
  String? selectedPlanId;

  RegistrationData({
    this.firstName,
    this.lastName,
    this.documentType,
    this.documentId,
    this.birthDate,
    this.gender,
    this.phone,
    this.email,
    this.state,
    this.city,
    this.address,
    this.zipCode,
    this.pin,
    this.selectedPlanId,
  });

  /// Nombre completo
  String get fullName {
    if (firstName == null && lastName == null) return '';
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  /// Documento completo con tipo
  String get fullDocument {
    if (documentType == null || documentId == null) return '';
    return '$documentType-$documentId';
  }

  /// Validar si los datos personales están completos
  bool get isPersonalInfoComplete {
    return firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty &&
        documentType != null &&
        documentId != null &&
        documentId!.isNotEmpty &&
        birthDate != null &&
        gender != null;
  }

  /// Validar si los datos de contacto están completos
  bool get isContactInfoComplete {
    return phone != null && phone!.isNotEmpty && email != null && email!.isNotEmpty;
  }

  /// Validar si la dirección está completa
  bool get isAddressComplete {
    return state != null &&
        state!.isNotEmpty &&
        city != null &&
        city!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty;
  }

  /// Validar si el PIN está configurado
  bool get isPinComplete {
    return pin != null && pin!.length == 4;
  }

  /// Validar si todos los datos están completos
  bool get isComplete {
    return isPersonalInfoComplete &&
        isContactInfoComplete &&
        isAddressComplete &&
        isPinComplete;
  }

  /// Copiar con nuevos valores
  RegistrationData copyWith({
    String? firstName,
    String? lastName,
    String? documentType,
    String? documentId,
    DateTime? birthDate,
    String? gender,
    String? phone,
    String? email,
    String? state,
    String? city,
    String? address,
    String? zipCode,
    String? pin,
    String? selectedPlanId,
  }) {
    return RegistrationData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      documentType: documentType ?? this.documentType,
      documentId: documentId ?? this.documentId,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      pin: pin ?? this.pin,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
    );
  }

  /// Convertir a Map para serialización
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'documentType': documentType,
      'documentId': documentId,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'email': email,
      'state': state,
      'city': city,
      'address': address,
      'zipCode': zipCode,
      'selectedPlanId': selectedPlanId,
      // PIN no se serializa por seguridad
    };
  }

  /// Crear desde Map
  factory RegistrationData.fromMap(Map<String, dynamic> map) {
    return RegistrationData(
      firstName: map['firstName'],
      lastName: map['lastName'],
      documentType: map['documentType'],
      documentId: map['documentId'],
      birthDate: map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
      gender: map['gender'],
      phone: map['phone'],
      email: map['email'],
      state: map['state'],
      city: map['city'],
      address: map['address'],
      zipCode: map['zipCode'],
      selectedPlanId: map['selectedPlanId'],
    );
  }
}
