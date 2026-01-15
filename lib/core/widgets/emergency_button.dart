import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Botón de emergencia destacado y accesible
class EmergencyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final double size;
  final bool showPulse;
  final bool showLabel;

  const EmergencyButton({
    super.key,
    this.onPressed,
    this.size = 70,
    this.showPulse = true,
    this.showLabel = true,
  });

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.showPulse) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    HapticFeedback.heavyImpact();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size + 30,
          height: widget.size + 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse animation
              if (widget.showPulse)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: widget.size * _scaleAnimation.value,
                      height: widget.size * _scaleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.emergency.withValues(alpha: _opacityAnimation.value),
                      ),
                    );
                  },
                ),
              // Main button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handlePress,
                  borderRadius: BorderRadius.circular(widget.size),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.emergencyGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emergency.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emergency,
                      size: widget.size * 0.45,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 8),
          Text(
            'Emergencia',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.emergency,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
