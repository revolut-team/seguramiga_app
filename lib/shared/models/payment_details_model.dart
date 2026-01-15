/// Frecuencia de pago
enum PaymentFrequency {
  monthly,
  annual,
}

extension PaymentFrequencyExtension on PaymentFrequency {
  String get displayName {
    switch (this) {
      case PaymentFrequency.monthly:
        return 'Mensual';
      case PaymentFrequency.annual:
        return 'Anual';
    }
  }
}

/// Estado del pago
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.processing:
        return 'Procesando';
      case PaymentStatus.completed:
        return 'Completado';
      case PaymentStatus.failed:
        return 'Fallido';
    }
  }
}

/// Modelo de detalles de pago
class PaymentDetails {
  final String orderId;
  final String planId;
  final String planName;
  final double amount;
  final PaymentFrequency frequency;
  final DateTime paymentDate;
  final String referenceNumber;
  final PaymentStatus status;
  final String paymentMethod;

  const PaymentDetails({
    required this.orderId,
    required this.planId,
    required this.planName,
    required this.amount,
    required this.frequency,
    required this.paymentDate,
    required this.referenceNumber,
    required this.status,
    this.paymentMethod = 'Pago móvil',
  });

  /// Próxima fecha de pago
  DateTime get nextPaymentDate {
    switch (frequency) {
      case PaymentFrequency.monthly:
        return DateTime(
          paymentDate.year,
          paymentDate.month + 1,
          paymentDate.day,
        );
      case PaymentFrequency.annual:
        return DateTime(
          paymentDate.year + 1,
          paymentDate.month,
          paymentDate.day,
        );
    }
  }

  /// Generar número de orden único
  static String generateOrderId() {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timeStr = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return 'REF-$dateStr-$timeStr-${random.toString().padLeft(4, '0')}';
  }

  /// Copiar con nuevos valores
  PaymentDetails copyWith({
    String? orderId,
    String? planId,
    String? planName,
    double? amount,
    PaymentFrequency? frequency,
    DateTime? paymentDate,
    String? referenceNumber,
    PaymentStatus? status,
    String? paymentMethod,
  }) {
    return PaymentDetails(
      orderId: orderId ?? this.orderId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      paymentDate: paymentDate ?? this.paymentDate,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  /// Convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'planId': planId,
      'planName': planName,
      'amount': amount,
      'frequency': frequency.name,
      'paymentDate': paymentDate.toIso8601String(),
      'referenceNumber': referenceNumber,
      'status': status.name,
      'paymentMethod': paymentMethod,
    };
  }

  /// Crear desde Map
  factory PaymentDetails.fromMap(Map<String, dynamic> map) {
    return PaymentDetails(
      orderId: map['orderId'],
      planId: map['planId'],
      planName: map['planName'],
      amount: map['amount'],
      frequency: PaymentFrequency.values.firstWhere(
        (e) => e.name == map['frequency'],
      ),
      paymentDate: DateTime.parse(map['paymentDate']),
      referenceNumber: map['referenceNumber'],
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      paymentMethod: map['paymentMethod'] ?? 'Pago móvil',
    );
  }
}
