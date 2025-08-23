import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_memory_bottom_sheet.dart';
import './widgets/category_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/memory_card_widget.dart';
import './widgets/search_bar_widget.dart';

class MemoryManagement extends StatefulWidget {
  const MemoryManagement({Key? key}) : super(key: key);

  @override
  State<MemoryManagement> createState() => _MemoryManagementState();
}

class _MemoryManagementState extends State<MemoryManagement> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isMultiSelectMode = false;
  Set<int> _selectedMemoryIds = {};
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Personal',
    'Preferences',
    'Contacts',
    'Habits',
    'Custom',
  ];

  List<Map<String, dynamic>> _memories = [
    {
      'id': 1,
      'title': 'Favorite Coffee Order',
      'content':
          'I prefer a large cappuccino with oat milk and an extra shot of espresso. I usually order this at Starbucks around 9 AM on weekdays.',
      'category': 'Preferences',
      'created_at': '2025-08-20T09:30:00.000Z',
      'updated_at': '2025-08-20T09:30:00.000Z',
    },
    {
      'id': 2,
      'title': 'Work Schedule',
      'content':
          'I work Monday to Friday from 9 AM to 6 PM. I have lunch break at 1 PM and prefer not to be disturbed during meetings between 2-4 PM.',
      'category': 'Personal',
      'created_at': '2025-08-19T14:15:00.000Z',
      'updated_at': '2025-08-19T14:15:00.000Z',
    },
    {
      'id': 3,
      'title': 'Emergency Contact',
      'content':
          'My emergency contact is Sarah Johnson, my sister. Her phone number is +1-555-0123. She lives in Seattle and should be contacted if anything urgent happens.',
      'category': 'Contacts',
      'created_at': '2025-08-18T16:45:00.000Z',
      'updated_at': '2025-08-18T16:45:00.000Z',
    },
    {
      'id': 4,
      'title': 'Exercise Routine',
      'content':
          'I go to the gym every Tuesday, Thursday, and Saturday at 7 AM. I focus on cardio and strength training. Remind me to bring my water bottle and towel.',
      'category': 'Habits',
      'created_at': '2025-08-17T07:00:00.000Z',
      'updated_at': '2025-08-17T07:00:00.000Z',
    },
    {
      'id': 5,
      'title': 'Dietary Restrictions',
      'content':
          'I am lactose intolerant and prefer plant-based alternatives. I also avoid spicy food and have a nut allergy. Please consider this when suggesting restaurants.',
      'category': 'Personal',
      'created_at': '2025-08-16T12:20:00.000Z',
      'updated_at': '2025-08-16T12:20:00.000Z',
    },
  ];

  List<Map<String, dynamic>> get _filteredMemories {
    var filtered = _memories.where((memory) {
      final matchesSearch = _searchQuery.isEmpty ||
          (memory['title'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (memory['content'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          (memory['category'] as String) == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    // Sort by creation date (newest first)
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['created_at'] as String);
      final dateB = DateTime.parse(b['created_at'] as String);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
      floatingActionButton:
          _isMultiSelectMode ? null : _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _isMultiSelectMode
            ? '${_selectedMemoryIds.length} selected'
            : 'Memory Management',
      ),
      leading: _isMultiSelectMode
          ? IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            )
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
      actions: _isMultiSelectMode
          ? _buildMultiSelectActions()
          : _buildNormalActions(),
      elevation: 0,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
    );
  }

  List<Widget> _buildNormalActions() {
    return [
      IconButton(
        onPressed: _handleRefresh,
        icon: CustomIconWidget(
          iconName: 'refresh',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
    ];
  }

  List<Widget> _buildMultiSelectActions() {
    return [
      IconButton(
        onPressed: _selectedMemoryIds.isNotEmpty ? _handleBatchDelete : null,
        icon: CustomIconWidget(
          iconName: 'delete',
          color: _selectedMemoryIds.isNotEmpty
              ? AppTheme.error
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
      ),
      IconButton(
        onPressed: _selectedMemoryIds.isNotEmpty ? _handleBatchShare : null,
        icon: CustomIconWidget(
          iconName: 'share',
          color: _selectedMemoryIds.isNotEmpty
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 6.w,
        ),
      ),
    ];
  }

  Widget _buildBody() {
    return Column(
      children: [
        SearchBarWidget(
          searchQuery: _searchQuery,
          onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          onVoiceSearch: _handleVoiceSearch,
        ),
        CategoryFilterWidget(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        ),
        Expanded(
          child: _filteredMemories.isEmpty
              ? _buildEmptyState()
              : _buildMemoryList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Syncing memories...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _selectedCategory != 'All') {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'No memories found',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Try adjusting your search or filter',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return EmptyStateWidget(
      onStartConversation: () {
        Navigator.pushNamed(context, '/main-chat-interface');
      },
    );
  }

  Widget _buildMemoryList() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: _filteredMemories.length,
        itemBuilder: (context, index) {
          final memory = _filteredMemories[index];
          final memoryId = memory['id'] as int;
          final isSelected = _selectedMemoryIds.contains(memoryId);

          return MemoryCardWidget(
            memory: memory,
            isSelected: isSelected,
            onTap: () => _handleMemoryTap(memoryId),
            onEdit: () => _handleEditMemory(memory),
            onDelete: () => _handleDeleteMemory(memoryId),
            onShare: () => _handleShareMemory(memory),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _handleAddMemory,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 5.w,
      ),
      label: Text(
        'Add Memory',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleMemoryTap(int memoryId) {
    if (_isMultiSelectMode) {
      setState(() {
        if (_selectedMemoryIds.contains(memoryId)) {
          _selectedMemoryIds.remove(memoryId);
        } else {
          _selectedMemoryIds.add(memoryId);
        }

        if (_selectedMemoryIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      });
    } else {
      setState(() {
        _isMultiSelectMode = true;
        _selectedMemoryIds.add(memoryId);
      });
    }
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedMemoryIds.clear();
    });
  }

  void _handleAddMemory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMemoryBottomSheet(
        onMemoryAdded: (newMemory) {
          setState(() {
            _memories.insert(0, newMemory);
          });
        },
      ),
    );
  }

  void _handleEditMemory(Map<String, dynamic> memory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMemoryBottomSheet(
        onMemoryAdded: (updatedMemory) {
          setState(() {
            final index = _memories.indexWhere((m) => m['id'] == memory['id']);
            if (index != -1) {
              _memories[index] = {
                ...updatedMemory,
                'id': memory['id'],
                'created_at': memory['created_at'],
                'updated_at': DateTime.now().toIso8601String(),
              };
            }
          });
        },
      ),
    );
  }

  void _handleDeleteMemory(int memoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Memory'),
        content: Text(
            'Are you sure you want to delete this memory? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _memories.removeWhere((memory) => memory['id'] == memoryId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Memory deleted successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleShareMemory(Map<String, dynamic> memory) {
    final shareText = '${memory['title']}\n\n${memory['content']}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memory copied to clipboard'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _handleBatchDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selectedMemoryIds.length} Memories'),
        content: Text(
            'Are you sure you want to delete the selected memories? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _memories.removeWhere(
                    (memory) => _selectedMemoryIds.contains(memory['id']));
                _selectedMemoryIds.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Memories deleted successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBatchShare() {
    final selectedMemories = _memories
        .where((memory) => _selectedMemoryIds.contains(memory['id']))
        .toList();
    final shareText = selectedMemories
        .map((memory) => '${memory['title']}\n${memory['content']}')
        .join('\n\n---\n\n');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${_selectedMemoryIds.length} memories copied to clipboard'),
        backgroundColor: AppTheme.success,
      ),
    );

    _exitMultiSelectMode();
  }

  void _handleVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search activated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Memories synced successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}
