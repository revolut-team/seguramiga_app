import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../widgets/phone_input_field.dart';

/// Pantalla de recuperación de PIN
class RecoverPinScreen extends StatefulWidget {
  const RecoverPinScreen({super.key});

  @override
  State<RecoverPinScreen> createState() => _RecoverPinScreenState();
}

class _RecoverPinScreenState extends State<RecoverPinScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _codeSent = false;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _codeSent = true;
          });
        }
      });
    }
  }

  void _verifyCode() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/pin');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Recuperar PIN',
          style: AppTextStyles.h5,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingLg),

                // Ilustración
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sms_outlined,
                      size: 50,
                      color: AppColors.secondary,
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Instrucciones
                Text(
                  _codeSent ? 'Ingresa el código' : 'Verifica tu número',
                  style: AppTextStyles.h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  _codeSent
                      ? 'Hemos enviado un código de verificación a tu número de teléfono'
                      : 'Ingresa tu número de teléfono registrado para recibir un código de verificación',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                if (!_codeSent) ...[
                  // Campo de teléfono
                  PhoneInputField(
                    controller: _phoneController,
                    onChanged: (value) => setState(() {}),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  CustomButton(
                    text: 'Enviar código',
                    onPressed: _phoneController.text.length >= 10
                        ? _sendCode
                        : null,
                    isLoading: _isLoading,
                  ),
                ] else ...[
                  // Campo de código
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h4,
                    decoration: InputDecoration(
                      hintText: '000000',
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  CustomButton(
                    text: 'Verificar código',
                    onPressed: _codeController.text.length == 6
                        ? _verifyCode
                        : null,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Reenviar código
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _codeSent = false;
                          _codeController.clear();
                        });
                      },
                      child: Text(
                        'Reenviar código',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
