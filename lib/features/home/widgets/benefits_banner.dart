import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Banner de beneficios del plan
class BenefitsBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const BenefitsBanner({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent,
              AppColors.accent.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: const Icon(
                Icons.card_giftcard,
                color: AppColors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descubre tus beneficios',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu plan incluye descuentos exclusivos en farmacias, gimnasios y más',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
