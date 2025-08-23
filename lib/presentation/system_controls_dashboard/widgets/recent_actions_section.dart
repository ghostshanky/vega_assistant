import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentActions;
  final Function(String) onUndoAction;

  const RecentActionsSection({
    Key? key,
    required this.recentActions,
    required this.onUndoAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentActions.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Actions',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentActions.length > 5 ? 5 : recentActions.length,
              separatorBuilder: (context, index) => Divider(
                color: AppTheme.border,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final action = recentActions[index];
                final actionType = action['type'] as String;
                final timestamp = action['timestamp'] as DateTime;
                final canUndo = action['canUndo'] as bool? ?? false;
                final actionId = action['id'] as String;

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getActionColor(actionType).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _getActionIcon(actionType),
                      color: _getActionColor(actionType),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    _getActionTitle(action),
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  trailing: canUndo
                      ? TextButton(
                          onPressed: () => onUndoAction(actionId),
                          child: Text(
                            'Undo',
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getActionIcon(String actionType) {
    switch (actionType) {
      case 'wifi':
        return 'wifi';
      case 'bluetooth':
        return 'bluetooth';
      case 'hotspot':
        return 'wifi_tethering';
      case 'dnd':
        return 'do_not_disturb';
      case 'airplane':
        return 'airplanemode_active';
      default:
        return 'settings';
    }
  }

  Color _getActionColor(String actionType) {
    switch (actionType) {
      case 'wifi':
        return AppTheme.accent;
      case 'bluetooth':
        return Colors.blue;
      case 'hotspot':
        return Colors.orange;
      case 'dnd':
        return Colors.purple;
      case 'airplane':
        return Colors.red;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getActionTitle(Map<String, dynamic> action) {
    final type = action['type'] as String;
    final isEnabled = action['enabled'] as bool;
    final details = action['details'] as String? ?? '';

    switch (type) {
      case 'wifi':
        return isEnabled
            ? 'WiFi enabled${details.isNotEmpty ? ' - $details' : ''}'
            : 'WiFi disabled';
      case 'bluetooth':
        return isEnabled
            ? 'Bluetooth enabled${details.isNotEmpty ? ' - $details' : ''}'
            : 'Bluetooth disabled';
      case 'hotspot':
        return isEnabled ? 'Mobile Hotspot enabled' : 'Mobile Hotspot disabled';
      case 'dnd':
        return isEnabled ? 'Do Not Disturb enabled' : 'Do Not Disturb disabled';
      case 'airplane':
        return isEnabled ? 'Airplane Mode enabled' : 'Airplane Mode disabled';
      default:
        return 'System setting changed';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
