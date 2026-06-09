import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_my_projects_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_payments_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_documents_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_contact_contractor_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_profile_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_settings_page.dart';

class ClientDrawer extends StatelessWidget {
  const ClientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Client User',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Client Portal',
                          style: TextStyle(color: Color(0xFF06B6D4), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              isSelected: true,
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.home_work_rounded,
              title: 'My Projects',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientMyProjectsPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.payments_rounded,
              title: 'Payments & Invoices',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientPaymentsPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.description_rounded,
              title: 'Documents & Photos',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientDocumentsPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.contact_support_rounded,
              title: 'Contact Contractor',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientContactContractorPage()));
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white10),
            _buildDrawerItem(
              icon: Icons.person_rounded,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientProfilePage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientSettingsPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              isDestructive: true,
              onTap: () async {
                Navigator.pop(context);
                await AuthService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    final color = isDestructive 
        ? Colors.red.shade400 
        : (isSelected ? AppColors.primary : Colors.white70);

    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
    );
  }
}
