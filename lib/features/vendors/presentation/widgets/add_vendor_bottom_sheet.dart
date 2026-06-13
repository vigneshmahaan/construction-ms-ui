import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class AddVendorBottomSheet extends StatefulWidget {
  const AddVendorBottomSheet({super.key});

  @override
  State<AddVendorBottomSheet> createState() => _AddVendorBottomSheetState();
}

class _AddVendorBottomSheetState extends State<AddVendorBottomSheet> {
  String _vendorType = 'Business';
  String _selectedCategory = 'Material Supplier';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _nameController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  final List<String> _categories = [
    'Material Supplier',
    'Equipment Rental',
    'Subcontractor',
    'Service Provider',
    'Other',
  ];

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
                'Add Vendor',
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
                  const Text(
                    'VENDOR TYPE',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildRadioButton('Business'),
                      const SizedBox(width: 24),
                      _buildRadioButton('Individual'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildTextField('NAME *', 'Full name or company name', controller: _nameController),
                  
                  const Text(
                    'CATEGORY',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField('COMPANY NAME', 'Company name (if business)'),
                  _buildTextField('EMAIL', 'vendor@example.com'),
                  _buildTextField('PHONE *', '+91 98451 XXXXX', controller: _phoneController),
                  _buildTextField('BANK ACCOUNT', 'Account number'),
                  _buildTextField('GST NUMBER', 'GST number'),
                  _buildTextField('BILLING ADDRESS', 'Billing address'),
                  _buildTextField('SHIPPING ADDRESS', 'Same as billing or different', maxLines: 2),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: (_isFormValid && !_isLoading) ? _saveVendor : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4), // Cyan theme
                disabledBackgroundColor: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      'Save Vendor',
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

  void _saveVendor() async {
    if (!_isFormValid) return;
    
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vendor added successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vendor: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildRadioButton(String title) {
    final isSelected = _vendorType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _vendorType = title;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF06B6D4) : Colors.white54,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF06B6D4), // Cyan theme
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF06B6D4) : Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1, TextEditingController? controller}) {
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
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
