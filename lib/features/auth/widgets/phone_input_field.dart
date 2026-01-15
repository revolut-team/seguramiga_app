import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Campo de entrada de número de teléfono con código de país
/// Valida en tiempo real que el número comience con 04
class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String countryCode;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.countryCode = '+58',
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String? _realtimeError;

  void _validateRealtime(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    setState(() {
      if (digits.isEmpty) {
        _realtimeError = null;
      } else if (digits.length >= 1 && digits[0] != '0') {
        _realtimeError = 'El número debe comenzar con 0';
      } else if (digits.length >= 2 && digits[1] != '4') {
        _realtimeError = 'El número debe comenzar con 04';
      } else if (digits.length >= 4) {
        final prefix = digits.substring(0, 4);
        final validPrefixes = ['0412', '0414', '0416', '0424', '0426'];
        if (!validPrefixes.contains(prefix)) {
          _realtimeError = 'Prefijo no válido. Use: 0412, 0414, 0416, 0424 o 0426';
        } else {
          _realtimeError = null;
        }
      } else {
        _realtimeError = null;
      }
    });

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _realtimeError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número de teléfono',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingXs),
        Container(
          decoration: BoxDecoration(
            color: hasError ? AppColors.error.withValues(alpha: 0.05) : AppColors.grey50,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.grey200,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Código de país
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingMd,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: hasError ? AppColors.error.withValues(alpha: 0.3) : AppColors.grey200,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🇻🇪',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.countryCode,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grey500,
                      size: 20,
                    ),
                  ],
                ),
              ),

              // Campo de número
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: hasError ? AppColors.error : null,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    _VenezuelaPhoneFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: '0414-123-4567',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.grey400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingMd,
                    ),
                    suffixIcon: hasError
                        ? const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                          )
                        : widget.controller.text.replaceAll(RegExp(r'\D'), '').length == 11
                            ? const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              )
                            : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                  ),
                  onChanged: _validateRealtime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu número de teléfono';
                    }
                    final digits = value.replaceAll(RegExp(r'\D'), '');
                    if (digits.length < 11) {
                      return 'Número de teléfono incompleto';
                    }
                    final validationError = _validateVenezuelanPhone(digits);
                    if (validationError != null) {
                      return validationError;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        // Mensaje de error en tiempo real
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spacingXs, left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.error,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _realtimeError!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Valida que el número sea un teléfono venezolano válido
String? _validateVenezuelanPhone(String digits) {
  if (digits.length != 11) {
    return 'Número de teléfono inválido';
  }

  // Debe comenzar con 0
  if (!digits.startsWith('0')) {
    return 'El número debe comenzar con 0';
  }

  // Prefijos válidos de operadoras móviles venezolanas
  final mobileOperators = [
    '0412', // Digitel
    '0414', // Movistar
    '0416', // Movistar
    '0424', // Movistar
    '0426', // Movilnet
  ];

  // Prefijos válidos de teléfonos fijos (códigos de área)
  final landlineAreaCodes = [
    '0212', // Caracas
    '0241', // Valencia
    '0243', // Maracay
    '0244', // Maracay
    '0245', // Valencia
    '0251', // Barquisimeto
    '0252', // Barquisimeto
    '0253', // Barquisimeto
    '0254', // Araure/Acarigua
    '0255', // San Felipe
    '0256', // Guanare
    '0257', // Barinas
    '0258', // Portuguesa
    '0261', // Maracaibo
    '0262', // Cabimas
    '0263', // Machiques
    '0264', // Ciudad Ojeda
    '0265', // Maracaibo
    '0266', // San Cristóbal
    '0267', // Barinas
    '0268', // Mérida
    '0269', // Coro
    '0271', // Mérida
    '0272', // Trujillo
    '0273', // El Vigía
    '0274', // Mérida
    '0275', // Valera
    '0276', // San Cristóbal
    '0277', // San Antonio del Táchira
    '0278', // Táchira
    '0281', // Puerto La Cruz
    '0282', // El Tigre
    '0283', // Anaco
    '0284', // Ciudad Bolívar
    '0285', // Ciudad Guayana
    '0286', // Ciudad Guayana
    '0287', // Tucupita
    '0288', // Puerto Ordaz
    '0289', // Bolívar
    '0291', // Maturín
    '0292', // Cumaná
    '0293', // Carúpano
    '0294', // Margarita
    '0295', // Margarita
    '0296', // Monagas
  ];

  final prefix = digits.substring(0, 4);

  // Verificar si es móvil o fijo válido
  final isMobile = mobileOperators.contains(prefix);
  final isLandline = landlineAreaCodes.contains(prefix);

  if (!isMobile && !isLandline) {
    return 'Prefijo de operadora no válido';
  }

  return null;
}

/// Formateador de número de teléfono venezolano XXXX-XXX-XXXX
class _VenezuelaPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length && i < 11; i++) {
      if (i == 4) buffer.write('-');
      if (i == 7) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
