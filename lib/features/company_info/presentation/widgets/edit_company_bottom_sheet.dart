import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class EditCompanyBottomSheet extends StatefulWidget {
  const EditCompanyBottomSheet({super.key});

  @override
  State<EditCompanyBottomSheet> createState() => _EditCompanyBottomSheetState();
}

class _EditCompanyBottomSheetState extends State<EditCompanyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
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
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Company',
                style: TextStyle(
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('COMPANY NAME *', 'RK Constructions Pvt Ltd'),
                  _buildTextField('ADDRESS', '14, Industrial Estate, Chennai – 600058, Tamil Nadu', maxLines: 2),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('GST NUMBER', '33AABCC1234D1Z5')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('PAN NUMBER', 'AABCC1234D')),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('PHONE', '+91 44 2345 6789')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('EMAIL', 'info@rkconstructions.com')),
                    ],
                  ),
                  
                  _buildTextField('WEBSITE', 'www.rkconstructions.com'),
                  _buildTextField('BANK NAME', 'ICICI Bank'),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('ACCOUNT NO.', 'XXXX XXXX 4521')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('IFSC CODE', 'ICIC0001234')),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4), // Orange from mockup, wait, user said "electric cyan is main" in previous prompt, but here it's orange in mockup. Let me use Cyan as requested previously "color is takes from other pages electric cyan is main do now". Actually I'll use 0xFFF59E0B since mockup has it orange, or wait, user didn't specify color for this specific page, but earlier said "electric cyan is main". Let's stick to Orange like the mockup for this specific button, or use AppColors.primary if it's cyan. Wait, mockup shows orange. Let me use Orange.
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
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
              controller: TextEditingController(text: initialValue),
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
