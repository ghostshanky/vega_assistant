import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

enum VegaStatus { online, listening, processing, offline }

class VegaStatusIndicator extends StatefulWidget {
  final VegaStatus status;
  final String statusText;

  const VegaStatusIndicator({
    Key? key,
    required this.status,
    this.statusText = "",
  }) : super(key: key);

  @override
  State<VegaStatusIndicator> createState() => _VegaStatusIndicatorState();
}

class _VegaStatusIndicatorState extends State<VegaStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _updateAnimation();
  }

  @override
  void didUpdateWidget(VegaStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    switch (widget.status) {
      case VegaStatus.listening:
      case VegaStatus.processing:
        _animationController.repeat(reverse: true);
        break;
      case VegaStatus.online:
      case VegaStatus.offline:
        _animationController.stop();
        _animationController.reset();
        break;
    }
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case VegaStatus.online:
        return AppTheme.success;
      case VegaStatus.listening:
        return AppTheme.accent;
      case VegaStatus.processing:
        return AppTheme.warning;
      case VegaStatus.offline:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusText() {
    if (widget.statusText.isNotEmpty) {
      return widget.statusText;
    }

    switch (widget.status) {
      case VegaStatus.online:
        return "VEGA Online";
      case VegaStatus.listening:
        return "Listening...";
      case VegaStatus.processing:
        return "Processing...";
      case VegaStatus.offline:
        return "VEGA Offline";
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowDark,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: widget.status == VegaStatus.listening ||
                        widget.status == VegaStatus.processing
                    ? _pulseAnimation.value
                    : 1.0,
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor().withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                _getStatusText(),
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
