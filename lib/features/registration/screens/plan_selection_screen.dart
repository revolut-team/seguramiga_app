import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/insurance_plan_model.dart';
import '../../../shared/models/registration_data_model.dart';
import '../widgets/plan_comparison_card.dart';

/// Pantalla de selección de plan de seguro
class PlanSelectionScreen extends StatefulWidget {
  final RegistrationData? registrationData;

  const PlanSelectionScreen({
    super.key,
    this.registrationData,
  });

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  bool _isAnnual = false;
  InsurancePlan? _selectedPlan;

  void _selectPlan(InsurancePlan plan) {
    setState(() {
      _selectedPlan = plan;
    });

    // Navegar a checkout
    context.push(
      '/payment-checkout',
      extra: {
        'plan': plan,
        'isAnnual': _isAnnual,
        'registrationData': widget.registrationData,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Elige tu plan'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y descripción
              Text(
                'Planes disponibles',
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Elige el plan que mejor se adapte a tus necesidades',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Toggle mensual/anual
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pago ${_isAnnual ? 'anual' : 'mensual'}',
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_isAnnual) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingXs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentGreen.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(AppConstants.radiusSm),
                              ),
                              child: Text(
                                '15% de descuento',
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
                    Switch(
                      value: _isAnnual,
                      onChanged: (value) {
                        setState(() {
                          _isAnnual = value;
                        });
                      },
                      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                      thumbColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? AppColors.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Planes
              ...InsurancePlan.mockPlans.map((plan) => PlanComparisonCard(
                    plan: plan,
                    isAnnual: _isAnnual,
                    onSelect: () => _selectPlan(plan),
                    isSelected: _selectedPlan?.id == plan.id,
                  )),

              // Info adicional
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.infoLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¿Necesitas ayuda para elegir?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nuestro equipo está disponible para asesorarte en la selección del plan ideal para ti.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}
