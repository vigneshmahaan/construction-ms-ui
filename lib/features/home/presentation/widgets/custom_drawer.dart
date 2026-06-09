import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/profile/presentation/pages/profile_page.dart';
import 'package:construction_ms_ui/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:construction_ms_ui/features/home/presentation/pages/home_page.dart';
import 'package:construction_ms_ui/features/warehouse/presentation/pages/warehouse_page.dart';
import 'package:construction_ms_ui/features/material_indent/presentation/pages/material_indent_page.dart';
import 'package:construction_ms_ui/features/purchase_orders/presentation/pages/purchase_orders_page.dart';
import 'package:construction_ms_ui/features/stocks_hub/presentation/pages/stocks_hub_page.dart';
import 'package:construction_ms_ui/features/logistics/presentation/pages/logistics_page.dart';
import 'package:construction_ms_ui/features/vehicles/presentation/pages/vehicles_page.dart';
import '../../../expenses/presentation/pages/expenses_page.dart';
import '../../../advances/presentation/pages/advances_page.dart';
import '../../../workers/presentation/pages/workers_page.dart';
import '../../../workers/presentation/pages/manage_workers_page.dart';
import '../../../attendance/presentation/pages/centralized_attendance_page.dart';
import '../../../leave/presentation/pages/leave_management_page.dart';
import '../../../crm_leads/presentation/pages/leads_page.dart';
import '../../../crm_settings/presentation/pages/crm_settings_page.dart';
import '../../../vendors/presentation/pages/vendors_page.dart';
import '../../../app_settings/presentation/pages/app_settings_page.dart';
import '../../../company_info/presentation/pages/company_info_page.dart';
import '../../../auth/presentation/pages/login_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
                  _buildDrawerItem(Icons.grid_view, 'Dashboard', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.menu_book, 'Projects', isSelected: true, onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  }),
                  _buildDrawerItem(Icons.warehouse_outlined, 'Warehouse', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WarehousePage()),
                    );
                  }),
                  _buildSectionTitle('PROCUREMENT'),
                  _buildDrawerItem(Icons.description_outlined, 'Material Indent', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MaterialIndentPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.shopping_bag_outlined, 'Purchase Orders', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PurchaseOrdersPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.check_circle_outline, 'Stocks Hub', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StocksHubPage()),
                    );
                  }),
                  _buildSectionTitle('TRANSPORTATION'),
                  _buildDrawerItem(Icons.analytics_outlined, 'Logistics', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogisticsPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.local_shipping_outlined, 'Vehicles', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VehiclesPage()),
                    );
                  }),
                  _buildSectionTitle('FINANCE'),
                  _buildDrawerItem(Icons.credit_card_outlined, 'Expenses', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExpensesPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.attach_money_outlined, 'Advances', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdvancesPage()),
                    );
                  }),
                  _buildSectionTitle('HR'),
                  _buildDrawerItem(Icons.engineering, 'Manage Workers', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageWorkersPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.person_outline, 'Project Workers', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkersPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.assignment_ind_outlined, 'Centralized Attendance', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CentralizedAttendancePage()),
                    );
                  }),
                  _buildDrawerItem(Icons.calendar_today_outlined, 'Leave Management', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LeaveManagementPage()),
                    );
                  }),
                  _buildSectionTitle('CRM'),
                  _buildDrawerItem(Icons.people_outline, 'Leads', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeadsPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.settings_suggest_outlined, 'CRM Settings', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CrmSettingsPage()),
                    );
                  }),
                  const Divider(color: Colors.white10, height: 32),
                  _buildDrawerItem(Icons.group_outlined, 'Vendors', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VendorsPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.business_outlined, 'Company Details', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CompanyInfoPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.person_outline, 'Profile', onTap: () {
                    Navigator.of(context).pop(); // close drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  }),
                  _buildDrawerItem(Icons.settings_outlined, 'Settings', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AppSettingsPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.logout, 'Logout', isDestructive: true, onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'v1.0.3 · Aatzy Build',
                      style: TextStyle(color: Colors.white24, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Build smart. ',
              style: TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Track better',
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.close, color: Colors.white54, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false, bool isDestructive = false, VoidCallback? onTap}) {
    return _HoverableDrawerItem(
      icon: icon,
      title: title,
      isSelected: isSelected,
      isDestructive: isDestructive,
      onTap: onTap ?? () {},
    );
  }
}

class _HoverableDrawerItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool isDestructive;
  final VoidCallback onTap;

  const _HoverableDrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  State<_HoverableDrawerItem> createState() => _HoverableDrawerItemState();
}

class _HoverableDrawerItemState extends State<_HoverableDrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color baseColor = widget.isDestructive 
        ? Colors.redAccent 
        : Colors.white70;
    
    if (_isHovering && !widget.isDestructive) {
      baseColor = const Color(0xFF06B6D4);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: ListTile(
        leading: Icon(widget.icon, color: baseColor, size: 22),
        title: Text(
          widget.title,
          style: TextStyle(
            color: baseColor,
            fontSize: 14,
            fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        tileColor: _isHovering && !widget.isDestructive 
            ? const Color(0xFF06B6D4).withValues(alpha: 0.15) 
            : null,
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        onTap: widget.onTap,
      ),
    );
  }
}
