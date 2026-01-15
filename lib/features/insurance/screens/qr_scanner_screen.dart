import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Pantalla de escáner de códigos QR
///
/// Permite a los proveedores (clínicas, farmacias) escanear el código QR
/// del carnet digital de los asegurados.
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        setState(() => _isProcessing = true);

        // Navegar a la pantalla de resultado con los datos del QR
        context.push('/qr-result', extra: barcode.rawValue);

        // Resetear el estado después de un momento
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _isProcessing = false);
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Escanear Carnet',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scanner
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay con guías
          _buildScannerOverlay(),

          // Instrucciones
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildInstructions(),
          ),

          // Loading indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scanAreaSize = constraints.maxWidth * 0.7;
        final left = (constraints.maxWidth - scanAreaSize) / 2;
        final top = (constraints.maxHeight - scanAreaSize) / 2 - 50;

        return Stack(
          children: [
            // Fondo oscuro con hueco transparente
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.6),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: scanAreaSize,
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bordes del área de escaneo
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Esquinas destacadas
            ..._buildCorners(left, top, scanAreaSize),
          ],
        );
      },
    );
  }

  List<Widget> _buildCorners(double left, double top, double size) {
    const cornerSize = 30.0;
    const cornerWidth = 4.0;
    final color = AppColors.secondary;

    return [
      // Top-left
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: cornerSize,
          height: cornerWidth,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
            ),
          ),
        ),
      ),
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: cornerWidth,
          height: cornerSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
            ),
          ),
        ),
      ),

      // Top-right
      Positioned(
        left: left + size - cornerSize,
        top: top,
        child: Container(
          width: cornerSize,
          height: cornerWidth,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
            ),
          ),
        ),
      ),
      Positioned(
        left: left + size - cornerWidth,
        top: top,
        child: Container(
          width: cornerWidth,
          height: cornerSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
            ),
          ),
        ),
      ),

      // Bottom-left
      Positioned(
        left: left,
        top: top + size - cornerWidth,
        child: Container(
          width: cornerSize,
          height: cornerWidth,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
      ),
      Positioned(
        left: left,
        top: top + size - cornerSize,
        child: Container(
          width: cornerWidth,
          height: cornerSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
            ),
          ),
        ),
      ),

      // Bottom-right
      Positioned(
        left: left + size - cornerSize,
        top: top + size - cornerWidth,
        child: Container(
          width: cornerSize,
          height: cornerWidth,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
      ),
      Positioned(
        left: left + size - cornerWidth,
        top: top + size - cornerSize,
        child: Container(
          width: cornerWidth,
          height: cornerSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.spacingXs),
                  Text(
                    'Coloca el código QR dentro del recuadro',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'El código se detectará automáticamente',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
