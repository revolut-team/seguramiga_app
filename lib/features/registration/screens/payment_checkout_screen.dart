import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/venezuela_data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/insurance_plan_model.dart';
import '../../../shared/models/registration_data_model.dart';
import '../../../shared/models/payment_details_model.dart';
import '../widgets/coverage_item.dart';

/// Pantalla de confirmación y checkout de pago
class PaymentCheckoutScreen extends StatefulWidget {
  final InsurancePlan plan;
  final bool isAnnual;
  final RegistrationData? registrationData;

  const PaymentCheckoutScreen({
    super.key,
    required this.plan,
    required this.isAnnual,
    this.registrationData,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  bool _termsAccepted = false;
  bool _isLoading = false;

  Future<void> _processPayment() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular procesamiento de pago
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Crear detalles de pago
    final price = widget.isAnnual
        ? widget.plan.annualDiscountedPrice
        : widget.plan.monthlyPrice;

    final paymentDetails = PaymentDetails(
      orderId: PaymentDetails.generateOrderId(),
      planId: widget.plan.id,
      planName: widget.plan.name,
      amount: price,
      frequency: widget.isAnnual
          ? PaymentFrequency.annual
          : PaymentFrequency.monthly,
      paymentDate: DateTime.now(),
      referenceNumber: PaymentDetails.generateOrderId(),
      status: PaymentStatus.completed,
    );

    setState(() {
      _isLoading = false;
    });

    // Navegar a pantalla de éxito
    context.go('/payment-success', extra: {
      'paymentDetails': paymentDetails,
      'registrationData': widget.registrationData,
    });
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.isAnnual
        ? widget.plan.annualDiscountedPrice
        : widget.plan.monthlyPrice;
    final priceInUSD = price / ExchangeRate.bcvRate;
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();
    final nextPayment = widget.isAnnual
        ? DateTime(now.year + 1, now.month, now.day)
        : DateTime(now.year, now.month + 1, now.day);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Confirmar pago'),
            centerTitle: true,
            backgroundColor: AppColors.white,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen del plan
                  Text(
                    'Resumen del plan',
                    style: AppTextStyles.h5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.plan.name,
                                style: AppTextStyles.h6.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.plan.tier.color,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingSm,
                                vertical: AppConstants.spacingXxs,
                              ),
                              decoration: BoxDecoration(
                                color: widget.plan.tier.color.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(AppConstants.radiusSm),
                              ),
                              child: Text(
                                widget.plan.tier.displayName,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: widget.plan.tier.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Precio
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${priceInUSD.toStringAsFixed(2)}',
                              style: AppTextStyles.numberMedium.copyWith(
                                color: widget.plan.tier.color,
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingXs),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '/ ${widget.isAnnual ? 'año' : 'mes'}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingXxs),
                        Text(
                          'Bs. ${price.toStringAsFixed(2)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingLg),

                        const Divider(),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Coberturas principales
                        Text(
                          'Coberturas principales:',
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        ...widget.plan.coverages.take(4).map((coverage) =>
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppConstants.spacingMd,
                              ),
                              child: CoverageItem(
                                coverage: coverage,
                                iconColor: widget.plan.tier.color,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // Datos personales
                  if (widget.registrationData != null) ...[
                    Text(
                      'Datos personales',
                      style: AppTextStyles.h5.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    InfoCard(
                      title: 'Titular del plan',
                      value: widget.registrationData!.fullName,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    InfoCard(
                      title: 'Documento',
                      value: widget.registrationData!.fullDocument,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    InfoCard(
                      title: 'Teléfono',
                      value: widget.registrationData!.phone ?? '',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    InfoCard(
                      title: 'Email',
                      value: widget.registrationData!.email ?? '',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],

                  // Información de pago
                  Text(
                    'Información de pago',
                    style: AppTextStyles.h5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),

                  CustomCard(
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Método de pago',
                          value: 'Pago móvil',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _InfoRow(
                          label: 'Monto a pagar',
                          value: '\$${priceInUSD.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: AppConstants.spacingXxs),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Bs. ${price.toStringAsFixed(2)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _InfoRow(
                          label: 'Frecuencia',
                          value: widget.isAnnual ? 'Anual' : 'Mensual',
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _InfoRow(
                          label: 'Primer pago',
                          value: dateFormatter.format(now),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        _InfoRow(
                          label: 'Próximo pago',
                          value: dateFormatter.format(nextPayment),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // Términos y condiciones
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                text: 'Acepto los ',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'términos y condiciones',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' del servicio',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // Botón procesar pago
                  CustomButton(
                    text: 'Procesar pago',
                    onPressed: _termsAccepted ? _processPayment : null,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),
        ),

        // Loading overlay
        if (_isLoading)
          LoadingOverlay(
            isLoading: true,
            message: 'Procesando pago...',
            child: Container(),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
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
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
