import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/profile_header.dart';
import '../widgets/plan_info_card.dart';
import '../widgets/profile_menu_item.dart';

/// Pantalla de perfil del usuario
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con información del usuario
              const ProfileHeader(
                name: 'Carlos García',
                email: 'carlos.garcia@email.com',
                phone: '+1 (555) 123-4567',
                avatarUrl: null,
              ),

              const SizedBox(height: AppConstants.spacingMd),

              // Información del plan
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                ),
                child: PlanInfoCard(
                  planName: 'Plan Premium Plus',
                  planType: 'Individual',
                  validUntil: '31/12/2025',
                  coverageUsed: 0.35,
                  onViewDetails: () {
                    context.push( '/plan-details');
                  },
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Menú de opciones
              _buildMenuSection(context),

              const SizedBox(height: AppConstants.spacingLg),

              // Sección de documentos
              _buildDocumentsSection(context),

              const SizedBox(height: AppConstants.spacingLg),

              // Configuración
              _buildSettingsSection(context),

              const SizedBox(height: AppConstants.spacingLg),

              // Cerrar sesión
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                ),
                child: CustomButton(
                  text: 'Cerrar sesión',
                  type: ButtonType.outline,
                  icon: Icons.logout,
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // Versión de la app
              Text(
                'Versión ${AppConstants.appVersion}',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Datos personales',
            subtitle: 'Edita tu información',
            onTap: () => context.push( '/personal-data'),
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.family_restroom,
            title: 'Dependientes',
            subtitle: '2 personas agregadas',
            onTap: () => context.push( '/dependents'),
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.history,
            title: 'Historial de uso',
            subtitle: 'Consultas, reembolsos y más',
            onTap: () => context.push( '/history'),
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.payment,
            title: 'Métodos de pago',
            subtitle: 'Gestiona tus tarjetas',
            onTap: () => context.push( '/payment-methods'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
          ),
          child: Text(
            'Documentos',
            style: AppTextStyles.h6,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.description_outlined,
                title: 'Mi póliza',
                subtitle: 'Descarga tu póliza digital',
                trailing: const Icon(
                  Icons.download,
                  color: AppColors.primary,
                  size: 20,
                ),
                onTap: () {},
              ),
              const Divider(height: 1),
              ProfileMenuItem(
                icon: Icons.badge_outlined,
                title: 'Carnet digital',
                subtitle: 'Muestra tu carnet en consultas',
                trailing: const Icon(
                  Icons.qr_code,
                  color: AppColors.primary,
                  size: 20,
                ),
                onTap: () => context.push( '/digital-card'),
              ),
              const Divider(height: 1),
              ProfileMenuItem(
                icon: Icons.receipt_outlined,
                title: 'Certificados',
                subtitle: 'Solicita certificados de cobertura',
                onTap: () => context.push( '/certificates'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
          ),
          child: Text(
            'Configuración',
            style: AppTextStyles.h6,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notificaciones',
                subtitle: 'Configura tus alertas',
                onTap: () => context.push( '/notification-settings'),
              ),
              const Divider(height: 1),
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Seguridad',
                subtitle: 'PIN y biometría',
                onTap: () => context.push( '/security-settings'),
              ),
              const Divider(height: 1),
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Ayuda y soporte',
                subtitle: 'FAQ y contacto',
                onTap: () => context.push( '/support'),
              ),
              const Divider(height: 1),
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacidad',
                subtitle: 'Términos y políticas',
                onTap: () => context.push( '/privacy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar sesión', style: AppTextStyles.h5),
        content: Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
