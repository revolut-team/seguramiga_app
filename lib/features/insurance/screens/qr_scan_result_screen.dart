import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_insurance_model.dart';
import '../../../shared/services/qr_service.dart';

/// Pantalla que muestra la información del titular después de escanear el QR
///
/// Esta pantalla es utilizada por proveedores (clínicas, farmacias) para
/// ver los datos del asegurado después de escanear su código QR.
class QRScanResultScreen extends StatefulWidget {
  final String qrData;

  const QRScanResultScreen({
    super.key,
    required this.qrData,
  });

  @override
  State<QRScanResultScreen> createState() => _QRScanResultScreenState();
}

class _QRScanResultScreenState extends State<QRScanResultScreen> {
  UserInsuranceModel? _user;
  bool _isValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _decodeQRData();
  }

  void _decodeQRData() {
    // Validar los datos del QR con mensaje detallado
    final validationResult = QRService.validateQRDataWithMessage(widget.qrData);

    if (validationResult.isValid) {
      _user = QRService.decodeQRData(widget.qrData);
      if (_user != null) {
        _isValid = true;
      } else {
        _isValid = false;
        _errorMessage = 'No se pudo decodificar la información del asegurado';
      }
    } else {
      _isValid = false;
      _errorMessage = validationResult.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Información del Asegurado',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: _isValid && _user != null
          ? _buildValidContent()
          : _buildErrorContent(),
    );
  }

  Widget _buildValidContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Header con estado
          _buildStatusHeader()
              .animate()
              .fadeIn(duration: 300.ms),

          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              children: [
                // Información del titular
                _buildUserInfoCard()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Información del plan
                _buildPlanInfoCard()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Información médica importante
                if (_user!.bloodType != null ||
                    (_user!.allergies != null && _user!.allergies!.isNotEmpty))
                  _buildMedicalInfoCard()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Contacto de emergencia
                if (_user!.emergencyContact != null)
                  _buildEmergencyContactCard()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingXl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    final isActive = _user!.isActive;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [AppColors.success, Color(0xFF38A169)],
              )
            : const LinearGradient(
                colors: [AppColors.error, Color(0xFFE53E3E)],
              ),
      ),
      child: Column(
        children: [
          Icon(
            isActive ? Icons.verified : Icons.warning_rounded,
            color: AppColors.white,
            size: 48,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            isActive ? 'SEGURO ACTIVO' : 'SEGURO VENCIDO',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXxs),
          Text(
            isActive
                ? 'Vigente hasta: ${_formatDate(_user!.expirationDate)}'
                : 'Venció el: ${_formatDate(_user!.expirationDate)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingXs),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Información del Titular',
                style: AppTextStyles.h6.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow('Nombre Completo', _user!.fullName, isHighlighted: true),
          _buildInfoRow(_user!.documentType, _user!.documentId),
          _buildInfoRow('Teléfono', _user!.phone),
          _buildInfoRow('Email', _user!.email),
          _buildInfoRow('ID de Miembro', _user!.memberId, isCode: true),
        ],
      ),
    );
  }

  Widget _buildPlanInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingXs),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: AppColors.secondary,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Información del Plan',
                style: AppTextStyles.h6.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow('Plan', _user!.planName, isHighlighted: true),
          _buildInfoRow('Tipo', _user!.planType),
          _buildInfoRow('No. de Póliza', _user!.policyNumber, isCode: true),
          _buildInfoRow('Vigencia', _formatDate(_user!.expirationDate)),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingXs),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.medical_information,
                  color: AppColors.warning,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Información Médica Importante',
                style: AppTextStyles.h6.copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          if (_user!.bloodType != null)
            _buildInfoRow('Tipo de Sangre', _user!.bloodType!, isHighlighted: true),
          if (_user!.allergies != null && _user!.allergies!.isNotEmpty)
            _buildAllergyRow(),
        ],
      ),
    );
  }

  Widget _buildAllergyRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber,
                color: AppColors.error,
                size: 18,
              ),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                'ALERGIAS',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Wrap(
            spacing: AppConstants.spacingXs,
            runSpacing: AppConstants.spacingXs,
            children: _user!.allergies!.map((allergy) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSm,
                  vertical: AppConstants.spacingXxs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  allergy,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.emergency.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingXs),
                decoration: BoxDecoration(
                  color: AppColors.emergency.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.emergency,
                  color: AppColors.emergency,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Contacto de Emergencia',
                style: AppTextStyles.h6.copyWith(color: AppColors.emergency),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow('Nombre', _user!.emergencyContact!),
          if (_user!.emergencyPhone != null)
            _buildInfoRow('Teléfono', _user!.emergencyPhone!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false, bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: isHighlighted
                  ? AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )
                  : isCode
                      ? AppTextStyles.bodyMedium.copyWith(
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        )
                      : AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 50,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'Código QR Inválido',
              style: AppTextStyles.h4.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              _errorMessage ?? 'No se pudo leer la información del código QR',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear otro código'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLg,
                  vertical: AppConstants.spacingMd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} ${date.year}';
  }
}
