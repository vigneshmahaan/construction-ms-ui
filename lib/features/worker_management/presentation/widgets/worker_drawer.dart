import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';

class WorkerDrawer extends StatelessWidget {
  const WorkerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(color: Colors.white10, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(Icons.grid_view, 'My Projects', isSelected: true, onTap: () {
                    Navigator.of(context).pop();
                  }),
                  const Divider(color: Colors.white10, height: 32),
                  _buildDrawerItem(Icons.person_outline, 'Profile', onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile page coming soon')));
                  }),
                  _buildDrawerItem(Icons.settings_outlined, 'Settings', onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings page coming soon')));
                  }),
                  _buildDrawerItem(Icons.logout, 'Logout', isDestructive: true, onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.2),
            child: const Icon(Icons.engineering, color: Color(0xFF10B981), size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Suresh Kannan',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Site Engineer',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false, bool isDestructive = false, required VoidCallback onTap}) {
    Color itemColor = isDestructive ? Colors.red.shade400 : (isSelected ? const Color(0xFF10B981) : Colors.white70);
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF10B981).withValues(alpha: 0.1),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
