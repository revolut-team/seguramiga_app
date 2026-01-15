import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Tarjeta de seguro del usuario (carnet digital)
class InsuranceCard extends StatelessWidget {
  final String planName;
  final String memberId;
  final String validUntil;
  final VoidCallback? onTap;

  const InsuranceCard({
    super.key,
    required this.planName,
    required this.memberId,
    required this.validUntil,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Seguramiga',
                      style: AppTextStyles.h6.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    'Activo',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Plan name
            Text(
              planName,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Details
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn('No. de Miembro', memberId),
                ),
                Expanded(
                  child: _buildInfoColumn('Válido hasta', validUntil),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingMd),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Toca para ver detalles',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
                Icon(
                  Icons.qr_code_rounded,
                  color: AppColors.white.withValues(alpha: 0.8),
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
