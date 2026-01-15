import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';

/// Modelo para método de pago
enum PaymentMethodType {
  transfer,
  pagoMovil,
  pagoMovilInmediato,
}

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final PaymentMethodType type;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
  });
}

/// Pantalla de selección de métodos de pago para farmacia
class PharmacyPaymentMethodsScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const PharmacyPaymentMethodsScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<PharmacyPaymentMethodsScreen> createState() =>
      _PharmacyPaymentMethodsScreenState();
}

class _PharmacyPaymentMethodsScreenState
    extends State<PharmacyPaymentMethodsScreen> {
  PaymentMethod? _selectedMethod;

  static const List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'transfer',
      name: 'Transferencia Bancaria',
      description: 'Transferencia a cuenta bancaria',
      icon: Icons.account_balance,
      type: PaymentMethodType.transfer,
    ),
    PaymentMethod(
      id: 'pago-movil',
      name: 'Pago Móvil',
      description: 'Pago móvil tradicional',
      icon: Icons.phone_android,
      type: PaymentMethodType.pagoMovil,
    ),
    PaymentMethod(
      id: 'pago-movil-inmediato',
      name: 'Pago Móvil Inmediato',
      description: 'Pago móvil con confirmación inmediata',
      icon: Icons.flash_on,
      type: PaymentMethodType.pagoMovilInmediato,
    ),
  ];

  void _continueToPayment() {
    if (_selectedMethod == null) return;

    context.push(
      '/pharmacy/payment-process',
      extra: {
        'paymentMethod': _selectedMethod,
        'totalAmount': widget.totalAmount,
        'cartItems': widget.cartItems,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Método de pago'),
      ),
      body: Column(
        children: [
          // Resumen del pedido
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey300.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen del pedido',
                  style: AppTextStyles.h6.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.cartItems.length} producto(s)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${widget.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de métodos de pago
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              children: [
                Text(
                  'Selecciona un método de pago',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),
                ..._paymentMethods.map((method) => _PaymentMethodCard(
                      method: method,
                      isSelected: _selectedMethod?.id == method.id,
                      onTap: () {
                        setState(() {
                          _selectedMethod = method;
                        });
                      },
                    )),
              ],
            ),
          ),

          // Botón de continuar
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey300.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                text: 'Continuar',
                onPressed: _selectedMethod != null ? _continueToPayment : null,
                isFullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.primary : AppColors.grey400)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(
                method.icon,
                color: isSelected ? AppColors.primary : AppColors.grey400,
                size: 28,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.grey300,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
