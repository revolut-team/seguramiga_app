import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/user_header.dart';
import '../widgets/insurance_card.dart';
import '../widgets/services_grid.dart';
import '../widgets/recent_activity.dart';
import '../widgets/benefits_banner.dart';

/// Pantalla principal (Home) de la aplicación
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleEmergency() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEmergencyBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header con usuario
            SliverToBoxAdapter(
              child: UserHeader(
                userName: 'Carlos García',
                greeting: _getGreeting(),
                avatarUrl: null,
                onNotificationTap: () {
                  context.push( '/notifications');
                },
                notificationCount: 3,
              ),
            ),

            // Tarjeta de seguro
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.spacingMd,
                  AppConstants.spacingXs,
                  AppConstants.spacingMd,
                  AppConstants.spacingMd,
                ),
                child: InsuranceCard(
                  planName: 'Plan Premium Plus',
                  memberId: 'SEG-2024-001234',
                  validUntil: '31/12/2025',
                  onTap: () => context.push( '/insurance-details'),
                ),
              ),
            ),

            // Botón de emergencia destacado
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                child: _buildEmergencySection(),
              ),
            ),

            // Servicios principales
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Servicios',
                      actionText: 'Ver todos',
                      actionIcon: Icons.arrow_forward_ios,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    ServicesGrid(
                      onServiceTap: (service) {
                        context.push( '/$service');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Banner de beneficios
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                ),
                child: BenefitsBanner(
                  onTap: () => context.push( '/benefits'),
                ),
              ),
            ),

            // Actividad reciente
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Actividad reciente',
                      actionText: 'Ver historial',
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    const RecentActivity(),
                  ],
                ),
              ),
            ),

            // Espacio inferior
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  Widget _buildEmergencySection() {
    return CustomCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.emergency.withValues(alpha: 0.1),
          AppColors.emergencyLight.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: AppColors.emergency.withValues(alpha: 0.3),
        width: 1,
      ),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          EmergencyButton(
            onPressed: _handleEmergency,
            size: 60,
            showLabel: false,
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Necesitas ayuda urgente?',
                  style: AppTextStyles.h6.copyWith(
                    color: AppColors.emergency,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Presiona para solicitar ambulancia o asistencia médica inmediata',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.emergency.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emergency,
              size: 40,
              color: AppColors.emergency,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            '¿Confirmar emergencia?',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            'Se enviará tu ubicación y se contactará a servicios de emergencia',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancelar',
                  type: ButtonType.outline,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: CustomButton(
                  text: 'Confirmar',
                  type: ButtonType.emergency,
                  icon: Icons.phone,
                  onPressed: () {
                    context.pop();
                    context.push( '/emergency');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
        ],
      ),
    );
  }
}
