import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/quick_action_button.dart';

/// Grid de servicios principales del Home
class ServicesGrid extends StatelessWidget {
  final Function(String) onServiceTap;

  const ServicesGrid({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItem(
        id: 'telemedicine',
        label: 'Telemedicina',
        icon: Icons.video_call_outlined,
        color: AppColors.secondary,
      ),
      _ServiceItem(
        id: 'pharmacy',
        label: 'Farmacia',
        icon: Icons.local_pharmacy_outlined,
        color: AppColors.accentGreen,
      ),
      _ServiceItem(
        id: 'appointments',
        label: 'Citas',
        icon: Icons.calendar_month_outlined,
        color: AppColors.accent,
        notificationCount: 1,
      ),
      _ServiceItem(
        id: 'directory',
        label: 'Directorio',
        icon: Icons.local_hospital_outlined,
        color: AppColors.primaryLight,
      ),
      _ServiceItem(
        id: 'exams',
        label: 'Exámenes',
        icon: Icons.science_outlined,
        color: AppColors.accentOrange,
      ),
      _ServiceItem(
        id: 'reimbursements',
        label: 'Reembolsos',
        icon: Icons.receipt_long_outlined,
        color: AppColors.success,
        notificationCount: 2,
      ),
      _ServiceItem(
        id: 'authorizations',
        label: 'Autorizaciones',
        icon: Icons.verified_outlined,
        color: AppColors.info,
      ),
      _ServiceItem(
        id: 'claims',
        label: 'Reclamos',
        icon: Icons.description_outlined,
        color: AppColors.warning,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return QuickActionButton(
          label: service.label,
          icon: service.icon,
          iconColor: service.color,
          showNotification: service.notificationCount > 0,
          notificationCount: service.notificationCount,
          onTap: () => onServiceTap(service.id),
        );
      },
    );
  }
}

class _ServiceItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final int notificationCount;

  const _ServiceItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.notificationCount = 0,
  });
}
