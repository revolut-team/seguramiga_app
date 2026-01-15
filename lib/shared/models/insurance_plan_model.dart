import 'package:flutter/material.dart';

/// Niveles de plan de seguro
enum PlanTier {
  basic,
  standard,
  premium,
}

extension PlanTierExtension on PlanTier {
  String get displayName {
    switch (this) {
      case PlanTier.basic:
        return 'Básico';
      case PlanTier.standard:
        return 'Estándar';
      case PlanTier.premium:
        return 'Premium';
    }
  }

  Color get color {
    switch (this) {
      case PlanTier.basic:
        return const Color(0xFF4299E1); // Secondary
      case PlanTier.standard:
        return const Color(0xFF1A365D); // Primary
      case PlanTier.premium:
        return const Color(0xFF38B2AC); // Accent
    }
  }
}

/// Cobertura de un plan de seguro
class Coverage {
  final String name;
  final String limit;
  final IconData icon;

  const Coverage({
    required this.name,
    required this.limit,
    required this.icon,
  });
}

/// Modelo de plan de seguro
class InsurancePlan {
  final String id;
  final String name;
  final PlanTier tier;
  final double monthlyPrice;
  final double annualPrice;
  final List<Coverage> coverages;
  final List<String> features;
  final List<String> limitations;
  final bool isRecommended;

  const InsurancePlan({
    required this.id,
    required this.name,
    required this.tier,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.coverages,
    required this.features,
    required this.limitations,
    this.isRecommended = false,
  });

  /// Precio anual con descuento (15%)
  double get annualDiscountedPrice => monthlyPrice * 12 * 0.85;

  /// Ahorro anual
  double get annualSavings => (monthlyPrice * 12) - annualDiscountedPrice;

  /// Planes mock para demostración
  static List<InsurancePlan> get mockPlans => [
        InsurancePlan(
          id: 'basic',
          name: 'Plan Básico',
          tier: PlanTier.basic,
          monthlyPrice: 250.0, // Bs.
          annualPrice: 2550.0, // Bs. (15% descuento)
          coverages: const [
            Coverage(
              name: 'Consultas médicas',
              limit: 'Ilimitadas',
              icon: Icons.medical_services,
            ),
            Coverage(
              name: 'Telemedicina',
              limit: '24/7',
              icon: Icons.video_call,
            ),
            Coverage(
              name: 'Farmacia',
              limit: '20% descuento',
              icon: Icons.local_pharmacy,
            ),
            Coverage(
              name: 'Exámenes básicos',
              limit: 'Incluidos',
              icon: Icons.biotech,
            ),
          ],
          features: const [
            'Consultas médicas ilimitadas',
            'Telemedicina 24/7',
            'Farmacia con 20% descuento',
            'Exámenes de laboratorio básicos',
            'Red nacional limitada',
            'Urgencias médicas',
          ],
          limitations: const [
            'Red de proveedores limitada',
            'Sin cobertura internacional',
          ],
          isRecommended: false,
        ),
        InsurancePlan(
          id: 'standard',
          name: 'Plan Estándar',
          tier: PlanTier.standard,
          monthlyPrice: 500.0, // Bs.
          annualPrice: 5100.0, // Bs. (15% descuento)
          coverages: const [
            Coverage(
              name: 'Consultas médicas',
              limit: 'Ilimitadas',
              icon: Icons.medical_services,
            ),
            Coverage(
              name: 'Telemedicina',
              limit: '24/7 prioritaria',
              icon: Icons.video_call,
            ),
            Coverage(
              name: 'Farmacia',
              limit: '40% descuento',
              icon: Icons.local_pharmacy,
            ),
            Coverage(
              name: 'Exámenes especializados',
              limit: 'Incluidos',
              icon: Icons.biotech,
            ),
            Coverage(
              name: 'Red nacional',
              limit: 'Completa',
              icon: Icons.apartment,
            ),
            Coverage(
              name: 'Reembolsos',
              limit: 'Hasta Bs. 3,000',
              icon: Icons.attach_money,
            ),
          ],
          features: const [
            'Todo lo del plan básico',
            'Red nacional completa',
            'Descuento farmacia 40%',
            'Exámenes especializados incluidos',
            'Atención prioritaria',
            'Reembolsos hasta Bs. 3,000',
            'Especialistas sin referencia',
            'Urgencias sin copago',
            'Atención domiciliaria',
            'Segunda opinión médica',
          ],
          limitations: const [
            'Sin cobertura internacional',
          ],
          isRecommended: true,
        ),
        InsurancePlan(
          id: 'premium',
          name: 'Plan Premium',
          tier: PlanTier.premium,
          monthlyPrice: 850.0, // Bs.
          annualPrice: 8670.0, // Bs. (15% descuento)
          coverages: const [
            Coverage(
              name: 'Consultas médicas',
              limit: 'Ilimitadas VIP',
              icon: Icons.medical_services,
            ),
            Coverage(
              name: 'Telemedicina',
              limit: '24/7 VIP',
              icon: Icons.video_call,
            ),
            Coverage(
              name: 'Farmacia',
              limit: '60% descuento',
              icon: Icons.local_pharmacy,
            ),
            Coverage(
              name: 'Todos los exámenes',
              limit: 'Incluidos',
              icon: Icons.biotech,
            ),
            Coverage(
              name: 'Red internacional',
              limit: 'Completa',
              icon: Icons.apartment,
            ),
            Coverage(
              name: 'Reembolsos',
              limit: 'Hasta Bs. 10,000',
              icon: Icons.attach_money,
            ),
          ],
          features: const [
            'Todo lo del plan estándar',
            'Red internacional completa',
            'Descuento farmacia 60%',
            'Todos los exámenes incluidos',
            'Sin copagos en ningún servicio',
            'Reembolsos hasta Bs. 10,000',
            'Servicio VIP con concierge médico',
            'Ambulancia aérea',
            'Check-up anual ejecutivo',
            'Cobertura dental y oftalmológica',
            'Terapias alternativas',
            'Nutricionista y entrenador',
            'Habitación individual en hospitalizaciones',
          ],
          limitations: const [],
          isRecommended: false,
        ),
      ];

  /// Obtener plan por ID
  static InsurancePlan? getPlanById(String id) {
    try {
      return mockPlans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }
}
