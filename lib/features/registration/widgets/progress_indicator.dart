import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Indicador de progreso para el flujo de registro
class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps,
        (index) {
          final stepNumber = index + 1;
          final isCompleted = stepNumber < currentStep;
          final isCurrent = stepNumber == currentStep;

          return Row(
            children: [
              _StepDot(
                isCompleted: isCompleted,
                isCurrent: isCurrent,
              ),
              if (index < totalSteps - 1)
                Container(
                  width: 24,
                  height: 2,
                  color: isCompleted ? AppColors.primary : AppColors.grey300,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;

  const _StepDot({
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent ? AppColors.primary : AppColors.grey300,
        border: Border.all(
          color: isCompleted || isCurrent ? AppColors.primary : AppColors.grey300,
          width: isCurrent ? 2 : 0,
        ),
      ),
      child: isCompleted
          ? const Icon(
              Icons.check,
              size: 8,
              color: AppColors.white,
            )
          : null,
    );
  }
}
