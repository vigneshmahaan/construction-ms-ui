import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class AddAdvanceBottomSheet extends StatefulWidget {
  const AddAdvanceBottomSheet({super.key});

  @override
  State<AddAdvanceBottomSheet> createState() => _AddAdvanceBottomSheetState();
}

class _AddAdvanceBottomSheetState extends State<AddAdvanceBottomSheet> {
  String? fromUser = 'Admin - Raj Kumar';
  String? toUser = 'Muthu Kumar';
  String paymentType = 'Cash';

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.only(top: 60),
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
                'Add Advance',
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
                  _buildLabel('FROM USER (ADMIN)'),
                  _buildDropdown(
                    value: fromUser,
                    items: ['Admin - Raj Kumar', 'Super Admin'],
                    onChanged: (val) => setState(() => fromUser = val),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('TO USER (EMPLOYEE)', required: true),
                  _buildDropdown(
                    value: toUser,
                    items: ['Muthu Kumar', 'Suresh K.'],
                    onChanged: (val) => setState(() => toUser = val),
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
                              hintText: '₹0',
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

                  _buildLabel('PAYMENT TYPE'),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => paymentType = 'Cash'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: paymentType == 'Cash'
                                  ? const Color(0xFF06B6D4) // Primary Cyan
                                  : AppColors.background.withValues(alpha: 0.5),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: paymentType == 'Cash'
                                    ? const Color(0xFF06B6D4)
                                    : Colors.white10,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Cash',
                                style: TextStyle(
                                  color: paymentType == 'Cash'
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => paymentType = 'UPI'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: paymentType == 'UPI'
                                  ? const Color(0xFF06B6D4) // Primary Cyan
                                  : AppColors.background.withValues(alpha: 0.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: paymentType == 'UPI'
                                    ? const Color(0xFF06B6D4)
                                    : Colors.white10,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'UPI',
                                style: TextStyle(
                                  color: paymentType == 'UPI'
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Add Advance Button
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
              'Add Advance',
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
