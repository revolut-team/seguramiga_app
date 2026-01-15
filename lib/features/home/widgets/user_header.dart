import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Header con información del usuario y notificaciones
class UserHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const UserHeader({
    super.key,
    required this.userName,
    required this.greeting,
    this.avatarUrl,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          const SizedBox(width: AppConstants.spacingMd),

          // Saludo y nombre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  userName,
                  style: AppTextStyles.h5,
                ),
              ],
            ),
          ),

          // Notificaciones
          _buildNotificationButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = userName.split(' ').map((e) => e[0]).take(2).join();
    return Center(
      child: Text(
        initials.toUpperCase(),
        style: AppTextStyles.h6.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(
            Icons.notifications_outlined,
            size: 28,
            color: AppColors.textPrimary,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.grey100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 18,
              height: 18,
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
    );
  }
}
