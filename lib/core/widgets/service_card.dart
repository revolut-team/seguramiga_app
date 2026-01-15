import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Tarjeta de servicio para el Home
class ServiceCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showBadge;
  final String? badgeText;
  final bool isCompact;

  const ServiceCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.showBadge = false,
    this.badgeText,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey300.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isCompact ? _buildCompactContent() : _buildFullContent(),
        ),
      ),
    );
  }

  Widget _buildCompactContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconContainer(40),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.labelMedium,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFullContent() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconContainer(48),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.h6,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: AppTextStyles.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        if (showBadge) _buildBadge(),
      ],
    );
  }

  Widget _buildIconContainer(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: iconColor ?? AppColors.primary,
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.emergency,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Text(
          badgeText ?? '',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
