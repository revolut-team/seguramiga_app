import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/venezuela_data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/insurance_plan_model.dart';

/// Tarjeta de comparación de planes de seguro
class PlanComparisonCard extends StatelessWidget {
  final InsurancePlan plan;
  final bool isAnnual;
  final VoidCallback onSelect;
  final bool isSelected;

  const PlanComparisonCard({
    super.key,
    required this.plan,
    required this.isAnnual,
    required this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? plan.annualDiscountedPrice : plan.monthlyPrice;
    final priceInUSD = price / ExchangeRate.bcvRate;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isSelected
              ? plan.tier.color
              : (plan.isRecommended ? plan.tier.color : AppColors.grey300),
          width: isSelected || plan.isRecommended ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSelected ? plan.tier.color : AppColors.grey300)
                .withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              color: plan.tier.color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLg),
                topRight: Radius.circular(AppConstants.radiusLg),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: AppTextStyles.h5.copyWith(
                          fontWeight: FontWeight.bold,
                          color: plan.tier.color,
                        ),
                      ),
                    ),
                    if (plan.isRecommended)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingSm,
                          vertical: AppConstants.spacingXxs,
                        ),
                        decoration: BoxDecoration(
                          color: plan.tier.color,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          'Recomendado',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Precio
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${priceInUSD.toStringAsFixed(2)}',
                      style: AppTextStyles.numberLarge.copyWith(
                        color: plan.tier.color,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingXs),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '/ ${isAnnual ? 'año' : 'mes'}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXxs),
                Text(
                  'Bs. ${price.toStringAsFixed(2)} ${isAnnual ? 'anuales' : 'mensuales'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                // Ahorro anual
                if (isAnnual) ...[
                  const SizedBox(height: AppConstants.spacingXs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSm,
                      vertical: AppConstants.spacingXxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                    ),
                    child: Text(
                      'Ahorra \$${(plan.annualSavings / ExchangeRate.bcvRate).toStringAsFixed(2)} al año',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Características incluidas:',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Lista de features
                ...plan.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingSm,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: plan.tier.color,
                          ),
                          const SizedBox(width: AppConstants.spacingSm),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                // Limitaciones
                if (plan.limitations.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'Limitaciones:',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  ...plan.limitations.map((limitation) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.spacingXs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: AppConstants.spacingSm),
                            Expanded(
                              child: Text(
                                limitation,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],

                const SizedBox(height: AppConstants.spacingLg),

                // Botón seleccionar
                CustomButton(
                  text: isSelected ? 'Seleccionado' : 'Seleccionar este plan',
                  onPressed: isSelected ? null : onSelect,
                  isFullWidth: true,
                  type: isSelected ? ButtonType.outline : ButtonType.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
