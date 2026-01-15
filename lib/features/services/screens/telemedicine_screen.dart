import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Telemedicina
/// Incluye videollamada, chat médico e historial de consultas
class TelemedicineScreen extends StatefulWidget {
  const TelemedicineScreen({super.key});

  @override
  State<TelemedicineScreen> createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends State<TelemedicineScreen>
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
      appBar: AppBar(
        title: const Text('Telemedicina'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Consulta'),
            Tab(text: 'Chat'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConsultaTab(),
          _buildChatTab(),
          _buildHistorialTab(),
        ],
      ),
    );
  }

  Widget _buildConsultaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de consulta rápida
          CustomCard(
            gradient: AppColors.secondaryGradient,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.video_call,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consulta ahora',
                        style: AppTextStyles.h5.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Médicos disponibles 24/7',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Especialidades disponibles
          const SectionHeader(title: 'Especialidades'),
          const SizedBox(height: AppConstants.spacingMd),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              _SpecialtyCard(
                icon: Icons.medical_services,
                label: 'Medicina General',
                color: AppColors.secondary,
                onTap: () {},
              ),
              _SpecialtyCard(
                icon: Icons.psychology,
                label: 'Psicología',
                color: AppColors.accent,
                onTap: () {},
              ),
              _SpecialtyCard(
                icon: Icons.favorite,
                label: 'Cardiología',
                color: AppColors.emergency,
                onTap: () {},
              ),
              _SpecialtyCard(
                icon: Icons.child_care,
                label: 'Pediatría',
                color: AppColors.accentOrange,
                onTap: () {},
              ),
              _SpecialtyCard(
                icon: Icons.visibility,
                label: 'Oftalmología',
                color: AppColors.primaryLight,
                onTap: () {},
              ),
              _SpecialtyCard(
                icon: Icons.spa,
                label: 'Dermatología',
                color: AppColors.accentGreen,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Médicos destacados
          const SectionHeader(
            title: 'Médicos disponibles',
            actionText: 'Ver todos',
          ),
          const SizedBox(height: AppConstants.spacingMd),

          _DoctorCard(
            name: 'Dra. María González',
            specialty: 'Medicina General',
            rating: 4.9,
            reviews: 128,
            imageUrl: null,
            isAvailable: true,
            onTap: () {},
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _DoctorCard(
            name: 'Dr. Carlos Rodríguez',
            specialty: 'Cardiología',
            rating: 4.8,
            reviews: 95,
            imageUrl: null,
            isAvailable: true,
            onTap: () {},
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _DoctorCard(
            name: 'Dra. Ana Martínez',
            specialty: 'Psicología',
            rating: 5.0,
            reviews: 203,
            imageUrl: null,
            isAvailable: false,
            nextAvailable: 'Disponible en 30 min',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Chat activo
        _ChatCard(
          doctorName: 'Dra. María González',
          specialty: 'Medicina General',
          lastMessage: 'Recuerde tomar el medicamento cada 8 horas',
          time: 'Hace 2h',
          unreadCount: 2,
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ChatCard(
          doctorName: 'Dr. Carlos Rodríguez',
          specialty: 'Cardiología',
          lastMessage: 'Sus resultados se ven muy bien',
          time: 'Ayer',
          unreadCount: 0,
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Iniciar nuevo chat
        CustomCard(
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
                child: const Icon(
                  Icons.add_comment,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Iniciar nueva consulta', style: AppTextStyles.bodyLarge),
                    Text(
                      'Chatea con un médico ahora',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorialTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _ConsultationHistoryCard(
          doctorName: 'Dra. María González',
          specialty: 'Medicina General',
          date: '10 Ene 2025',
          type: 'Videollamada',
          diagnosis: 'Resfriado común',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ConsultationHistoryCard(
          doctorName: 'Dr. Carlos Rodríguez',
          specialty: 'Cardiología',
          date: '5 Ene 2025',
          type: 'Chat',
          diagnosis: 'Control de rutina',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _ConsultationHistoryCard(
          doctorName: 'Dra. Ana Martínez',
          specialty: 'Psicología',
          date: '28 Dic 2024',
          type: 'Videollamada',
          diagnosis: 'Sesión de seguimiento',
          onTap: () {},
        ),
      ],
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SpecialtyCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String? imageUrl;
  final bool isAvailable;
  final String? nextAvailable;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    this.imageUrl,
    required this.isAvailable,
    this.nextAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.grey200,
            child: Icon(Icons.person, color: AppColors.grey400, size: 32),
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
                    const Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(
                text: isAvailable ? 'Disponible' : 'Ocupado',
                type: isAvailable ? StatusType.success : StatusType.warning,
              ),
              if (nextAvailable != null) ...[
                const SizedBox(height: 4),
                Text(
                  nextAvailable!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ChatCard({
    required this.doctorName,
    required this.specialty,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.grey200,
            child: Icon(Icons.person, color: AppColors.grey400),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(doctorName, style: AppTextStyles.bodyMedium),
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                Text(
                  specialty,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lastMessage,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationHistoryCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String type;
  final String diagnosis;
  final VoidCallback onTap;

  const _ConsultationHistoryCard({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.type,
    required this.diagnosis,
    required this.onTap,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(doctorName, style: AppTextStyles.bodyLarge),
              StatusBadge(
                text: type,
                type: type == 'Videollamada' ? StatusType.info : StatusType.neutral,
              ),
            ],
          ),
          Text(
            specialty,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const Divider(height: 24),
          Row(
            children: [
              _InfoItem(icon: Icons.calendar_today, label: date),
              const SizedBox(width: AppConstants.spacingLg),
              _InfoItem(icon: Icons.medical_information, label: diagnosis),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.grey400),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
