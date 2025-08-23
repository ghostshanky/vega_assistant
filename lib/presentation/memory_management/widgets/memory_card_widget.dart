import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MemoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> memory;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onTap;
  final bool isSelected;

  const MemoryCardWidget({
    Key? key,
    required this.memory,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = memory['category'] as String? ?? 'Custom';
    final title = memory['title'] as String? ?? 'Untitled Memory';
    final content = memory['content'] as String? ?? '';
    final createdAt = memory['created_at'] as String? ?? '';
    final preview =
        content.length > 100 ? '${content.substring(0, 100)}...' : content;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Dismissible(
        key: Key('memory_${memory['id']}'),
        background: _buildSwipeBackground(isLeft: false),
        secondaryBackground: _buildSwipeBackground(isLeft: true),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onEdit?.call();
          } else if (direction == DismissDirection.endToStart) {
            onShare?.call();
          }
        },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () {
            // Trigger multi-select mode
            onTap?.call();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary, width: 2)
                  : null,
              boxShadow: AppTheme.subtleElevation,
            ),
            child: ExpansionTile(
              leading: _buildCategoryIcon(category),
              title: Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.5.h),
                  Text(
                    preview,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatDate(createdAt),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: 'edit',
                            label: 'Edit',
                            onPressed: onEdit,
                          ),
                          _buildActionButton(
                            icon: 'share',
                            label: 'Share',
                            onPressed: onShare,
                          ),
                          _buildActionButton(
                            icon: 'delete',
                            label: 'Delete',
                            onPressed: onDelete,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color:
            isLeft ? AppTheme.lightTheme.colorScheme.primary : AppTheme.success,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'share' : 'edit',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Share' : 'Edit',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String category) {
    String iconName;
    Color iconColor;

    switch (category.toLowerCase()) {
      case 'personal':
        iconName = 'person';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'preferences':
        iconName = 'settings';
        iconColor = AppTheme.success;
        break;
      case 'contacts':
        iconName = 'contacts';
        iconColor = AppTheme.warning;
        break;
      case 'habits':
        iconName = 'schedule';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      default:
        iconName = 'memory';
        iconColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 5.w,
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    VoidCallback? onPressed,
    bool isDestructive = false,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        size: 4.w,
      ),
      label: Text(
        label,
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: isDestructive
              ? AppTheme.error
              : AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Unknown date';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }
}
