import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Campo de selección de fecha con validación de edad mínima
class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;
  final String hintText;
  final int minimumAge;

  const DatePickerField({
    super.key,
    this.initialDate,
    required this.onChanged,
    this.validator,
    this.hintText = 'Seleccionar fecha',
    this.minimumAge = 18,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _selectedDate ??
        DateTime(now.year - widget.minimumAge, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - widget.minimumAge, now.month, now.day),
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: _selectedDate != null
                  ? AppColors.primary
                  : AppColors.textTertiary,
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Text(
                _selectedDate != null
                    ? dateFormatter.format(_selectedDate!)
                    : widget.hintText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _selectedDate != null
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

/// FormField wrapper para DatePickerField
class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
    super.key,
    DateTime? initialValue,
    required Function(DateTime?) onChanged,
    String? Function(DateTime?)? validator,
    String hintText = 'Seleccionar fecha',
    int minimumAge = 18,
  }) : super(
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<DateTime> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DatePickerField(
                  initialDate: state.value,
                  onChanged: (date) {
                    state.didChange(date);
                    onChanged(date);
                  },
                  hintText: hintText,
                  minimumAge: minimumAge,
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppConstants.spacingXxs,
                      left: AppConstants.spacingSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 14,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            state.errorText!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
}
