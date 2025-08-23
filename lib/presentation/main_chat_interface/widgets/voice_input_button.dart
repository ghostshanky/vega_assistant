import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

enum VoiceButtonState { ready, recording, processing }

class VoiceInputButton extends StatefulWidget {
  final VoiceButtonState state;
  final VoidCallback? onTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final bool showWaveform;

  const VoiceInputButton({
    Key? key,
    required this.state,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.showWaveform = false,
  }) : super(key: key);

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceInputButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      _updateAnimations();
    }
    if (widget.showWaveform != oldWidget.showWaveform) {
      if (widget.showWaveform) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
      }
    }
  }

  void _updateAnimations() {
    switch (widget.state) {
      case VoiceButtonState.recording:
        _pulseController.repeat(reverse: true);
        if (widget.showWaveform) {
          _waveController.repeat(reverse: true);
        }
        break;
      case VoiceButtonState.processing:
        _pulseController.repeat(reverse: true);
        _waveController.stop();
        break;
      case VoiceButtonState.ready:
        _pulseController.stop();
        _waveController.stop();
        break;
    }
  }

  Color _getButtonColor() {
    switch (widget.state) {
      case VoiceButtonState.ready:
        return AppTheme.accent;
      case VoiceButtonState.recording:
        return AppTheme.error;
      case VoiceButtonState.processing:
        return AppTheme.warning;
    }
  }

  String _getIconName() {
    switch (widget.state) {
      case VoiceButtonState.ready:
        return 'mic';
      case VoiceButtonState.recording:
        return 'stop';
      case VoiceButtonState.processing:
        return 'hourglass_empty';
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _handleLongPressStart() {
    HapticFeedback.mediumImpact();
    widget.onLongPressStart?.call();
  }

  void _handleLongPressEnd() {
    HapticFeedback.lightImpact();
    widget.onLongPressEnd?.call();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _waveAnimation]),
      builder: (context, child) {
        return Container(
          width: 20.w,
          height: 20.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Waveform rings
              if (widget.showWaveform) ...[
                ...List.generate(3, (index) {
                  final delay = index * 0.3;
                  final animValue = (_waveAnimation.value + delay) % 1.0;
                  return Container(
                    width: 20.w * (1.0 + animValue * 0.5),
                    height: 20.w * (1.0 + animValue * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getButtonColor().withValues(
                          alpha: 0.3 * (1.0 - animValue),
                        ),
                        width: 2,
                      ),
                    ),
                  );
                }),
              ],
              // Main button
              Transform.scale(
                scale: widget.state == VoiceButtonState.recording
                    ? _pulseAnimation.value
                    : 1.0,
                child: GestureDetector(
                  onTap: _handleTap,
                  onLongPressStart: (_) => _handleLongPressStart(),
                  onLongPressEnd: (_) => _handleLongPressEnd(),
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getButtonColor(),
                      boxShadow: [
                        BoxShadow(
                          color: _getButtonColor().withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getIconName(),
                        color: AppTheme.textPrimary,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
