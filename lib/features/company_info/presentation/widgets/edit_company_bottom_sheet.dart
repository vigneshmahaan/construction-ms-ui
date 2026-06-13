import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class EditCompanyBottomSheet extends StatefulWidget {
  final String initialName;
  final String initialAddress;
  final String initialGst;
  final String initialPan;
  final String initialPhone;
  final String initialEmail;
  final String initialWebsite;

  const EditCompanyBottomSheet({
    super.key,
    required this.initialName,
    required this.initialAddress,
    required this.initialGst,
    required this.initialPan,
    required this.initialPhone,
    required this.initialEmail,
    required this.initialWebsite,
  });

  @override
  State<EditCompanyBottomSheet> createState() => _EditCompanyBottomSheetState();
}

class _EditCompanyBottomSheetState extends State<EditCompanyBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _gstController;
  late TextEditingController _panController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _addressController = TextEditingController(text: widget.initialAddress);
    _gstController = TextEditingController(text: widget.initialGst);
    _panController = TextEditingController(text: widget.initialPan);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _emailController = TextEditingController(text: widget.initialEmail);
    _websiteController = TextEditingController(text: widget.initialWebsite);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _panController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

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
                  _buildTextField('COMPANY NAME *', _nameController),
                  _buildTextField('ADDRESS', _addressController, maxLines: 2),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('GST NUMBER', _gstController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('PAN NUMBER', _panController)),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField('PHONE', _phoneController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('EMAIL', _emailController)),
                    ],
                  ),
                  
                  _buildTextField('WEBSITE', _websiteController),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text.trim(),
                  'address': _addressController.text.trim(),
                  'gstNumber': _gstController.text.trim(),
                  'panNumber': _panController.text.trim(),
                  'phone': _phoneController.text.trim(),
                  'email': _emailController.text.trim(),
                  'website': _websiteController.text.trim(),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4), // Electric cyan
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
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
              controller: controller,
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
