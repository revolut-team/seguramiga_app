import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/venezuela_data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/registration_data_model.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/form_field_wrapper.dart';
import '../widgets/document_input_field.dart';
import '../widgets/date_picker_field.dart';

/// Pantalla de información personal (Paso 1/4)
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String _documentType = 'V';
  String _documentId = '';
  DateTime? _birthDate;
  String? _gender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final registrationData = RegistrationData(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        documentType: _documentType,
        documentId: _documentId,
        birthDate: _birthDate,
        gender: _gender,
      );

      context.push('/register/contact', extra: registrationData);
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
              currentStep: 1,
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
                  'Datos personales',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Ingresa tu información personal para comenzar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Primer nombre
                FormFieldWrapper(
                  label: 'Primer nombre',
                  isRequired: true,
                  child: TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Ej: Juan',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El primer nombre es requerido';
                      }
                      if (value.trim().length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
                        return 'Solo se permiten letras';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Apellido
                FormFieldWrapper(
                  label: 'Apellido',
                  isRequired: true,
                  child: TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Ej: Pérez',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El apellido es requerido';
                      }
                      if (value.trim().length < 2) {
                        return 'El apellido debe tener al menos 2 caracteres';
                      }
                      if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
                        return 'Solo se permiten letras';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Documento de identidad
                FormFieldWrapper(
                  label: 'Documento de identidad',
                  isRequired: true,
                  child: DocumentInputField(
                    initialDocumentType: _documentType,
                    initialDocumentId: _documentId,
                    onChanged: (type, id) {
                      setState(() {
                        _documentType = type;
                        _documentId = id;
                      });
                    },
                    validator: (value) {
                      if (_documentId.isEmpty) {
                        return 'El número de documento es requerido';
                      }
                      if (_documentType == 'V' || _documentType == 'E') {
                        if (_documentId.length < 7 || _documentId.length > 9) {
                          return 'Debe tener entre 7 y 9 dígitos';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Fecha de nacimiento
                FormFieldWrapper(
                  label: 'Fecha de nacimiento',
                  isRequired: true,
                  child: DatePickerFormField(
                    initialValue: _birthDate,
                    onChanged: (date) {
                      setState(() {
                        _birthDate = date;
                      });
                    },
                    hintText: 'Selecciona tu fecha de nacimiento',
                    minimumAge: 18,
                    validator: (value) {
                      if (value == null) {
                        return 'La fecha de nacimiento es requerida';
                      }
                      final age = DateTime.now().difference(value).inDays ~/ 365;
                      if (age < 18) {
                        return 'Debes ser mayor de 18 años';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Género
                FormFieldWrapper(
                  label: 'Género',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Selecciona tu género',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    items: GenderOptions.genders.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El género es requerido';
                      }
                      return null;
                    },
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
