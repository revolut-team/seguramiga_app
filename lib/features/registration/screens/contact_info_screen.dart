import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/registration_data_model.dart';
import '../../../features/auth/widgets/phone_input_field.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/form_field_wrapper.dart';

/// Pantalla de información de contacto (Paso 2/4)
class ContactInfoScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const ContactInfoScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-llenar si ya existen datos
    if (widget.registrationData.phone != null) {
      _phoneController.text = widget.registrationData.phone!;
    }
    if (widget.registrationData.email != null) {
      _emailController.text = widget.registrationData.email!;
      _emailConfirmController.text = widget.registrationData.email!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _emailConfirmController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final updatedData = widget.registrationData.copyWith(
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
      );

      context.push('/register/address', extra: updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              currentStep: 2,
              totalSteps: 4,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información de contacto',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Ingresa tu teléfono y correo electrónico',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Teléfono
                FormFieldWrapper(
                  label: 'Número de teléfono',
                  isRequired: true,
                  child: PhoneInputField(
                    controller: _phoneController,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Email
                FormFieldWrapper(
                  label: 'Correo electrónico',
                  isRequired: true,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'correo@ejemplo.com',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El correo electrónico es requerido';
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Confirmar email
                FormFieldWrapper(
                  label: 'Confirmar correo electrónico',
                  isRequired: true,
                  child: TextFormField(
                    controller: _emailConfirmController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Confirma tu correo',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Debes confirmar tu correo electrónico';
                      }
                      if (value.trim().toLowerCase() !=
                          _emailController.text.trim().toLowerCase()) {
                        return 'Los correos electrónicos no coinciden';
                      }
                      return null;
                    },
                  ),
                ),
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
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Expanded(
                        child: Text(
                          'Usaremos estos datos para enviarte notificaciones importantes sobre tu plan de seguro.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Botón continuar
                CustomButton(
                  text: 'Continuar',
                  onPressed: _continue,
                  isFullWidth: true,
                ),
                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
