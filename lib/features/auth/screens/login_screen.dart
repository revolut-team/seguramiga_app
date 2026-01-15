import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingXxl),

                // Logo y título
                _buildHeader(),

                const SizedBox(height: AppConstants.spacingXxl),

                // Título de bienvenida
                Text(
                  'Bienvenido',
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  'Ingresa tu número de teléfono para continuar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
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

                const SizedBox(height: AppConstants.spacingLg),

                // Términos y condiciones
                _buildTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Image.asset(
        'assets/images/seguramiga_logo.jpeg',
        width: 250,
        fit: BoxFit.contain,
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
