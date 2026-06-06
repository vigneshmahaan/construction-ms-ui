import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';
import 'package:construction_ms_ui/features/material_indent/data/models/material_indent_model.dart';
import 'package:intl/intl.dart';

class MaterialFormGroup {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    categoryController.dispose();
    nameController.dispose();
    qtyController.dispose();
    descriptionController.dispose();
  }
}

class NewIndentSheet extends StatefulWidget {
  final Function(MaterialIndent) onSave;

  const NewIndentSheet({Key? key, required this.onSave}) : super(key: key);

  @override
  State<NewIndentSheet> createState() => _NewIndentSheetState();
}

class _NewIndentSheetState extends State<NewIndentSheet> {
  String? selectedSite = 'Metro Towers Site';
  String? selectedAssignee = 'Raj Kumar';
  IndentPriority priority = IndentPriority.high;
  DateTime? endDate;
  
  final List<MaterialFormGroup> _formGroups = [MaterialFormGroup()];

  @override
  void dispose() {
    for (var group in _formGroups) {
      group.dispose();
    }
    super.dispose();
  }

  void _addMore() {
    setState(() {
      _formGroups.add(MaterialFormGroup());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  void _saveIndent() {
    List<MaterialItem> items = [];
    String mainDescription = '';

    for (int i = 0; i < _formGroups.length; i++) {
      final group = _formGroups[i];
      if (group.nameController.text.isNotEmpty && group.qtyController.text.isNotEmpty) {
        items.add(MaterialItem(
          category: group.categoryController.text,
          name: group.nameController.text,
          quantity: group.qtyController.text,
        ));
        if (i == 0) {
          mainDescription = group.descriptionController.text;
        }
      }
    }
    
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one material')));
      return;
    }
    
    if (endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an end date')));
      return;
    }

    final newIndent = MaterialIndent(
      id: '#IND-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      siteName: selectedSite ?? 'Unknown Site',
      assignedTo: selectedAssignee ?? 'Unassigned',
      priority: priority,
      status: IndentStatus.pending,
      endDate: endDate!,
      materials: items,
      description: mainDescription,
    );
    
    widget.onSave(newIndent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Material Indent',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'TO SITE',
              isRequired: true,
              hint: 'Select Site',
              isDropdown: true,
              isDark: true,
              dropdownValue: selectedSite,
              dropdownItems: const ['Metro Towers Site', 'Sunrise Villa Site', 'Lakeside Phase 2'],
              onDropdownChanged: (val) => setState(() => selectedSite = val),
            ),
            CustomFormField(
              label: 'ASSIGNED TO',
              isRequired: true,
              hint: 'Select Assignee',
              isDropdown: true,
              isDark: true,
              dropdownValue: selectedAssignee,
              dropdownItems: const ['Raj Kumar', 'Suresh K.', 'Amit Patel'],
              onDropdownChanged: (val) => setState(() => selectedAssignee = val),
            ),
            const Text(
              'PRIORITY',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioButton('High', IndentPriority.high),
                const SizedBox(width: 16),
                _buildRadioButton('Low', IndentPriority.low),
              ],
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'END DATE',
              isRequired: true,
              hint: endDate != null ? DateFormat('dd-MM-yyyy').format(endDate!) : 'dd-mm-yyyy',
              isDark: true,
              readOnly: true,
              onTap: () => _selectDate(context),
              suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF64748B), size: 18),
            ),
            
            ..._formGroups.asMap().entries.map((entry) {
              final idx = entry.key;
              final group = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  decoration: idx > 0 ? BoxDecoration(
                    border: Border(top: BorderSide(color: const Color(0xFF334155).withOpacity(0.5))),
                  ) : null,
                  padding: idx > 0 ? const EdgeInsets.only(top: 16.0) : EdgeInsets.zero,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomFormField(
                              label: 'CATEGORY',
                              hint: idx == 0 ? 'e.g. Cement' : 'e.g. Steel',
                              controller: group.categoryController,
                              isDark: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: CustomFormField(
                              label: 'MATERIAL NAME',
                              hint: idx == 0 ? 'e.g. OPC 53 Grade' : 'e.g. TMT 8mm',
                              controller: group.nameController,
                              isDark: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: CustomFormField(
                              label: 'QTY',
                              hint: idx == 0 ? '100 bag' : '50T',
                              controller: group.qtyController,
                              isDark: true,
                            ),
                          ),
                        ],
                      ),
                      CustomFormField(
                        label: 'DESCRIPTION',
                        hint: idx == 0 ? 'Additional notes' : 'Notes',
                        controller: group.descriptionController,
                        isDark: true,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _addMore,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('+ Add More', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Bulk add logic mockup
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF334155)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Add Bulk', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveIndent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Save Indent',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, IndentPriority value) {
    final isSelected = priority == value;
    return GestureDetector(
      onTap: () => setState(() => priority = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? AppColors.primary : const Color(0xFF64748B),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
