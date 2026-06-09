import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _companyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Client User');
    _emailController = TextEditingController(text: 'client@example.com');
    _phoneController = TextEditingController(text: '+91 98765 43210');
    _addressController = TextEditingController(text: '123 Main Street\nBangalore, Karnataka 560001');
    _companyController = TextEditingController(text: 'Independent Client');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      // Show snackbar when saving
      if (!_isEditing) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit_rounded, color: Colors.white),
            onPressed: _toggleEdit,
            tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  if (_isEditing)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      isDense: true,
                    ),
                  ),
                )
              else
                Text(
                  _nameController.text,
                  style: const TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 4),
              Text(
                _emailController.text,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 40),
              
              // Profile Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildProfileItem(Icons.phone_outlined, 'Phone Number', _phoneController),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    _buildProfileItem(Icons.email_outlined, 'Email Address', _emailController),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    _buildProfileItem(Icons.location_on_outlined, 'Billing Address', _addressController, maxLines: 3),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    _buildProfileItem(Icons.domain_outlined, 'Company', _companyController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black45, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                if (_isEditing)
                  TextField(
                    controller: controller,
                    maxLines: maxLines,
                    minLines: 1,
                    style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
                else
                  Text(
                    controller.text,
                    style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
