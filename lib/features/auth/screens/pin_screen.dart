import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';

/// Pantalla de ingreso de PIN con opción de biometría
class PinScreen extends StatefulWidget {
  final bool isSetup;

  const PinScreen({
    super.key,
    this.isSetup = false,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isLoading = false;
  bool _canUseBiometrics = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // _pinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      setState(() {
        _canUseBiometrics = canAuthenticate && isDeviceSupported;
      });

      // Auto-trigger biometrics if available and not in setup mode
      if (_canUseBiometrics && !widget.isSetup) {
        _authenticateWithBiometrics();
      }
    } catch (e) {
      setState(() => _canUseBiometrics = false);
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Usa tu huella o Face ID para ingresar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
        _navigateToHome();
      }
    } catch (e) {
      // Usuario canceló o error
    }
  }

  void _validatePin(String pin) {
    if (pin.length == AppConstants.pinLength) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Simular validación
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && !_isDisposed) {
          // Demo: PIN válido es 1234
          if (pin == '1234' || widget.isSetup) {
            _navigateToHome();
          } else {
            HapticFeedback.heavyImpact();
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = 'PIN incorrecto. Intenta de nuevo.';
              _pinController.clear();
            });
          }
        }
      });
    }
  }

  void _navigateToHome() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppConstants.spacingXl),

                      // Icono
                      _buildLockIcon(),

                      const SizedBox(height: AppConstants.spacingLg),

                      // Título
                      Text(
                        widget.isSetup ? 'Crea tu PIN' : 'Ingresa tu PIN',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppConstants.spacingXs),
                      Text(
                        widget.isSetup
                            ? 'Crea un PIN de ${AppConstants.pinLength} dígitos para proteger tu cuenta'
                            : 'Ingresa tu PIN de ${AppConstants.pinLength} dígitos',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppConstants.spacingXl),

                      // Campo PIN
                      _buildPinField(),

                      if (_hasError) ...[
                        const SizedBox(height: AppConstants.spacingMd),
                        Text(
                          _errorMessage,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppConstants.spacingLg),

                      // Botón de biometría
                      if (_canUseBiometrics && !widget.isSetup) _buildBiometricButton(),

                      const SizedBox(height: AppConstants.spacingXl * 2),

                      // Olvidé mi PIN
                      if (!widget.isSetup)
                        TextButton(
                          onPressed: () {
                            context.push('/recover-pin');
                          },
                          child: Text(
                            '¿Olvidaste tu PIN?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: AppConstants.spacingMd),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLockIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _hasError ? Icons.lock_outline : Icons.lock_open_outlined,
        size: 40,
        color: _hasError ? AppColors.error : AppColors.primary,
      ),
    );
  }

  Widget _buildPinField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXl),
      child: PinCodeTextField(
        appContext: context,
        length: AppConstants.pinLength,
        controller: _pinController,
        obscureText: true,
        obscuringCharacter: '●',
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        enabled: !_isLoading,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          fieldHeight: 56,
          fieldWidth: 56,
          activeFillColor: AppColors.white,
          inactiveFillColor: AppColors.grey50,
          selectedFillColor: AppColors.white,
          activeColor: _hasError ? AppColors.error : AppColors.primary,
          inactiveColor: AppColors.grey200,
          selectedColor: AppColors.primary,
          errorBorderColor: AppColors.error,
        ),
        animationDuration: AppConstants.animFast,
        enableActiveFill: true,
        onCompleted: _validatePin,
        onChanged: (value) {
          if (_hasError && !_isDisposed) {
            setState(() => _hasError = false);
          }
        },
      ),
    );
  }

  Widget _buildBiometricButton() {
    return GestureDetector(
      onTap: _authenticateWithBiometrics,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fingerprint,
              size: 32,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            'Usar biometría',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
