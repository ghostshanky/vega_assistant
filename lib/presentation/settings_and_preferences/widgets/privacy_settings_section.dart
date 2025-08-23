import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsSection extends StatelessWidget {
  final bool conversationHistory;
  final bool memoryAutoSave;
  final Function(bool) onConversationHistoryChanged;
  final Function(bool) onMemoryAutoSaveChanged;
  final VoidCallback onExportData;

  const PrivacySettingsSection({
    super.key,
    required this.conversationHistory,
    required this.memoryAutoSave,
    required this.onConversationHistoryChanged,
    required this.onMemoryAutoSaveChanged,
    required this.onExportData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.subtleElevation,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Data',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSwitchTile(
            title: 'Conversation History',
            subtitle: 'Save chat conversations locally',
            value: conversationHistory,
            onChanged: onConversationHistoryChanged,
            icon: 'history',
          ),
          SizedBox(height: 1.h),
          _buildSwitchTile(
            title: 'Memory Auto-Save',
            subtitle: 'Automatically save important information',
            value: memoryAutoSave,
            onChanged: onMemoryAutoSaveChanged,
            icon: 'memory',
          ),
          SizedBox(height: 2.h),
          _buildExportButton(),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.accent,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accent,
            activeTrackColor: AppTheme.accent.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.border,
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onExportData,
        icon: CustomIconWidget(
          iconName: 'download',
          color: AppTheme.accent,
          size: 20,
        ),
        label: Text(
          'Export Data',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.accent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.accent, width: 1),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
