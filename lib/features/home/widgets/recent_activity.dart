import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/status_badge.dart';

/// Lista de actividad reciente del usuario
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityItem(
        title: 'Consulta de Telemedicina',
        subtitle: 'Dr. María López - Medicina General',
        date: 'Hace 2 días',
        icon: Icons.video_call_outlined,
        iconColor: AppColors.secondary,
        statusText: 'Completada',
        statusType: StatusType.success,
      ),
      _ActivityItem(
        title: 'Reembolso de medicamentos',
        subtitle: 'Solicitud #REE-2024-0045',
        date: 'Hace 5 días',
        icon: Icons.receipt_long_outlined,
        iconColor: AppColors.success,
        statusText: 'En proceso',
        statusType: StatusType.warning,
      ),
      _ActivityItem(
        title: 'Autorización de procedimiento',
        subtitle: 'Resonancia magnética',
        date: 'Hace 1 semana',
        icon: Icons.verified_outlined,
        iconColor: AppColors.info,
        statusText: 'Aprobada',
        statusType: StatusType.success,
      ),
    ];

    return Column(
      children: activities
          .map((activity) => _buildActivityCard(activity))
          .toList(),
    );
  }

  Widget _buildActivityCard(_ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activity.iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Icon(
              activity.icon,
              color: activity.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      activity.date,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    StatusBadge(
                      text: activity.statusText,
                      type: activity.statusType,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.grey400,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color iconColor;
  final String statusText;
  final StatusType statusType;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.statusText,
    required this.statusType,
  });
}
