import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Tarjeta con información del plan contratado
class PlanInfoCard extends StatelessWidget {
  final String planName;
  final String planType;
  final String validUntil;
  final double coverageUsed;
  final VoidCallback? onViewDetails;

  const PlanInfoCard({
    super.key,
    required this.planName,
    required this.planType,
    required this.validUntil,
    required this.coverageUsed,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: AppTextStyles.h5,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      planType,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onViewDetails,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Vigencia
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Vigente hasta: $validUntil',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Uso de cobertura
          Text(
            'Uso de cobertura anual',
            style: AppTextStyles.labelMedium,
          ),
          const SizedBox(height: AppConstants.spacingXs),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: coverageUsed,
            backgroundColor: AppColors.grey200,
            progressColor: _getProgressColor(),
            barRadius: const Radius.circular(5),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(coverageUsed * 100).toInt()}% utilizado',
                style: AppTextStyles.caption,
              ),
              Text(
                '${((1 - coverageUsed) * 100).toInt()}% disponible',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Botones de acción rápida
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.local_hospital_outlined,
                  label: 'Coberturas',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.attach_money,
                  label: 'Límites',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.list_alt,
                  label: 'Detalles',
                  onTap: onViewDetails,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    if (coverageUsed < 0.5) return AppColors.success;
    if (coverageUsed < 0.75) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
