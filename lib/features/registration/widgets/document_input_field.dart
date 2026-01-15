import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/venezuela_data.dart';

/// Campo de entrada para documento de identidad venezolano
class DocumentInputField extends StatefulWidget {
  final String? initialDocumentType;
  final String? initialDocumentId;
  final Function(String type, String id) onChanged;
  final String? Function(String?)? validator;

  const DocumentInputField({
    super.key,
    this.initialDocumentType,
    this.initialDocumentId,
    required this.onChanged,
    this.validator,
  });

  @override
  State<DocumentInputField> createState() => _DocumentInputFieldState();
}

class _DocumentInputFieldState extends State<DocumentInputField> {
  late String _selectedType;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialDocumentType ?? 'V';
    _idController = TextEditingController(text: widget.initialDocumentId);
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(_selectedType, _idController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown de tipo de documento
        Container(
          width: 65,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXs),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.grey200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              items: DocumentTypes.types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                  _notifyChange();
                }
              },
            ),
          ),
        ),

        const SizedBox(width: AppConstants.spacingSm),

        // Input de número de documento
        Expanded(
          child: TextFormField(
            controller: _idController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: InputDecoration(
              hintText: 'Número de documento',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.grey50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.grey200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.grey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
            ),
            validator: widget.validator,
            onChanged: (value) => _notifyChange(),
          ),
        ),
      ],
    );
  }
}
