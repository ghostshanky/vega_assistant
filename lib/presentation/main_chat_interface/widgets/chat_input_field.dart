import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;
  final bool enabled;
  final String hintText;

  const ChatInputField({
    Key? key,
    required this.controller,
    this.onSend,
    this.enabled = true,
    this.hintText = "Type a message...",
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleSend() {
    if (_hasText && widget.enabled) {
      widget.onSend?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: _handleSend,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hasText && widget.enabled
                    ? AppTheme.accent
                    : AppTheme.textSecondary.withValues(alpha: 0.3),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'send',
                  color: _hasText && widget.enabled
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
