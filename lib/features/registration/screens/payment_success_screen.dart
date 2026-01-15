import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/payment_details_model.dart';
import '../../../shared/models/registration_data_model.dart';
import '../../../shared/models/user_insurance_model.dart';

/// Pantalla de confirmación de pago exitoso
class PaymentSuccessScreen extends StatefulWidget {
  final PaymentDetails paymentDetails;
  final RegistrationData? registrationData;

  const PaymentSuccessScreen({
    super.key,
    required this.paymentDetails,
    this.registrationData,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _updateUserInsurance();
  }

  void _updateUserInsurance() {
    // En una app real, aquí se actualizaría el estado global o se haría una llamada a la API
    // Por ahora solo actualizamos el mock data
    if (widget.registrationData != null) {
      // Aquí se actualizaría UserInsuranceModel.mockUser con los datos reales
      debugPrint('Usuario registrado: ${widget.registrationData!.fullName}');
      debugPrint('Plan contratado: ${widget.paymentDetails.planName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pago exitoso'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacingXl),

              // Icono de éxito
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

              // Título
              Text(
                '¡Bienvenido a SeguroApp!',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingSm),

              // Subtítulo
              Text(
                'Tu plan ha sido activado exitosamente',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Detalles del pago
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Detalles del pago',
                            style: AppTextStyles.h6.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        StatusBadge(
                          text: 'Activo',
                          type: StatusType.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    _DetailRow(
                      label: 'Número de orden',
                      value: widget.paymentDetails.orderId,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Plan contratado',
                      value: widget.paymentDetails.planName,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Monto pagado',
                      value: '\$${(widget.paymentDetails.amount / 36.45).toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: AppConstants.spacingXxs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Bs. ${widget.paymentDetails.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Método de pago',
                      value: widget.paymentDetails.paymentMethod,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Fecha de pago',
                      value: dateFormatter.format(widget.paymentDetails.paymentDate),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Hora',
                      value: timeFormatter.format(widget.paymentDetails.paymentDate),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _DetailRow(
                      label: 'Próximo pago',
                      value: dateFormatter.format(
                        widget.paymentDetails.nextPaymentDate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Info de credencial digital
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
                      Icons.credit_card,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tu credencial digital ya está disponible',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Podrás usarla en toda nuestra red de proveedores médicos y farmacias.',
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

              // Qué sigue
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.explore,
                      color: AppColors.white,
                      size: 32,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explora tus beneficios',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Descubre todos los servicios disponibles para ti',
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
                text: 'Ver mi credencial',
                onPressed: () {
                  context.go('/profile');
                },
                isFullWidth: true,
              ),
              const SizedBox(height: AppConstants.spacingMd),

              CustomButton(
                text: 'Ir al inicio',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
