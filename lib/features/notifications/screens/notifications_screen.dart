import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Notificaciones
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          TextButton(
            onPressed: () => _markAllAsRead(),
            child: const Text('Marcar todas'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingXs,
              ),
              children: [
                _FilterChip(
                  label: 'Todas',
                  count: 12,
                  isSelected: _selectedFilter == 'Todas',
                  onTap: () => setState(() => _selectedFilter = 'Todas'),
                ),
                _FilterChip(
                  label: 'Citas',
                  count: 3,
                  isSelected: _selectedFilter == 'Citas',
                  onTap: () => setState(() => _selectedFilter = 'Citas'),
                ),
                _FilterChip(
                  label: 'Reembolsos',
                  count: 2,
                  isSelected: _selectedFilter == 'Reembolsos',
                  onTap: () => setState(() => _selectedFilter = 'Reembolsos'),
                ),
                _FilterChip(
                  label: 'Alertas',
                  count: 1,
                  isSelected: _selectedFilter == 'Alertas',
                  onTap: () => setState(() => _selectedFilter = 'Alertas'),
                ),
                _FilterChip(
                  label: 'Sistema',
                  count: 6,
                  isSelected: _selectedFilter == 'Sistema',
                  onTap: () => setState(() => _selectedFilter = 'Sistema'),
                ),
              ],
            ),
          ),

          // Lista de notificaciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              children: [
                // Hoy
                Text(
                  'Hoy',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                _NotificationCard(
                  type: NotificationType.appointment,
                  title: 'Recordatorio de cita',
                  message: 'Tu cita con Dra. María González es mañana a las 10:00 AM',
                  time: 'Hace 2 horas',
                  isUnread: true,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.reimbursement,
                  title: 'Reembolso aprobado',
                  message: 'Tu solicitud RMB-2024-0010 ha sido aprobada por \$280.00',
                  time: 'Hace 4 horas',
                  isUnread: true,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.alert,
                  title: 'Documentación pendiente',
                  message: 'Tu autorización AUT-2024-0033 requiere información adicional',
                  time: 'Hace 5 horas',
                  isUnread: true,
                  isUrgent: true,
                  onTap: () {},
                ),

                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  'Ayer',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                _NotificationCard(
                  type: NotificationType.pharmacy,
                  title: 'Pedido en camino',
                  message: 'Tu pedido #ORD-2024-001 está siendo entregado',
                  time: 'Ayer, 3:45 PM',
                  isUnread: false,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.telemedicine,
                  title: 'Nuevo mensaje',
                  message: 'Dra. María González te ha enviado un mensaje',
                  time: 'Ayer, 2:30 PM',
                  isUnread: false,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.system,
                  title: 'Actualización de cobertura',
                  message: 'Tu plan ahora incluye cobertura dental extendida',
                  time: 'Ayer, 10:00 AM',
                  isUnread: false,
                  onTap: () {},
                ),

                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  'Esta semana',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                _NotificationCard(
                  type: NotificationType.appointment,
                  title: 'Cita completada',
                  message: 'Tu consulta con Dr. Carlos Rodríguez ha finalizado',
                  time: 'Lun, 5:00 PM',
                  isUnread: false,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.benefit,
                  title: 'Nuevo beneficio disponible',
                  message: '¡Tienes 20% de descuento en gimnasios afiliados!',
                  time: 'Lun, 9:00 AM',
                  isUnread: false,
                  onTap: () {},
                ),
                _NotificationCard(
                  type: NotificationType.exam,
                  title: 'Resultados disponibles',
                  message: 'Tus resultados de laboratorio ya están listos para ver',
                  time: 'Dom, 8:30 AM',
                  isUnread: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

enum NotificationType {
  appointment,
  reimbursement,
  alert,
  pharmacy,
  telemedicine,
  system,
  benefit,
  exam,
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
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
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.white.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? AppColors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isUnread;
  final bool isUrgent;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    this.isUrgent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: isUrgent
              ? Border.all(color: AppColors.warning.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 22),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        time,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (isUrgent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Urgente',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case NotificationType.appointment:
        return AppColors.secondary;
      case NotificationType.reimbursement:
        return AppColors.success;
      case NotificationType.alert:
        return AppColors.warning;
      case NotificationType.pharmacy:
        return AppColors.accentGreen;
      case NotificationType.telemedicine:
        return AppColors.accent;
      case NotificationType.system:
        return AppColors.primary;
      case NotificationType.benefit:
        return AppColors.accentOrange;
      case NotificationType.exam:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.reimbursement:
        return Icons.receipt_long;
      case NotificationType.alert:
        return Icons.warning;
      case NotificationType.pharmacy:
        return Icons.local_pharmacy;
      case NotificationType.telemedicine:
        return Icons.chat;
      case NotificationType.system:
        return Icons.notifications;
      case NotificationType.benefit:
        return Icons.card_giftcard;
      case NotificationType.exam:
        return Icons.science;
    }
  }
}
