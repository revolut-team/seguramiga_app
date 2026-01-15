import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Gestión de Citas Médicas
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Mis Citas'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey400,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Próximas'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewAppointmentSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nueva cita'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        // Próxima cita destacada
        _NextAppointmentCard(
          doctorName: 'Dra. María González',
          specialty: 'Medicina General',
          date: 'Mañana',
          time: '10:00 AM',
          location: 'Centro Médico Principal',
          onCancel: () {},
          onReschedule: () {},
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const SectionHeader(title: 'Esta semana'),
        const SizedBox(height: AppConstants.spacingMd),

        _AppointmentCard(
          doctorName: 'Dr. Carlos Rodríguez',
          specialty: 'Cardiología',
          date: 'Vie 17 Ene',
          time: '3:30 PM',
          status: 'Confirmada',
          onTap: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _AppointmentCard(
          doctorName: 'Dra. Ana Martínez',
          specialty: 'Dermatología',
          date: 'Sáb 18 Ene',
          time: '9:00 AM',
          status: 'Pendiente',
          onTap: () {},
        ),

        const SizedBox(height: AppConstants.spacingLg),
        const SectionHeader(title: 'Próximo mes'),
        const SizedBox(height: AppConstants.spacingMd),

        _AppointmentCard(
          doctorName: 'Dr. Luis Hernández',
          specialty: 'Oftalmología',
          date: 'Lun 3 Feb',
          time: '11:00 AM',
          status: 'Confirmada',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      children: [
        _HistoryAppointmentCard(
          doctorName: 'Dra. María González',
          specialty: 'Medicina General',
          date: '10 Ene 2025',
          status: 'Completada',
          onViewDetails: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAppointmentCard(
          doctorName: 'Dr. Pedro Ramírez',
          specialty: 'Traumatología',
          date: '5 Ene 2025',
          status: 'Completada',
          onViewDetails: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAppointmentCard(
          doctorName: 'Dra. Carmen López',
          specialty: 'Ginecología',
          date: '28 Dic 2024',
          status: 'Cancelada',
          onViewDetails: () {},
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _HistoryAppointmentCard(
          doctorName: 'Dr. Carlos Rodríguez',
          specialty: 'Cardiología',
          date: '20 Dic 2024',
          status: 'Completada',
          onViewDetails: () {},
        ),
      ],
    );
  }

  void _showNewAppointmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nueva cita', style: AppTextStyles.h5),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  children: [
                    Text('Selecciona especialidad', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingMd),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SpecialtyChip(label: 'Medicina General', isSelected: true),
                        _SpecialtyChip(label: 'Cardiología', isSelected: false),
                        _SpecialtyChip(label: 'Dermatología', isSelected: false),
                        _SpecialtyChip(label: 'Pediatría', isSelected: false),
                        _SpecialtyChip(label: 'Ginecología', isSelected: false),
                        _SpecialtyChip(label: 'Oftalmología', isSelected: false),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Text('Selecciona médico', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DoctorSelectionCard(
                      name: 'Dra. María González',
                      rating: 4.9,
                      nextAvailable: 'Disponible mañana',
                      isSelected: true,
                    ),
                    const SizedBox(height: 8),
                    _DoctorSelectionCard(
                      name: 'Dr. Juan Pérez',
                      rating: 4.7,
                      nextAvailable: 'Disponible en 2 días',
                      isSelected: false,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Text('Selecciona fecha y hora', style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppConstants.spacingMd),
                    // Calendario simplificado
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () {},
                              ),
                              Text('Enero 2025', style: AppTextStyles.bodyLarge),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                                .map((d) => Text(d, style: AppTextStyles.labelSmall))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          // Días ejemplo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _DayChip(day: '15', isSelected: false, isAvailable: true),
                              _DayChip(day: '16', isSelected: true, isAvailable: true),
                              _DayChip(day: '17', isSelected: false, isAvailable: true),
                              _DayChip(day: '18', isSelected: false, isAvailable: false),
                              _DayChip(day: '19', isSelected: false, isAvailable: true),
                              _DayChip(day: '20', isSelected: false, isAvailable: true),
                              _DayChip(day: '21', isSelected: false, isAvailable: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text('Horarios disponibles', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TimeChip(time: '9:00 AM', isSelected: false),
                        _TimeChip(time: '10:00 AM', isSelected: true),
                        _TimeChip(time: '11:00 AM', isSelected: false),
                        _TimeChip(time: '2:00 PM', isSelected: false),
                        _TimeChip(time: '3:00 PM', isSelected: false),
                        _TimeChip(time: '4:00 PM', isSelected: false),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingXl),
                    CustomButton(
                      text: 'Confirmar cita',
                      onPressed: () => Navigator.pop(context),
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextAppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String location;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const _NextAppointmentCard({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.location,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      gradient: AppColors.primaryGradient,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Próxima cita',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: AppColors.white, size: 32),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: AppTextStyles.h6.copyWith(color: AppColors.white),
                    ),
                    Text(
                      specialty,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _InfoChip(icon: Icons.calendar_today, label: date),
                const SizedBox(width: AppConstants.spacingMd),
                _InfoChip(icon: Icons.access_time, label: time),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReschedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Reagendar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.white),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String status;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: AppColors.primary),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctorName, style: AppTextStyles.bodyLarge),
                Text(
                  specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$date · $time',
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
            text: status,
            type: status == 'Confirmada' ? StatusType.success : StatusType.warning,
          ),
        ],
      ),
    );
  }
}

class _HistoryAppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String status;
  final VoidCallback onViewDetails;

  const _HistoryAppointmentCard({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.status,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onViewDetails,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              status == 'Completada' ? Icons.check_circle : Icons.cancel,
              color: status == 'Completada' ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctorName, style: AppTextStyles.bodyMedium),
                Text(
                  specialty,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            text: status,
            type: status == 'Completada' ? StatusType.success : StatusType.error,
          ),
        ],
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _SpecialtyChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    );
  }
}

class _DoctorSelectionCard extends StatelessWidget {
  final String name;
  final double rating;
  final String nextAvailable;
  final bool isSelected;

  const _DoctorSelectionCard({
    required this.name,
    required this.rating,
    required this.nextAvailable,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.grey200,
            child: const Icon(Icons.person, color: AppColors.grey400),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('$rating', style: AppTextStyles.caption),
                    const SizedBox(width: 8),
                    Text(
                      nextAvailable,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isAvailable;

  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : isAvailable
                ? Colors.transparent
                : AppColors.grey200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          day,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? AppColors.white
                : isAvailable
                    ? AppColors.textPrimary
                    : AppColors.grey400,
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final bool isSelected;

  const _TimeChip({required this.time, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: AppTextStyles.bodySmall.copyWith(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
