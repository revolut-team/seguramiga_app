import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Pantalla de confirmación de pago exitoso para farmacia
class PharmacyPaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  final String reference;
  final double totalAmount;
  final String paymentMethod;

  const PharmacyPaymentSuccessScreen({
    super.key,
    required this.orderId,
    required this.reference,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pago confirmado'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacingXl),

              // Ícono de éxito
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.accentGreen,
                  size: 80,
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              Text(
                'Pago registrado',
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGreen,
                ),
              ),

              const SizedBox(height: AppConstants.spacingSm),

              Text(
                'Tu pago ha sido registrado exitosamente',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // Detalles del pedido
              CustomCard(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalles del pedido',
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Número de orden',
                      value: orderId,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DetailRow(
                      label: 'Referencia de pago',
                      value: reference,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DetailRow(
                      label: 'Método de pago',
                      value: paymentMethod,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DetailRow(
                      label: 'Monto',
                      value: '\$${totalAmount.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DetailRow(
                      label: 'Fecha',
                      value: dateFormatter.format(now),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    _DetailRow(
                      label: 'Hora',
                      value: timeFormatter.format(now),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Información de seguimiento
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.infoLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Próximos pasos',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Validaremos tu pago en las próximas horas. Una vez confirmado, procesaremos tu pedido y te notificaremos cuando esté en camino.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Tiempo estimado de entrega
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      color: AppColors.white,
                      size: 32,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entrega estimada',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '24-48 horas hábiles',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // Botones de acción
              CustomButton(
                text: 'Ver mis pedidos',
                onPressed: () {
                  // Navegar a historial de pedidos
                  context.go('/pharmacy');
                },
                isFullWidth: true,
              ),

              const SizedBox(height: AppConstants.spacingMd),

              CustomButton(
                text: 'Volver al inicio',
                type: ButtonType.outline,
                onPressed: () {
                  context.go('/home');
                },
                isFullWidth: true,
              ),

              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
