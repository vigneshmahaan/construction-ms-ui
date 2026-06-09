import 'package:flutter/material.dart';
import '../../../profile/presentation/widgets/edit_profile_bottom_sheet.dart';
import '../../../company_info/presentation/pages/company_info_page.dart';
import '../../../auth/presentation/pages/login_page.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _appLock = false;
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _darkMode = true;

  void _showSetPinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set App PIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter a 4-digit PIN to protect your app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: index == 0 ? const Color(0xFF06B6D4) : Colors.white10,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: index == 0
                          ? const Text('|', style: TextStyle(color: Colors.white, fontSize: 24))
                          : null,
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _appLock = false;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Set PIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    setState(() {}); // Reflect toggle state if dismissed
  }

  void _showChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Change Password',
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
                _buildPasswordField('CURRENT PASSWORD *', 'Enter current password'),
                _buildPasswordField('NEW PASSWORD *', 'Enter new password'),
                _buildPasswordField('CONFIRM NEW PASSWORD *', 'Re-enter new password'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(String label, String hint) {
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
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
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
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('ACCOUNT'),
              _buildSettingsCard([
                _buildListTile(
                  icon: Icons.person_outline,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBgColor: const Color(0xFFEDE9FE),
                  title: 'Edit Profile',
                  subtitle: 'Name, email, phone, photo',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const EditProfileBottomSheet(
                          initialName: 'Vigneshwaran',
                          initialEmail: 'rockyvignesh312@gmail.com',
                          initialUsername: 'vigclaw',
                          initialPhone: '7010396731',
                        ),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.business_center_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  iconBgColor: const Color(0xFFDBEAFE),
                  title: 'Company Details',
                  subtitle: 'GST, PAN, bank, address',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanyInfoPage()));
                  },
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionTitle('SECURITY'),
              _buildSettingsCard([
                _buildToggleTile(
                  icon: Icons.lock_outline,
                  iconColor: const Color(0xFF06B6D4),
                  iconBgColor: const Color(0xFFCFFAFE),
                  title: 'App Lock',
                  subtitle: 'Fingerprint or PIN protection',
                  value: _appLock,
                  onChanged: (val) {
                    setState(() {
                      _appLock = val;
                    });
                    if (val) {
                      _showSetPinDialog();
                    }
                  },
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.vpn_key_outlined,
                  iconColor: const Color(0xFFEF4444),
                  iconBgColor: const Color(0xFFFEE2E2),
                  title: 'Change Password',
                  subtitle: 'Update your login credentials',
                  onTap: _showChangePasswordSheet,
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionTitle('NOTIFICATIONS'),
              _buildSettingsCard([
                _buildToggleTile(
                  icon: Icons.notifications_none_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  iconBgColor: const Color(0xFFDBEAFE),
                  title: 'Push Notifications',
                  subtitle: 'Attendance, tasks, approvals',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                _buildDivider(),
                _buildToggleTile(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: const Color(0xFFD1FAE5),
                  title: 'Email Alerts',
                  subtitle: 'Reports and summaries',
                  value: _emailAlerts,
                  onChanged: (val) => setState(() => _emailAlerts = val),
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionTitle('APPEARANCE'),
              _buildSettingsCard([
                _buildToggleTile(
                  icon: Icons.light_mode_outlined,
                  iconColor: const Color(0xFF06B6D4),
                  iconBgColor: const Color(0xFFCFFAFE),
                  title: 'Dark Mode',
                  subtitle: 'Currently active',
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.language,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBgColor: const Color(0xFFEDE9FE),
                  title: 'Language',
                  subtitle: 'English (India)',
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 24),
              _buildSectionTitle('DATA & STORAGE'),
              _buildSettingsCard([
                _buildListTile(
                  icon: Icons.delete_outline,
                  iconColor: const Color(0xFFEF4444),
                  iconBgColor: const Color(0xFFFEE2E2),
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
                  },
                ),
              ]),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                  label: const Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Aatzy Build v1.0.3 · Built with ❤️ for construction',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 13,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
      onTap: onTap,
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF06B6D4),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9),
      indent: 64,
      endIndent: 16,
    );
  }
}
