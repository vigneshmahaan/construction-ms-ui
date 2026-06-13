import 'package:flutter/material.dart';
import '../../../../core/network/api_service.dart';

class AddDriverSheet extends StatefulWidget {
  const AddDriverSheet({super.key});

  @override
  State<AddDriverSheet> createState() => _AddDriverSheetState();
}

class _AddDriverSheetState extends State<AddDriverSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_validateForm);
    _phoneCtrl.addListener(_validateForm);
    _licenseCtrl.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _nameCtrl.text.trim().isNotEmpty && _phoneCtrl.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _licenseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add New Driver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField('Driver Full Name', _nameCtrl),
          const SizedBox(height: 16),
          _buildTextField('Phone Number', _phoneCtrl, keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField('Driving License Number', _licenseCtrl),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (_isFormValid && !_isLoading) ? _saveDriver : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                disabledBackgroundColor: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading 
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : Text(
                      'Save Driver',
                      style: TextStyle(
                        color: _isFormValid ? Colors.white : Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          // Give some padding for keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Future<void> _saveDriver() async {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      await api.post('/users', {
        'role': 'DRIVER',
        'fullName': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'idProofType': 'DRIVING_LICENSE',
        'idNumber': _licenseCtrl.text.trim(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver successfully added to the database!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add driver: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
