import 'package:flutter/material.dart';
import '../../../app_settings/presentation/pages/app_settings_page.dart';
import '../../../company_info/presentation/pages/company_info_page.dart';
import '../widgets/edit_profile_bottom_sheet.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';
import 'package:construction_ms_ui/shared/utils/ui_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = '';
  String _email = '';
  String _username = '';
  String _phone = '';
  String _companyName = '';
  String _role = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userId = ApiService.currentUserId;
      if (userId == null) return;
      
      final api = ApiService();
      final user = await api.get('/users/$userId');
      
      setState(() {
        _fullName = user['fullName'] ?? 'N/A';
        _email = user['email'] ?? 'N/A';
        _username = user['username'] ?? 'N/A';
        _phone = user['phone'] ?? 'N/A';
        _role = user['role'] ?? 'WORKER';
        
        if (user['company'] != null) {
          _companyName = user['company']['name'] ?? 'N/A';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditProfileSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditProfileBottomSheet(
          initialName: _fullName,
          initialEmail: _email,
          initialUsername: _username,
          initialPhone: _phone,
        ),
      ),
    );

    if (result != null) {
      final name = result['name'] ?? _fullName;
      final email = result['email'] ?? _email;
      final username = result['username'] ?? _username;
      
      try {
        final userId = ApiService.currentUserId;
        if (userId != null) {
          final api = ApiService();
          await api.put('/users/$userId', {
            'fullName': name,
            'email': email,
            'username': username,
          });
          
          if (mounted) {
            UiUtils.showCustomSnackBar(
              context: context,
              message: 'Profile updated successfully!',
              isError: false,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          UiUtils.showCustomSnackBar(
            context: context,
            message: 'Failed to update profile.',
          );
        }
      }

      setState(() {
        _fullName = name;
        _email = email;
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildProfileHeader(),
                const SizedBox(height: 32),
                _buildSectionTitle('PERSONAL INFO'),
                _buildPersonalInfoSection(),
                const SizedBox(height: 32),
                _buildSectionTitle('SECURITY'),
                _buildSecuritySection(),
                if (_role == 'ADMIN') ...[
                  const SizedBox(height: 32),
                  _buildSectionTitle('LINKED TO'),
                  _buildLinkedToSection(context),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white54),
          onPressed: () => _showEditProfileSheet(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _fullName.length >= 2 ? _fullName.substring(0, 2).toUpperCase() : (_fullName.isNotEmpty ? _fullName.toUpperCase() : 'US'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Change photo action
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Change Photo',
              style: TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Text(
              _role == 'ADMIN' ? 'Admin' : (_role == 'CLIENT' ? 'Client' : 'Worker'),
              style: const TextStyle(
                color: Color(0xFFD97706),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoItem('FULL NAME', _fullName),
          _buildDivider(),
          _buildInfoItem('EMAIL', _email),
          _buildDivider(),
          _buildInfoItem('USERNAME', _username),
          _buildDivider(),
          _buildInfoItem('PHONE', _phone),
          if (_companyName.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoItem('COMPANY', _companyName, isLast: true),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
      color: Color(0xFFF1F5F9),
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline, color: Color(0xFFD97706), size: 20),
              ),
              title: const Text(
                'Password',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Last changed 30 days ago',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E8F0),
                  foregroundColor: const Color(0xFF0F172A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedToSection(BuildContext context) {
    return Column(
      children: [
        _buildLinkedItem(
          icon: Icons.business_center_outlined,
          iconColor: const Color(0xFF8B5CF6),
          iconBgColor: const Color(0xFFEDE9FE),
          title: 'Company Details',
          subtitle: 'Your company profile & GST info',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompanyInfoPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildLinkedItem(
          icon: Icons.settings_outlined,
          iconColor: const Color(0xFF06B6D4),
          iconBgColor: const Color(0xFFFEF3C7),
          title: 'App Settings',
          subtitle: 'Notifications, security & preferences',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppSettingsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinkedItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: iconBgColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: iconBgColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF94A3B8),
            size: 20,
          ),
        ),
      ),
    );
  }
}
