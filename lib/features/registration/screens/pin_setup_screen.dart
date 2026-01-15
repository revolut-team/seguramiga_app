import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/registration_data_model.dart';
import '../widgets/progress_indicator.dart';

/// Pantalla de configuración de PIN (Paso 4/4)
class PinSetupScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const PinSetupScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String _pin = '';
  String _confirmPin = '';
  bool _isPinComplete = false;
  bool _isConfirmPinComplete = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // Prevenir errores al cambiar de ruta
    super.deactivate();
  }

  bool _isWeakPin(String pin) {
    // Validar PINs débiles comunes
    final weakPins = [
      '0000',
      '1111',
      '2222',
      '3333',
      '4444',
      '5555',
      '6666',
      '7777',
      '8888',
      '9999',
      '1234',
      '4321',
      '1122',
      '2211',
    ];
    return weakPins.contains(pin);
  }

  Future<void> _completeRegistration() async {
    if (!mounted) return;

    setState(() {
      _errorMessage = null;
    });

    // Validar que los PINs estén completos
    if (_pin.length != 4 || _confirmPin.length != 4) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Debes completar ambos PINs';
      });
      HapticFeedback.heavyImpact();
      return;
    }

    // Validar que los PINs coincidan
    if (_pin != _confirmPin) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Los PINs no coinciden';
      });
      HapticFeedback.heavyImpact();
      return;
    }

    // Validar PIN débil
    if (_isWeakPin(_pin)) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Este PIN es muy común. Usa uno más seguro';
      });
      HapticFeedback.heavyImpact();
      return;
    }

    // Guardar PIN y completar registro
    final updatedData = widget.registrationData.copyWith(pin: _pin);

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    // Simular guardado en servidor
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navegar a selección de plan (sin setState después de navegar)
    if (mounted) {
      context.go('/plan-selection', extra: updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Registro'),
            centerTitle: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                child: RegistrationProgressIndicator(
                  currentStep: 4,
                  totalSteps: 4,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppConstants.spacingXl),

                  // Icono
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  Text(
                    'Crea tu PIN de acceso',
                    style: AppTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    'Lo usarás para ingresar a la app de forma segura',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // PIN principal
                  Text(
                    'Ingresa tu PIN (4 dígitos)',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: _pinController,
                    obscureText: true,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      fieldHeight: 56,
                      fieldWidth: 56,
                      activeFillColor: AppColors.white,
                      inactiveFillColor: AppColors.grey50,
                      selectedFillColor: AppColors.white,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.grey200,
                      selectedColor: AppColors.primary,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        _pin = value;
                        _isPinComplete = value.length == 4;
                        _errorMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // Confirmar PIN
                  Text(
                    'Confirma tu PIN',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: _confirmPinController,
                    obscureText: true,
                    obscuringCharacter: '●',
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      fieldHeight: 56,
                      fieldWidth: 56,
                      activeFillColor: AppColors.white,
                      inactiveFillColor: AppColors.grey50,
                      selectedFillColor: AppColors.white,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.grey200,
                      selectedColor: AppColors.primary,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {
                      setState(() {
                        _confirmPin = value;
                        _isConfirmPinComplete = value.length == 4;
                        _errorMessage = null;
                      });
                    },
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppConstants.spacingMd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.spacingXs),
                        Text(
                          _errorMessage!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppConstants.spacingXl),

                  // Info box
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
                          Icons.tips_and_updates_outlined,
                          color: AppColors.info,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.spacingSm),
                        Expanded(
                          child: Text(
                            'Usa un PIN que recuerdes fácilmente pero que otros no puedan adivinar. Evita secuencias obvias como 1234 o 0000.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // Botón completar
                  CustomButton(
                    text: 'Completar registro',
                    onPressed: _isPinComplete && _isConfirmPinComplete
                        ? _completeRegistration
                        : null,
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
            message: 'Creando tu cuenta...',
            child: Container(),
          ),
      ],
    );
  }
}
