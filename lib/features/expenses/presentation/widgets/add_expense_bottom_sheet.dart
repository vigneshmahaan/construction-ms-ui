import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  const AddExpenseBottomSheet({super.key});

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  String? expenseType = 'Site Maintenance';
  String? claimedBy = 'Raj Kumar';
  String? site = 'Metro Towers';
  String? vendor;
  bool useCustomVendor = false;

  @override
  Widget build(BuildContext context) {
    // Determine bottom padding for keyboard
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      margin: const EdgeInsets.only(top: 60), // Space from top screen
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: 20 + bottomPadding,
      ),
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
              const Text(
                'Add Expense',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
          
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabel('EXPENSE TYPE', required: true),
                  _buildDropdown(
                    value: expenseType,
                    items: ['Site Maintenance', 'Labour Wages', 'Materials'],
                    onChanged: (val) => setState(() => expenseType = val),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLabel('CLAIMED BY', required: true),
                  _buildDropdown(
                    value: claimedBy,
                    items: ['Raj Kumar', 'Suresh K.', 'Admin'],
                    onChanged: (val) => setState(() => claimedBy = val),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('AMOUNT', required: true),
                            _buildTextField(
                              hintText: '₹0.00',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('DATE', required: true),
                            _buildTextField(
                              hintText: 'dd-mm-yyyy',
                              suffixIcon: Icons.calendar_today_outlined,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildLabel('SITE', required: false),
                  _buildDropdown(
                    value: site,
                    items: ['Metro Towers', 'Sunrise Villa', 'Ocean View'],
                    onChanged: (val) => setState(() => site = val),
                  ),
                  const SizedBox(height: 16),
                  
                  // Checkbox
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: useCustomVendor,
                          onChanged: (val) {
                            setState(() {
                              useCustomVendor = val ?? false;
                              if (!useCustomVendor) {
                                vendor = null;
                              } else {
                                vendor = 'RK Steel Industries';
                              }
                            });
                          },
                          activeColor: const Color(0xFF06B6D4),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Use Custom Vendor / Inventory',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (useCustomVendor) ...[
                    _buildLabel('SELECT VENDOR / INVENTORY', required: false),
                    _buildDropdown(
                      value: vendor,
                      items: ['RK Steel Industries', 'Alpha Cements'],
                      onChanged: (val) => setState(() => vendor = val),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  _buildLabel('NOTES', required: false),
                  _buildTextField(
                    hintText: 'Additional notes...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Add Expense Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4), // Primary Cyan
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add Expense',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          children: required
              ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.background,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    IconData? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white30),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.white30, size: 20)
              : null,
        ),
      ),
    );
  }
}
