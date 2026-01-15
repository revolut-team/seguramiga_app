import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../widgets/phone_input_field.dart';

/// Pantalla de inicio de sesión con número de teléfono
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simular verificación
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.go('/pin');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacingXl),

                // Logo y título
                _buildHeader(),

                const SizedBox(height: AppConstants.spacingXxl),

                // Título de bienvenida
                Text(
                  'Bienvenido',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  'Ingresa tu número de teléfono para continuar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Campo de teléfono
                PhoneInputField(
                  controller: _phoneController,
                  onChanged: (value) => setState(() {}),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Botón continuar
                CustomButton(
                  text: 'Continuar',
                  onPressed: _phoneController.text.length >= 13
                      ? _handleContinue
                      : null,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Link de registro
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.push('/register/personal');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tienes cuenta? ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Regístrate',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Términos y condiciones
                _buildTermsText(),

                const SizedBox(height: AppConstants.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
        child: SvgPicture.asset(
          'assets/images/logo_horizontal_clean.svg',
          width: 260,
          height: 80,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.caption,
          children: [
            const TextSpan(text: 'Al continuar, aceptas nuestros '),
            TextSpan(
              text: 'Términos de Servicio',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' y '),
            TextSpan(
              text: 'Política de Privacidad',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
