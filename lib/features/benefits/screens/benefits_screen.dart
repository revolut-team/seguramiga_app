import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Beneficios del Plan
class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header con info del plan
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'PLAN PREMIUM PLUS',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tus beneficios exclusivos',
                      style: AppTextStyles.h4.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aprovecha todos los beneficios de tu plan de seguro',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: const Text('Beneficios'),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white.withValues(alpha: 0.7),
              indicatorColor: AppColors.white,
              tabs: const [
                Tab(text: 'Descuentos'),
                Tab(text: 'Cobertura'),
                Tab(text: 'Aliados'),
              ],
            ),
          ),

          // Contenido
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDiscountsTab(),
                _buildCoverageTab(),
                _buildPartnersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Destacados
        const SectionHeader(title: 'Destacados'),
        const SizedBox(height: AppConstants.spacingMd),

        _FeaturedBenefitCard(
          title: '20% en Gimnasios',
          description: 'Descuento en más de 50 gimnasios afiliados',
          validUntil: '31 Marzo 2025',
          imageIcon: Icons.fitness_center,
          color: AppColors.accentOrange,
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _FeaturedBenefitCard(
          title: '15% en Ópticas',
          description: 'Lentes y exámenes de la vista',
          validUntil: '28 Febrero 2025',
          imageIcon: Icons.visibility,
          color: AppColors.secondary,
          onTap: () {},
        ),

        const SizedBox(height: AppConstants.spacingLg),
        const SectionHeader(title: 'Todos los descuentos'),
        const SizedBox(height: AppConstants.spacingMd),

        _DiscountCard(
          icon: Icons.spa,
          title: '10% en Spas',
          description: 'Tratamientos de bienestar',
          discount: '10%',
          onTap: () {},
        ),
        _DiscountCard(
          icon: Icons.restaurant,
          title: '15% en Restaurantes saludables',
          description: 'Más de 30 restaurantes',
          discount: '15%',
          onTap: () {},
        ),
        _DiscountCard(
          icon: Icons.local_pharmacy,
          title: '20% en Farmacia',
          description: 'Medicamentos genéricos',
          discount: '20%',
          onTap: () {},
        ),
        _DiscountCard(
          icon: Icons.psychology,
          title: '25% en Terapia psicológica',
          description: 'Sesiones presenciales y online',
          discount: '25%',
          onTap: () {},
        ),
        _DiscountCard(
          icon: Icons.child_care,
          title: '15% en Pediatría preventiva',
          description: 'Chequeos y vacunas',
          discount: '15%',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCoverageTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Resumen de cobertura
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _CoverageStat(
                      label: 'Límite anual',
                      value: '\$100,000',
                      used: '\$12,500',
                      percentage: 0.125,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Disponible',
                      value: '\$87,500',
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniStat(
                      label: 'Deducible',
                      value: '\$500',
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Cobertura incluida'),
        const SizedBox(height: AppConstants.spacingMd),

        _CoverageCard(
          icon: Icons.local_hospital,
          title: 'Hospitalización',
          coverage: '100%',
          limit: 'Sin límite',
          details: 'Habitación privada, UCI, medicamentos intrahospitalarios',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.medical_services,
          title: 'Consultas médicas',
          coverage: '80%',
          limit: '\$5,000/año',
          details: 'Medicina general y especialidades',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.science,
          title: 'Laboratorio y estudios',
          coverage: '80%',
          limit: '\$3,000/año',
          details: 'Análisis clínicos, rayos X, resonancia',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.medication,
          title: 'Medicamentos',
          coverage: '70%',
          limit: '\$2,000/año',
          details: 'Medicamentos con receta médica',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.emergency,
          title: 'Emergencias',
          coverage: '100%',
          limit: 'Sin límite',
          details: 'Atención de emergencia y ambulancia',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.child_care,
          title: 'Maternidad',
          coverage: '80%',
          limit: '\$10,000',
          details: 'Parto normal, cesárea, controles prenatales',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.favorite,
          title: 'Dental',
          coverage: '50%',
          limit: '\$1,000/año',
          details: 'Limpiezas, extracciones, tratamientos básicos',
          isIncluded: true,
        ),
        _CoverageCard(
          icon: Icons.visibility,
          title: 'Visión',
          coverage: '50%',
          limit: '\$500/año',
          details: 'Exámenes de la vista y lentes',
          isIncluded: true,
        ),

        const SizedBox(height: AppConstants.spacingLg),
        const SectionHeader(title: 'Exclusiones'),
        const SizedBox(height: AppConstants.spacingMd),

        _CoverageCard(
          icon: Icons.spa,
          title: 'Tratamientos estéticos',
          coverage: '0%',
          limit: 'No cubierto',
          details: 'Cirugías y procedimientos estéticos',
          isIncluded: false,
        ),
        _CoverageCard(
          icon: Icons.sports,
          title: 'Lesiones deportivas profesionales',
          coverage: '0%',
          limit: 'No cubierto',
          details: 'Lesiones en competencias profesionales',
          isIncluded: false,
        ),
      ],
    );
  }

  Widget _buildPartnersTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Mapa de aliados
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 40, color: AppColors.grey400),
                    const SizedBox(height: 8),
                    Text(
                      'Ver aliados en el mapa',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: FloatingActionButton.small(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.fullscreen, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Categorías de aliados
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _PartnerCategory(
                icon: Icons.local_hospital,
                label: 'Hospitales',
                count: 25,
                color: AppColors.emergency,
                onTap: () {},
              ),
              _PartnerCategory(
                icon: Icons.local_pharmacy,
                label: 'Farmacias',
                count: 120,
                color: AppColors.accentGreen,
                onTap: () {},
              ),
              _PartnerCategory(
                icon: Icons.science,
                label: 'Laboratorios',
                count: 45,
                color: AppColors.secondary,
                onTap: () {},
              ),
              _PartnerCategory(
                icon: Icons.visibility,
                label: 'Ópticas',
                count: 30,
                color: AppColors.accent,
                onTap: () {},
              ),
              _PartnerCategory(
                icon: Icons.fitness_center,
                label: 'Gimnasios',
                count: 50,
                color: AppColors.accentOrange,
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Aliados destacados'),
        const SizedBox(height: AppConstants.spacingMd),

        _PartnerCard(
          name: 'Hospital San José',
          category: 'Hospital',
          address: 'Calle Salud #456',
          distance: '2.5 km',
          discount: '20%',
          rating: 4.8,
          onTap: () {},
        ),
        _PartnerCard(
          name: 'Laboratorio Clínico Plus',
          category: 'Laboratorio',
          address: 'Av. Central #789',
          distance: '1.8 km',
          discount: '15%',
          rating: 4.9,
          onTap: () {},
        ),
        _PartnerCard(
          name: 'Farmacia Salud 24h',
          category: 'Farmacia',
          address: 'Calle Comercio #321',
          distance: '0.8 km',
          discount: '20%',
          rating: 4.7,
          onTap: () {},
        ),
        _PartnerCard(
          name: 'Óptica Visión Clara',
          category: 'Óptica',
          address: 'Centro Comercial #12',
          distance: '1.2 km',
          discount: '15%',
          rating: 4.6,
          onTap: () {},
        ),
        _PartnerCard(
          name: 'Gym Fitness Pro',
          category: 'Gimnasio',
          address: 'Av. Deportiva #100',
          distance: '3.0 km',
          discount: '20%',
          rating: 4.8,
          onTap: () {},
        ),
      ],
    );
  }
}

class _FeaturedBenefitCard extends StatelessWidget {
  final String title;
  final String description;
  final String validUntil;
  final IconData imageIcon;
  final Color color;
  final VoidCallback onTap;

  const _FeaturedBenefitCard({
    required this.title,
    required this.description,
    required this.validUntil,
    required this.imageIcon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(imageIcon, color: AppColors.white, size: 32),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h6.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Válido hasta $validUntil',
                      style: AppTextStyles.caption.copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _DiscountCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String discount;
  final VoidCallback onTap;

  const _DiscountCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.discount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              discount,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageStat extends StatelessWidget {
  final String label;
  final String value;
  final String used;
  final double percentage;

  const _CoverageStat({
    required this.label,
    required this.value,
    required this.used,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.h5.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Utilizado: $used',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.h6.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _CoverageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String coverage;
  final String limit;
  final String details;
  final bool isIncluded;

  const _CoverageCard({
    required this.icon,
    required this.title,
    required this.coverage,
    required this.limit,
    required this.details,
    required this.isIncluded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: !isIncluded
            ? Border.all(color: AppColors.grey200)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isIncluded
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isIncluded ? AppColors.success : AppColors.grey400,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isIncluded ? AppColors.textPrimary : AppColors.textTertiary,
                  ),
                ),
                Text(
                  details,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                coverage,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isIncluded ? AppColors.success : AppColors.grey400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                limit,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartnerCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _PartnerCategory({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            Text(
              '$count',
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String name;
  final String category;
  final String address;
  final String distance;
  final String discount;
  final double rating;
  final VoidCallback onTap;

  const _PartnerCard({
    required this.name,
    required this.category,
    required this.address,
    required this.distance,
    required this.discount,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(),
              color: AppColors.grey500,
              size: 28,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium),
                Row(
                  children: [
                    StatusBadge(text: category, type: StatusType.neutral),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text(
                      '$rating',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: AppColors.grey400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$address • $distance',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              discount,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (category) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'Farmacia':
        return Icons.local_pharmacy;
      case 'Laboratorio':
        return Icons.science;
      case 'Óptica':
        return Icons.visibility;
      case 'Gimnasio':
        return Icons.fitness_center;
      default:
        return Icons.store;
    }
  }
}
