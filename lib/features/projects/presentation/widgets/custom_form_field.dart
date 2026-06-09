import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isDark;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.controller,
    this.suffixIcon,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.readOnly = false,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text.rich(
            TextSpan(
              text: label.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF64748B), // Slate gray
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
        if (isDropdown)
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
            dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            decoration: _buildInputDecoration(),
            style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 14),
            items: dropdownItems?.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            }).toList(),
            onChanged: onDropdownChanged,
          )
        else
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: TextStyle(color: isDark ? Colors.white : AppColors.textDark, fontSize: 14),
            decoration: _buildInputDecoration(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14), // Lighter slate
      filled: true,
      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9), // Very light slate background for input
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
