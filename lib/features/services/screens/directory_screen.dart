import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Directorio Médico
/// Incluye especialistas, centros de salud y geolocalización
class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'Todas';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Directorio Médico'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Médicos'),
            Tab(text: 'Centros'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar médico o especialidad...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () => _showFilters(context),
                ),
              ),
            ),
          ),

          // Filtros de especialidad
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              children: [
                _FilterChip(
                  label: 'Todas',
                  isSelected: _selectedSpecialty == 'Todas',
                  onTap: () => setState(() => _selectedSpecialty = 'Todas'),
                ),
                _FilterChip(
                  label: 'General',
                  isSelected: _selectedSpecialty == 'General',
                  onTap: () => setState(() => _selectedSpecialty = 'General'),
                ),
                _FilterChip(
                  label: 'Cardiología',
                  isSelected: _selectedSpecialty == 'Cardiología',
                  onTap: () => setState(() => _selectedSpecialty = 'Cardiología'),
                ),
                _FilterChip(
                  label: 'Pediatría',
                  isSelected: _selectedSpecialty == 'Pediatría',
                  onTap: () => setState(() => _selectedSpecialty = 'Pediatría'),
                ),
                _FilterChip(
                  label: 'Ginecología',
                  isSelected: _selectedSpecialty == 'Ginecología',
                  onTap: () => setState(() => _selectedSpecialty = 'Ginecología'),
                ),
                _FilterChip(
                  label: 'Dermatología',
                  isSelected: _selectedSpecialty == 'Dermatología',
                  onTap: () => setState(() => _selectedSpecialty = 'Dermatología'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),

          // Contenido de tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoctorsTab(),
                _buildCentersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _DoctorDirectoryCard(
          name: 'Dra. María González',
          specialty: 'Medicina General',
          location: 'Centro Médico Principal',
          distance: '1.2 km',
          rating: 4.9,
          reviews: 128,
          isAvailable: true,
          onTap: () => _showDoctorDetails(context),
          onCall: () {},
          onSchedule: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _DoctorDirectoryCard(
          name: 'Dr. Carlos Rodríguez',
          specialty: 'Cardiología',
          location: 'Hospital San José',
          distance: '2.5 km',
          rating: 4.8,
          reviews: 95,
          isAvailable: true,
          onTap: () => _showDoctorDetails(context),
          onCall: () {},
          onSchedule: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _DoctorDirectoryCard(
          name: 'Dra. Ana Martínez',
          specialty: 'Dermatología',
          location: 'Clínica Dermatológica',
          distance: '3.1 km',
          rating: 5.0,
          reviews: 203,
          isAvailable: false,
          onTap: () => _showDoctorDetails(context),
          onCall: () {},
          onSchedule: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _DoctorDirectoryCard(
          name: 'Dr. Luis Hernández',
          specialty: 'Pediatría',
          location: 'Centro Pediátrico',
          distance: '4.0 km',
          rating: 4.7,
          reviews: 156,
          isAvailable: true,
          onTap: () => _showDoctorDetails(context),
          onCall: () {},
          onSchedule: () {},
        ),
      ],
    );
  }

  Widget _buildCentersTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Mapa placeholder
        Container(
          height: 200,
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
                    Icon(Icons.map, size: 48, color: AppColors.grey400),
                    const SizedBox(height: 8),
                    Text(
                      'Mapa de ubicaciones',
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
                  backgroundColor: AppColors.white,
                  child: const Icon(Icons.my_location, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Centros cercanos'),
        const SizedBox(height: AppConstants.spacingMd),

        _MedicalCenterCard(
          name: 'Centro Médico Principal',
          type: 'Hospital',
          address: 'Av. Principal #123',
          distance: '1.2 km',
          isOpen: true,
          services: ['Emergencias', 'Consultas', 'Laboratorio'],
          onTap: () {},
          onNavigate: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _MedicalCenterCard(
          name: 'Hospital San José',
          type: 'Hospital',
          address: 'Calle Salud #456',
          distance: '2.5 km',
          isOpen: true,
          services: ['Emergencias', 'Cirugías', 'UCI'],
          onTap: () {},
          onNavigate: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _MedicalCenterCard(
          name: 'Laboratorio Clínico Plus',
          type: 'Laboratorio',
          address: 'Av. Central #789',
          distance: '1.8 km',
          isOpen: false,
          closingInfo: 'Abre a las 7:00 AM',
          services: ['Análisis clínicos', 'Rayos X'],
          onTap: () {},
          onNavigate: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _MedicalCenterCard(
          name: 'Farmacia 24 Horas',
          type: 'Farmacia',
          address: 'Calle Comercio #321',
          distance: '0.8 km',
          isOpen: true,
          services: ['Medicamentos', 'Inyecciones'],
          onTap: () {},
          onNavigate: () {},
        ),
      ],
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text('Filtros', style: AppTextStyles.h5),
            const SizedBox(height: AppConstants.spacingLg),
            Text('Distancia máxima', style: AppTextStyles.labelLarge),
            Slider(
              value: 5,
              min: 1,
              max: 20,
              divisions: 19,
              label: '5 km',
              onChanged: (value) {},
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text('Solo disponibles ahora', style: AppTextStyles.labelLarge),
            Switch(value: false, onChanged: (value) {}),
            const SizedBox(height: AppConstants.spacingMd),
            CustomButton(
              text: 'Aplicar filtros',
              onPressed: () => Navigator.pop(context),
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.grey200,
                  child: const Icon(Icons.person, size: 50, color: AppColors.grey400),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Center(
                child: Text('Dra. María González', style: AppTextStyles.h4),
              ),
              Center(
                child: Text(
                  'Medicina General',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppColors.warning, size: 20),
                  const SizedBox(width: 4),
                  Text('4.9', style: AppTextStyles.bodyLarge),
                  Text(
                    ' (128 reseñas)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Llamar',
                      icon: Icons.phone,
                      type: ButtonType.outline,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Agendar',
                      icon: Icons.calendar_today,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),
              const Divider(),
              const SizedBox(height: AppConstants.spacingMd),
              Text('Información', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingMd),
              _InfoRow(icon: Icons.location_on, label: 'Centro Médico Principal'),
              _InfoRow(icon: Icons.access_time, label: 'Lun - Vie: 8:00 AM - 5:00 PM'),
              _InfoRow(icon: Icons.school, label: 'Universidad Nacional de Medicina'),
              _InfoRow(icon: Icons.workspace_premium, label: '15 años de experiencia'),
              const SizedBox(height: AppConstants.spacingLg),
              Text('Servicios', style: AppTextStyles.h6),
              const SizedBox(height: AppConstants.spacingSm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ServiceChip(label: 'Consulta general'),
                  _ServiceChip(label: 'Chequeo preventivo'),
                  _ServiceChip(label: 'Certificados médicos'),
                  _ServiceChip(label: 'Control de enfermedades crónicas'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DoctorDirectoryCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;
  final String distance;
  final double rating;
  final int reviews;
  final bool isAvailable;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onSchedule;

  const _DoctorDirectoryCard({
    required this.name,
    required this.specialty,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.isAvailable,
    required this.onTap,
    required this.onCall,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.grey200,
                child: const Icon(Icons.person, color: AppColors.grey400, size: 32),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyLarge),
                    Text(
                      specialty,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($reviews)',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on, size: 14, color: AppColors.grey400),
                        Text(
                          distance,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: isAvailable ? 'Disponible' : 'Ocupado',
                type: isAvailable ? StatusType.success : StatusType.warning,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.grey400),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Llamar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSchedule,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Agendar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicalCenterCard extends StatelessWidget {
  final String name;
  final String type;
  final String address;
  final String distance;
  final bool isOpen;
  final String? closingInfo;
  final List<String> services;
  final VoidCallback onTap;
  final VoidCallback onNavigate;

  const _MedicalCenterCard({
    required this.name,
    required this.type,
    required this.address,
    required this.distance,
    required this.isOpen,
    this.closingInfo,
    required this.services,
    required this.onTap,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getTypeIcon(), color: _getTypeColor()),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyLarge),
                    Row(
                      children: [
                        StatusBadge(
                          text: type,
                          type: StatusType.neutral,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          distance,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: isOpen ? 'Abierto' : 'Cerrado',
                type: isOpen ? StatusType.success : StatusType.error,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.grey400),
              const SizedBox(width: 4),
              Text(
                address,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (closingInfo != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.grey400),
                const SizedBox(width: 4),
                Text(
                  closingInfo!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: services
                .map((s) => Chip(
                      label: Text(s, style: AppTextStyles.caption),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onNavigate,
              icon: const Icon(Icons.directions, size: 18),
              label: const Text('Cómo llegar'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case 'Hospital':
        return AppColors.emergency;
      case 'Laboratorio':
        return AppColors.secondary;
      case 'Farmacia':
        return AppColors.accentGreen;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'Laboratorio':
        return Icons.science;
      case 'Farmacia':
        return Icons.local_pharmacy;
      default:
        return Icons.medical_services;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey400),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  final String label;

  const _ServiceChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
      ),
    );
  }
}
