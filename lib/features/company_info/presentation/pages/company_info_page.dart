import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../widgets/edit_company_bottom_sheet.dart';
import '../../../vendors/presentation/pages/vendors_page.dart';
import '../../../expenses/presentation/pages/expenses_page.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';
import 'package:construction_ms_ui/shared/utils/ui_utils.dart';

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  State<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  bool _isLoading = true;
  String _companyName = '';
  String _estYear = '';
  String _city = '';
  String _state = '';
  String _address = '';
  String _gstNumber = '';
  String _panNumber = '';
  String _phone = '';
  String _email = '';
  String _website = '';

  @override
  void initState() {
    super.initState();
    _fetchCompanyInfo();
  }

  Future<void> _fetchCompanyInfo() async {
    try {
      final userId = ApiService.currentUserId;
      if (userId == null) return;
      
      final api = ApiService();
      final user = await api.get('/users/$userId');
      
      if (user['company'] != null) {
        final comp = user['company'];
        setState(() {
          _companyName = comp['name'] ?? 'N/A';
          _estYear = comp['estYear'] ?? '';
          _city = comp['city'] ?? '';
          _state = comp['state'] ?? '';
          _address = comp['address'] ?? 'N/A';
          _gstNumber = comp['gstNumber'] ?? 'N/A';
          _panNumber = comp['panNumber'] ?? 'N/A';
          _phone = comp['phone'] ?? 'N/A';
          _email = comp['email'] ?? 'N/A';
          _website = comp['website'] ?? 'N/A';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showEditSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditCompanyBottomSheet(
          initialName: _companyName,
          initialAddress: _address,
          initialGst: _gstNumber,
          initialPan: _panNumber,
          initialPhone: _phone,
          initialEmail: _email,
          initialWebsite: _website,
        ),
      ),
    );

    if (result != null) {
      final companyId = ApiService.currentCompanyId;
      if (companyId != null) {
        try {
          final api = ApiService();
          await api.put('/companies/$companyId', {
            'name': result['name'],
            'address': result['address'],
            'gstNumber': result['gstNumber'],
            'panNumber': result['panNumber'],
            'phone': result['phone'],
            'email': result['email'],
            'website': result['website'],
          });

          if (mounted) {
            UiUtils.showCustomSnackBar(
              context: context,
              message: 'Company details updated successfully!',
              isError: false,
            );
          }

          setState(() {
            _companyName = result['name'] ?? _companyName;
            _address = result['address'] ?? _address;
            _gstNumber = result['gstNumber'] ?? _gstNumber;
            _panNumber = result['panNumber'] ?? _panNumber;
            _phone = result['phone'] ?? _phone;
            _email = result['email'] ?? _email;
            _website = result['website'] ?? _website;
          });
        } catch (e) {
          if (mounted) {
            UiUtils.showCustomSnackBar(
              context: context,
              message: 'Failed to update company details.',
            );
          }
        }
      }
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            const SizedBox(height: 24),
            const Text(
              'Change Profile Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF06B6D4)),
              ),
              title: const Text('Take using Camera', style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library_outlined, color: Color(0xFF3B82F6)),
              ),
              title: const Text('Take from Gallery', style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Company Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white54),
            onPressed: () => _showEditSheet(context),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            // Header Logo
            Center(
              child: GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imageFile == null
                          ? const Icon(Icons.business_center_outlined, color: Color(0xFFF59E0B), size: 40)
                          : null,
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _companyName,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Est. $_estYear · $_city, $_state',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Business Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BUSINESS INFO',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem('ADDRESS', _address),
                  _buildDivider(),
                  _buildInfoItem('GST NUMBER', _gstNumber),
                  _buildDivider(),
                  _buildInfoItem('PAN NUMBER', _panNumber),
                  _buildDivider(),
                  _buildInfoItem('PHONE', _phone),
                  _buildDivider(),
                  _buildInfoItem('EMAIL', _email),
                  _buildDivider(),
                  _buildInfoItem('WEBSITE', _website, valueColor: const Color(0xFF06B6D4)),
                  const SizedBox(height: 32),

                  const Text(
                    'BANK DETAILS',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildBankRow('Bank Name', 'ICICI Bank'),
                        const SizedBox(height: 12),
                        _buildBankRow('Account No.', '•••• •••• 4521'),
                        const SizedBox(height: 12),
                        _buildBankRow('IFSC Code', 'ICIC0001234'),
                        const SizedBox(height: 12),
                        _buildBankRow('Branch', 'Anna Nagar, Chennai'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'LINKED TO',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLinkedModuleCard(
                    context: context,
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF3B82F6), // Blue
                    title: 'Vendors',
                    subtitle: 'GST used in Purchase Orders & Bills',
                    targetPage: const VendorsPage(),
                  ),
                  const SizedBox(height: 12),
                  _buildLinkedModuleCard(
                    context: context,
                    icon: Icons.payment_outlined,
                    iconColor: const Color(0xFF10B981), // Green
                    title: 'Accounts & Expenses',
                    subtitle: 'Bank details used for payments',
                    targetPage: const ExpensesPage(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE2E8F0),
    );
  }

  Widget _buildBankRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkedModuleCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget targetPage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
