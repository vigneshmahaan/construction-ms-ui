import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';
import 'package:construction_ms_ui/features/warehouse/presentation/pages/warehouse_page.dart';
import 'package:construction_ms_ui/features/material_indent/presentation/pages/material_indent_page.dart';
import 'package:construction_ms_ui/features/purchase_orders/presentation/pages/purchase_orders_page.dart';
import 'package:construction_ms_ui/features/stocks_hub/presentation/pages/stocks_hub_page.dart';
import 'package:construction_ms_ui/features/logistics/presentation/pages/logistics_page.dart';
import 'package:construction_ms_ui/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:construction_ms_ui/features/vendors/presentation/pages/vendors_page.dart';
import 'package:construction_ms_ui/features/attendance/presentation/pages/centralized_attendance_page.dart';
import 'package:construction_ms_ui/features/profile/presentation/pages/profile_page.dart';
import 'package:construction_ms_ui/features/leave/presentation/pages/worker_leave_page.dart';
import 'package:construction_ms_ui/shared/services/worker_service.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';

class WorkerDrawer extends StatelessWidget {
  const WorkerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWorkerId = AuthService.currentWorkerId;
    final worker = WorkerService().workers.firstWhere(
      (w) => w.id == currentWorkerId,
      orElse: () => WorkerService().workers.first,
    );
    final perms = worker.permissions;

    // Helper to check if a module is allowed
    bool isAllowed(String key) => perms[key] ?? false;

    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, worker.name, worker.role),
            const Divider(color: Colors.white10, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(context, Icons.grid_view, 'My Projects', isSelected: true),
                  const Divider(color: Colors.white10, height: 32),
                  
                  // Default options
                  _buildSectionHeader('HR & PERSONAL'),
                  _buildDrawerItem(context, Icons.person_outline, 'Profile', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                  }),
                  _buildDrawerItem(context, Icons.event_busy_outlined, 'Leave Management', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerLeavePage()));
                  }), // ALWAYS visible
                  
                  // Conditional modules based on toggle (If they have the permission key at all, it's visible. The toggle dictates read-only vs edit.
                  // Wait, the user said: "if admin on the toggle means that need to display for wrokers portal and that they can edit not on sections are need to shown but they cannot able to edit"
                  // This means ALL THESE modules are ALWAYS SHOWN in the sidebar, but when clicked, they are read-only if the toggle is OFF.
                  // Let's show all the toggleable modules in the sidebar.
                  const Divider(color: Colors.white10, height: 32),
                  _buildSectionHeader('PROCUREMENT & WAREHOUSE'),
                  _buildDrawerItem(context, Icons.warehouse_outlined, 'Warehouse', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => WarehousePage(isReadOnly: !isAllowed('warehouse'))));
                  }),
                  _buildDrawerItem(context, Icons.description_outlined, 'Material Indent', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MaterialIndentPage(isReadOnly: !isAllowed('material_indent'))));
                  }),
                  _buildDrawerItem(context, Icons.shopping_bag_outlined, 'Purchase Orders', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PurchaseOrdersPage(isReadOnly: !isAllowed('purchase_orders'))));
                  }),
                  _buildDrawerItem(context, Icons.inventory_2_outlined, 'Stocks Hub', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => StocksHubPage(isReadOnly: !isAllowed('stocks_hub'))));
                  }),
                  
                  const Divider(color: Colors.white10, height: 32),
                  _buildSectionHeader('TRANSPORTATION'),
                  _buildDrawerItem(context, Icons.local_shipping_outlined, 'Logistics', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LogisticsPage(isReadOnly: !isAllowed('logistics'))));
                  }),
                  _buildDrawerItem(context, Icons.directions_car_outlined, 'Vehicles', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VehiclesPage(isReadOnly: !isAllowed('vehicles'))));
                  }),
                  
                  const Divider(color: Colors.white10, height: 32),
                  _buildSectionHeader('PEOPLE & VENDORS'),
                  _buildDrawerItem(context, Icons.groups_outlined, 'Centralized Attendance', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CentralizedAttendancePage(isReadOnly: !isAllowed('centralized_attendance'))));
                  }),
                  _buildDrawerItem(context, Icons.store_outlined, 'Vendors', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => VendorsPage(isReadOnly: !isAllowed('vendors'))));
                  }),

                  const Divider(color: Colors.white10, height: 32),
                  _buildDrawerItem(context, Icons.settings_outlined, 'Settings'),
                  _buildDrawerItem(context, Icons.logout, 'Logout', isDestructive: true, onTap: () {
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? name, String? role) {
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
          Text(
            name ?? 'Suresh Kannan',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            role ?? 'Site Engineer',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, {bool isSelected = false, bool isDestructive = false, VoidCallback? onTap}) {
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
      onTap: onTap ?? () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title page coming soon')));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
