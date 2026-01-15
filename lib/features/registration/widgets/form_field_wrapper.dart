import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Wrapper para campos de formulario con label, helper y error
class FormFieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final bool isRequired;

  const FormFieldWrapper({
    super.key,
    required this.label,
    required this.child,
    this.helperText,
    this.errorText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingXs),

        // Campo
        child,

        // Helper o error text
        if (helperText != null || errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spacingXxs),
            child: Row(
              children: [
                if (errorText != null)
                  Icon(
                    Icons.error_outline,
                    size: 14,
                    color: AppColors.error,
                  ),
                if (errorText != null) const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText ?? helperText!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: errorText != null
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
