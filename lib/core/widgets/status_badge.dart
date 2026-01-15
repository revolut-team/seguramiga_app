import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

enum StatusType { success, warning, error, info, neutral }

/// Badge de estado flexible para mostrar estados en tarjetas y listas
class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: _getColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.error:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
      case StatusType.neutral:
        return AppColors.grey500;
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.successLight;
      case StatusType.warning:
        return AppColors.warningLight;
      case StatusType.error:
        return AppColors.errorLight;
      case StatusType.info:
        return AppColors.infoLight;
      case StatusType.neutral:
        return AppColors.grey100;
    }
  }
}
