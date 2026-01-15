import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Botón de acción rápida para el grid del Home
class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showNotification;
  final int notificationCount;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.showNotification = false,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    size: 26,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
                if (showNotification && notificationCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.emergency,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          notificationCount > 9 ? '9+' : notificationCount.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
