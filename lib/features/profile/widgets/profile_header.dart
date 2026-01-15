import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Header del perfil con avatar e información
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingMd),

          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildInitials(),
                        )
                      : _buildInitials(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Nombre
          Text(
            name,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppConstants.spacingXs),

          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                color: AppColors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                email,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Teléfono
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_outlined,
                color: AppColors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                phone,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMd),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    final initials = name.split(' ').map((e) => e[0]).take(2).join();
    return Container(
      color: AppColors.secondaryLight,
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.h2.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
