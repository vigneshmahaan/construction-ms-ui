import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class AddSettingItemBottomSheet extends StatefulWidget {
  final String title;
  final String? initialName;
  final Color? initialColor;

  const AddSettingItemBottomSheet({
    super.key,
    required this.title,
    this.initialName,
    this.initialColor,
  });

  @override
  State<AddSettingItemBottomSheet> createState() => _AddSettingItemBottomSheetState();
}

class _AddSettingItemBottomSheetState extends State<AddSettingItemBottomSheet> {
  late TextEditingController _nameController;
  int _selectedColorIndex = 1; // Default to Blue

  final List<Color> _colors = [
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF10B981), // Green
    const Color(0xFFF59E0B), // Yellow/Amber
    const Color(0xFFEF4444), // Red
    const Color(0xFF06B6D4), // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    
    if (widget.initialColor != null) {
      final index = _colors.indexWhere((c) => c.toARGB32() == widget.initialColor!.toARGB32());
      if (index != -1) {
        _selectedColorIndex = index;
      } else {
        _colors.add(widget.initialColor!);
        _selectedColorIndex = _colors.length - 1;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close, color: Colors.white70, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'NAME *',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'e.g. Setting Name',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'COLOR CODE',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_colors.length, (index) {
                final isSelected = _selectedColorIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colors[index],
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _colors[index].withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 40),

          // Save Button
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) return;
              Navigator.pop(context, {
                'name': _nameController.text.trim(),
                'color': _colors[_selectedColorIndex],
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4), // Cyan theme
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.initialName != null ? 'Update Item' : 'Save Item',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
