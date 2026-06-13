import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialUsername;
  final String initialPhone;

  const EditProfileBottomSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialUsername,
    required this.initialPhone,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  bool _isFormValid = true; // Initially true because text fields start filled

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _usernameController = TextEditingController(text: widget.initialUsername);
    _phoneController = TextEditingController(text: widget.initialPhone);
    
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _usernameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty;
        
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
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
      height: MediaQuery.of(context).size.height * 0.8,
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
                'Edit Profile',
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
                  _buildTextField('FULL NAME', _nameController),
                  _buildTextField('EMAIL', _emailController),
                  _buildTextField('USERNAME', _usernameController),
                  _buildTextField('PHONE', _phoneController, readOnly: true),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: _isFormValid 
                ? () {
                    Navigator.pop(context, {
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                      'username': _usernameController.text.trim(),
                      'phone': _phoneController.text.trim(),
                    });
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4), // Electric cyan
                disabledBackgroundColor: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: _isFormValid ? Colors.white : Colors.white54,
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

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
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
              color: readOnly ? Colors.white10 : AppColors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              style: TextStyle(color: readOnly ? Colors.white54 : Colors.white, fontSize: 14),
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
