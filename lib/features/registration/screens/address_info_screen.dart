import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/venezuela_data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/registration_data_model.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/form_field_wrapper.dart';

/// Pantalla de información de dirección (Paso 3/4)
class AddressInfoScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const AddressInfoScreen({
    super.key,
    required this.registrationData,
  });

  @override
  State<AddressInfoScreen> createState() => _AddressInfoScreenState();
}

class _AddressInfoScreenState extends State<AddressInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String? _selectedState;

  @override
  void initState() {
    super.initState();
    // Pre-llenar si ya existen datos
    _selectedState = widget.registrationData.state;
    if (widget.registrationData.city != null) {
      _cityController.text = widget.registrationData.city!;
    }
    if (widget.registrationData.address != null) {
      _addressController.text = widget.registrationData.address!;
    }
    if (widget.registrationData.zipCode != null) {
      _zipCodeController.text = widget.registrationData.zipCode!;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final updatedData = widget.registrationData.copyWith(
        state: _selectedState,
        city: _cityController.text.trim(),
        address: _addressController.text.trim(),
        zipCode: _zipCodeController.text.trim().isNotEmpty
            ? _zipCodeController.text.trim()
            : null,
      );

      context.push('/register/pin-setup', extra: updatedData);
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
              currentStep: 3,
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
                  'Dirección',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Ingresa tu dirección de residencia',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Estado
                FormFieldWrapper(
                  label: 'Estado',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Selecciona tu estado',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    items: VenezuelaStates.states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El estado es requerido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Ciudad/Municipio
                FormFieldWrapper(
                  label: 'Ciudad o Municipio',
                  isRequired: true,
                  child: TextFormField(
                    controller: _cityController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Ej: Valencia',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La ciudad es requerida';
                      }
                      if (value.trim().length < 2) {
                        return 'La ciudad debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Dirección completa
                FormFieldWrapper(
                  label: 'Dirección completa',
                  isRequired: true,
                  helperText: 'Calle, avenida, edificio, piso, apartamento',
                  child: TextFormField(
                    controller: _addressController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ej: Av. Bolívar, Edif. Torre, Piso 5, Apto 5B',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La dirección es requerida';
                      }
                      if (value.trim().length < 10) {
                        return 'La dirección debe ser más específica';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Código postal (opcional)
                FormFieldWrapper(
                  label: 'Código postal',
                  helperText: 'Opcional',
                  child: TextFormField(
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Ej: 2001',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(Icons.pin_outlined),
                    ),
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
