import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de Emergencia
/// Solicitud de ambulancia y asistencia médica inmediata
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _isEmergencyActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isEmergencyActive ? AppColors.emergency : AppColors.background,
      appBar: AppBar(
        backgroundColor: _isEmergencyActive ? AppColors.emergency : null,
        foregroundColor: _isEmergencyActive ? AppColors.white : null,
        title: Text(_isEmergencyActive ? 'Emergencia Activa' : 'Emergencia'),
      ),
      body: _isEmergencyActive ? _buildActiveEmergency() : _buildEmergencyOptions(),
    );
  }

  Widget _buildEmergencyOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        children: [
          // Botón principal de emergencia
          GestureDetector(
            onTap: () => _showEmergencyConfirmation(context),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppColors.emergencyGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergency.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emergency,
                    color: AppColors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'EMERGENCIA',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Presiona para solicitar ayuda inmediata',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Opciones de emergencia
          const SectionHeader(title: 'Tipo de emergencia'),
          const SizedBox(height: AppConstants.spacingMd),

          _EmergencyTypeCard(
            icon: Icons.local_hospital,
            title: 'Ambulancia',
            subtitle: 'Solicitar ambulancia a tu ubicación',
            color: AppColors.emergency,
            onTap: () => _showEmergencyConfirmation(context, type: 'ambulancia'),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _EmergencyTypeCard(
            icon: Icons.phone,
            title: 'Llamar a emergencias',
            subtitle: 'Contactar directamente con central de emergencias',
            color: AppColors.warning,
            onTap: () => _callEmergency(),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _EmergencyTypeCard(
            icon: Icons.local_police,
            title: 'Asistencia vial',
            subtitle: 'Accidente de tránsito o emergencia vial',
            color: AppColors.secondary,
            onTap: () => _showEmergencyConfirmation(context, type: 'vial'),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _EmergencyTypeCard(
            icon: Icons.chat,
            title: 'Chat de emergencia',
            subtitle: 'Comunicarte con un médico de emergencia',
            color: AppColors.accentGreen,
            onTap: () {},
          ),

          const SizedBox(height: AppConstants.spacingXl),

          // Información importante
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info, color: AppColors.info),
                    const SizedBox(width: 8),
                    Text('Información importante', style: AppTextStyles.bodyLarge),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  '• Tu ubicación será enviada automáticamente\n'
                  '• Mantén tu teléfono encendido y con batería\n'
                  '• Si es posible, permanece en un lugar seguro\n'
                  '• Un agente te contactará en segundos',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.spacingLg),

          // Contactos de emergencia
          const SectionHeader(title: 'Contactos de emergencia'),
          const SizedBox(height: AppConstants.spacingMd),

          _EmergencyContactCard(
            name: 'María García',
            relation: 'Esposa',
            phone: '+507 6123-4567',
            onCall: () {},
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _EmergencyContactCard(
            name: 'Juan García',
            relation: 'Hermano',
            phone: '+507 6789-0123',
            onCall: () {},
          ),

          const SizedBox(height: AppConstants.spacingMd),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Agregar contacto'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveEmergency() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animación de pulso
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emergency,
                      color: AppColors.emergency,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                'Ayuda en camino',
                style: AppTextStyles.h3.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Tiempo estimado de llegada',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '8-12 minutos',
                style: AppTextStyles.h2.copyWith(color: AppColors.white),
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // Info de la ambulancia
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.white.withValues(alpha: 0.2),
                          child: const Icon(Icons.local_hospital, color: AppColors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ambulancia AMB-124',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Centro Médico Principal',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: _ActiveInfoItem(
                            icon: Icons.person,
                            label: 'Paramédico',
                            value: 'Dr. López',
                          ),
                        ),
                        Expanded(
                          child: _ActiveInfoItem(
                            icon: Icons.phone,
                            label: 'Contacto',
                            value: '*123',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Acciones
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.phone,
                        label: 'Llamar',
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.chat,
                        label: 'Chat',
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.location_on,
                        label: 'Ubicación',
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.contacts,
                        label: 'Contactos',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _cancelEmergency(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Cancelar emergencia'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEmergencyConfirmation(BuildContext context, {String type = 'general'}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.emergency.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.emergency, color: AppColors.emergency),
            ),
            const SizedBox(width: 12),
            const Text('Confirmar emergencia'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas solicitar ayuda de emergencia?',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.grey500, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tu ubicación actual será compartida',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isEmergencyActive = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergency,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _callEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Llamando a emergencias...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar emergencia'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar la emergencia? '
          'Si la situación ha cambiado, confirma la cancelación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isEmergencyActive = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Confirmar cancelación'),
          ),
        ],
      ),
    );
  }
}

class _EmergencyTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey400),
        ],
      ),
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  final String name;
  final String relation;
  final String phone;
  final VoidCallback onCall;

  const _EmergencyContactCard({
    required this.name,
    required this.relation,
    required this.phone,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name[0],
              style: AppTextStyles.h6.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium),
                Text(
                  '$relation • $phone',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCall,
            icon: const Icon(Icons.phone),
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _ActiveInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ActiveInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.white.withValues(alpha: 0.7), size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
