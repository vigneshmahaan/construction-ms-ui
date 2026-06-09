import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../widgets/add_setting_item_bottom_sheet.dart';

class SettingItem {
  final String id;
  String name;
  Color color;
  IconData? icon;
  String? indicator;
  bool isIcon;

  SettingItem({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    this.indicator,
    this.isIcon = false,
  });
}

class CrmSettingsPage extends StatefulWidget {
  const CrmSettingsPage({super.key});

  @override
  State<CrmSettingsPage> createState() => _CrmSettingsPageState();
}

class _CrmSettingsPageState extends State<CrmSettingsPage> {
  final List<SettingItem> _pipelines = [
    SettingItem(id: 'p1', name: 'Sales Pipeline', icon: Icons.show_chart, color: const Color(0xFFF59E0B)),
  ];

  final List<SettingItem> _stages = [
    SettingItem(id: 's1', name: 'Initial Call', color: const Color(0xFF8B5CF6)),
    SettingItem(id: 's2', name: 'Site Visit', color: const Color(0xFF3B82F6)),
    SettingItem(id: 's3', name: 'Advance Paid', color: const Color(0xFF10B981)),
    SettingItem(id: 's4', name: 'Deal Closed', color: const Color(0xFFF59E0B)),
  ];

  final List<SettingItem> _sources = [
    SettingItem(id: 'src1', name: 'Facebook', indicator: 'f', color: const Color(0xFF3B82F6)),
    SettingItem(id: 'src2', name: 'JustDial', indicator: 'J', color: const Color(0xFFEF4444)),
    SettingItem(id: 'src3', name: 'Referral', indicator: '★', color: const Color(0xFFF59E0B), isIcon: true),
  ];

  Future<void> _showAddOrEditSettingItemSheet({
    required String title,
    required List<SettingItem> list,
    SettingItem? existingItem,
    IconData? defaultIcon,
    String? defaultIndicator,
  }) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddSettingItemBottomSheet(
          title: title,
          initialName: existingItem?.name,
          initialColor: existingItem?.color,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (existingItem != null) {
          // Edit
          existingItem.name = result['name'];
          existingItem.color = result['color'];
        } else {
          // Add
          list.add(SettingItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: result['name'],
            color: result['color'],
            icon: defaultIcon,
            indicator: defaultIndicator ?? result['name'].substring(0, 1).toUpperCase(),
          ));
        }
      });
    }
  }

  void _deleteItem(List<SettingItem> list, SettingItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                list.removeWhere((element) => element.id == item.id);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'CRM Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Pipelines', 'Add Pipeline', () {
              _showAddOrEditSettingItemSheet(
                title: 'Add Pipeline',
                list: _pipelines,
                defaultIcon: Icons.show_chart,
              );
            }),
            const SizedBox(height: 12),
            ..._pipelines.map((item) => _buildPipelineItem(item)),
            const SizedBox(height: 24),

            _buildSectionHeader('Stages', 'Add Stage', () {
              _showAddOrEditSettingItemSheet(
                title: 'Add Stage',
                list: _stages,
              );
            }),
            const SizedBox(height: 12),
            ..._stages.map((item) => _buildStageItem(item)),
            const SizedBox(height: 24),

            _buildSectionHeader('Sources', 'Add Source', () {
              _showAddOrEditSettingItemSheet(
                title: 'Add Source',
                list: _sources,
              );
            }),
            const SizedBox(height: 12),
            ..._sources.map((item) => _buildSourceItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String addSheetTitle, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onAdd,
          child: const Row(
            children: [
              Icon(Icons.add, color: Color(0xFF06B6D4), size: 16),
              SizedBox(width: 4),
              Text(
                'Add',
                style: TextStyle(
                  color: Color(0xFF06B6D4),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineItem(SettingItem item) {
    return _buildBaseSettingItem(
      item: item,
      list: _pipelines,
      editTitle: 'Edit Pipeline',
      child: Row(
        children: [
          Icon(item.icon, color: item.color, size: 20),
          const SizedBox(width: 12),
          Text(
            item.name,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildStageItem(SettingItem item) {
    return _buildBaseSettingItem(
      item: item,
      list: _stages,
      editTitle: 'Edit Stage',
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            item.name,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(SettingItem item) {
    return _buildBaseSettingItem(
      item: item,
      list: _sources,
      editTitle: 'Edit Source',
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: item.isIcon
                ? const Icon(Icons.star, color: Colors.white, size: 14)
                : Text(
                    item.indicator ?? item.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Text(
            item.name,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseSettingItem({
    required SettingItem item,
    required List<SettingItem> list,
    required String editTitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: child),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black38, size: 20),
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.black87, size: 18),
                    SizedBox(width: 12),
                    Text('Edit', style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              if (value == 'edit') {
                _showAddOrEditSettingItemSheet(
                  title: editTitle,
                  list: list,
                  existingItem: item,
                );
              } else if (value == 'delete') {
                _deleteItem(list, item);
              }
            },
          ),
        ],
      ),
    );
  }
}
