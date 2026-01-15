import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_insurance_model.dart';
import '../../../shared/services/qr_service.dart';

/// Pantalla de detalles del seguro con código QR
///
/// Muestra el código QR que contiene toda la información del titular.
/// Los datos personales NO se muestran en pantalla, solo son visibles
/// al escanear el código QR (para mayor privacidad y seguridad).
class InsuranceDetailsScreen extends StatefulWidget {
  final UserInsuranceModel? user;

  const InsuranceDetailsScreen({
    super.key,
    this.user,
  });

  @override
  State<InsuranceDetailsScreen> createState() => _InsuranceDetailsScreenState();
}

class _InsuranceDetailsScreenState extends State<InsuranceDetailsScreen> {
  late final UserInsuranceModel _user;
  late final String _qrData;
  final GlobalKey _qrKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? UserInsuranceModel.mockUser;
    _qrData = QRService.generateSignedQRData(_user);
  }

  Future<void> _shareQR() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      final imageData = await QRService.captureQRAsImage(_qrKey);
      if (imageData != null && mounted) {
        await Share.shareXFiles(
          [
            XFile.fromData(
              imageData,
              name: 'carnet_seguro_${_user.memberId}.png',
              mimeType: 'image/png',
            ),
          ],
          text: 'Mi carnet digital de seguro - ${_user.planName}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al compartir: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mi Carnet Digital',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(Icons.share_outlined),
            onPressed: _isSharing ? null : _shareQR,
            tooltip: 'Compartir QR',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header con gradiente
            _buildHeader(),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                children: [
                  // Tarjeta del QR
                  _buildQRCard()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Instrucciones de uso
                  _buildInstructionsCard()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Información incluida en el QR
                  _buildQRContentInfo()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Nota de seguridad
                  _buildSecurityNote()
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms),

                  const SizedBox(height: AppConstants.spacingXl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingMd,
        0,
        AppConstants.spacingMd,
        AppConstants.spacingLg,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppConstants.radiusXxl),
        ),
      ),
      child: Column(
        children: [
          // Estado del seguro
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingXs,
            ),
            decoration: BoxDecoration(
              color: _user.isActive
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _user.isActive ? Icons.check_circle : Icons.warning,
                  color: _user.isActive ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: AppConstants.spacingXs),
                Text(
                  _user.isActive ? 'Seguro Activo' : 'Seguro Vencido',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            _user.planName,
            style: AppTextStyles.h4.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXxs),
          Text(
            'Vigente hasta: ${_formatDate(_user.expirationDate)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard() {
    return RepaintBoundary(
      key: _qrKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: AppColors.primary,
                  size: AppConstants.iconMd,
                ),
                const SizedBox(width: AppConstants.spacingXs),
                Text(
                  'Código QR de Identificación',
                  style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              'Presenta este código en clínicas y farmacias afiliadas',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // QR Code
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(
                  color: AppColors.grey200,
                  width: 2,
                ),
              ),
              child: QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: AppColors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.primary,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.primaryDark,
                ),
                errorCorrectionLevel: QrErrorCorrectLevel.Q,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // ID del miembro
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: AppColors.textSecondary,
                    size: AppConstants.iconSm,
                  ),
                  const SizedBox(width: AppConstants.spacingXs),
                  Text(
                    'ID: ${_user.memberId}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
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
                  Icons.touch_app_outlined,
                  color: AppColors.secondary,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Cómo usar tu carnet digital',
                style: AppTextStyles.h6,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInstructionStep(
            number: '1',
            text: 'Presenta este código QR al personal de la clínica o farmacia',
          ),
          _buildInstructionStep(
            number: '2',
            text: 'El proveedor escaneará el código con su dispositivo',
          ),
          _buildInstructionStep(
            number: '3',
            text: 'Tu información de seguro se mostrará automáticamente',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep({
    required String number,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRContentInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
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
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: AppColors.accent,
                  size: AppConstants.iconMd,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                'Información en el código QR',
                style: AppTextStyles.h6.copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Al escanear, el proveedor podrá ver:',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingXs,
            runSpacing: AppConstants.spacingXs,
            children: [
              _buildInfoChip(Icons.person, 'Nombre completo'),
              _buildInfoChip(Icons.badge, 'Identificación'),
              _buildInfoChip(Icons.phone, 'Teléfono'),
              _buildInfoChip(Icons.email_outlined, 'Email'),
              _buildInfoChip(Icons.description_outlined, 'Póliza'),
              _buildInfoChip(Icons.workspace_premium, 'Tipo de plan'),
              _buildInfoChip(Icons.calendar_today, 'Vigencia'),
              if (_user.bloodType != null)
                _buildInfoChip(Icons.bloodtype, 'Tipo de sangre'),
              if (_user.allergies != null && _user.allergies!.isNotEmpty)
                _buildInfoChip(Icons.warning_amber, 'Alergias'),
              if (_user.emergencyContact != null)
                _buildInfoChip(Icons.emergency, 'Contacto emergencia'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.security,
            color: AppColors.info,
            size: AppConstants.iconMd,
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              'Tu información personal está protegida. Solo es visible cuando un proveedor autorizado escanea el código QR.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
