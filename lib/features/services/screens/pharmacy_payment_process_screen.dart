import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import 'pharmacy_payment_methods_screen.dart';

/// Tasa BCV oficial del día
const double _tasaBCV = 336.45;

/// Formatea un monto en bolívares
String _formatBs(double amountUSD) {
  final bs = amountUSD * _tasaBCV;
  final formatter = NumberFormat('#,##0.00', 'es_VE');
  return 'Bs. ${formatter.format(bs)}';
}

/// Pantalla de procesamiento de pago para farmacia
class PharmacyPaymentProcessScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const PharmacyPaymentProcessScreen({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<PharmacyPaymentProcessScreen> createState() =>
      _PharmacyPaymentProcessScreenState();
}

class _PharmacyPaymentProcessScreenState
    extends State<PharmacyPaymentProcessScreen> {
  final TextEditingController _referenceController = TextEditingController();
  bool _isProcessing = false;

  // Datos bancarios simulados
  static const String _bankName = 'Banco Provincial';
  static const String _accountNumber = '0108-0123-45-0123456789';
  static const String _accountHolder = 'SeguroApp, C.A.';
  static const String _rif = 'J-12345678-9';
  static const String _phoneNumber = '0424-1234567';

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copiado al portapapeles'),
        backgroundColor: AppColors.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmPayment() async {
    if (_referenceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el número de referencia'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simular proceso de validación de pago
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Navegar a pantalla de éxito
    context.go('/pharmacy/payment-success', extra: {
      'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'reference': _referenceController.text,
      'totalAmount': widget.totalAmount,
      'paymentMethod': widget.paymentMethod.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.paymentMethod.name),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Monto a pagar
                  CustomCard(
                    gradient: AppColors.primaryGradient,
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monto a pagar',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        Text(
                          _formatBs(widget.totalAmount),
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)} USD',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // Instrucciones según método de pago
                  Text(
                    'Datos para el pago',
                    style: AppTextStyles.h6.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),

                  if (widget.paymentMethod.type == PaymentMethodType.transfer)
                    _buildTransferInfo()
                  else if (widget.paymentMethod.type ==
                          PaymentMethodType.pagoMovil ||
                      widget.paymentMethod.type ==
                          PaymentMethodType.pagoMovilInmediato)
                    _buildPagoMovilInfo(),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Campo de referencia
                  Text(
                    'Número de referencia',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa el número de referencia',
                      prefixIcon: const Icon(Icons.receipt_long),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 20,
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Nota informativa
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
                                'Importante',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.info,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Una vez realizado el pago, ingresa el número de referencia para validar tu compra. El pedido será procesado una vez confirmemos el pago.',
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

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isProcessing)
            Container(
              color: AppColors.grey900.withValues(alpha: 0.7),
              child: Center(
                child: CustomCard(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        'Validando pago...',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Text(
                        'Por favor espera',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
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
            text: 'Confirmar pago',
            onPressed: _isProcessing ? null : _confirmPayment,
            isFullWidth: true,
          ),
        ),
      ),
    );
  }

  Widget _buildTransferInfo() {
    return Column(
      children: [
        _InfoTile(
          label: 'Banco',
          value: _bankName,
          icon: Icons.account_balance,
          onCopy: () => _copyToClipboard(_bankName, 'Banco'),
        ),
        _InfoTile(
          label: 'Número de cuenta',
          value: _accountNumber,
          icon: Icons.credit_card,
          onCopy: () => _copyToClipboard(_accountNumber, 'Número de cuenta'),
        ),
        _InfoTile(
          label: 'Titular',
          value: _accountHolder,
          icon: Icons.person,
          onCopy: () => _copyToClipboard(_accountHolder, 'Titular'),
        ),
        _InfoTile(
          label: 'RIF',
          value: _rif,
          icon: Icons.badge,
          onCopy: () => _copyToClipboard(_rif, 'RIF'),
        ),
        _InfoTile(
          label: 'Monto exacto',
          value: _formatBs(widget.totalAmount),
          icon: Icons.payments,
          onCopy: () => _copyToClipboard(
            (widget.totalAmount * _tasaBCV).toStringAsFixed(2),
            'Monto',
          ),
        ),
      ],
    );
  }

  Widget _buildPagoMovilInfo() {
    return Column(
      children: [
        _InfoTile(
          label: 'Banco',
          value: _bankName,
          icon: Icons.account_balance,
          onCopy: () => _copyToClipboard(_bankName, 'Banco'),
        ),
        _InfoTile(
          label: 'Teléfono',
          value: _phoneNumber,
          icon: Icons.phone,
          onCopy: () => _copyToClipboard(_phoneNumber, 'Teléfono'),
        ),
        _InfoTile(
          label: 'Cédula/RIF',
          value: _rif,
          icon: Icons.badge,
          onCopy: () => _copyToClipboard(_rif, 'RIF'),
        ),
        _InfoTile(
          label: 'Monto exacto',
          value: _formatBs(widget.totalAmount),
          icon: Icons.payments,
          onCopy: () => _copyToClipboard(
            (widget.totalAmount * _tasaBCV).toStringAsFixed(2),
            'Monto',
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onCopy;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: onCopy,
            color: AppColors.primary,
            tooltip: 'Copiar',
          ),
        ],
      ),
    );
  }
}
