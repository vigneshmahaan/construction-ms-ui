import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';
import 'package:construction_ms_ui/features/vehicles/data/models/vehicle_model.dart';
import 'package:construction_ms_ui/features/vehicles/presentation/widgets/add_vehicle_sheet.dart';
import 'package:construction_ms_ui/features/vehicles/presentation/widgets/vehicle_details_sheet.dart';

class VehiclesPage extends StatefulWidget {
  final bool isReadOnly;
  const VehiclesPage({super.key, this.isReadOnly = false});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final List<Vehicle> _vehicles = List.from(mockVehicles);

  void _showAddVehicleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddVehicleSheet(
        onSave: (newVehicle) {
          setState(() {
            _vehicles.insert(0, newVehicle);
          });
        },
      ),
    );
  }

  void _showVehicleDetails(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => VehicleDetailsSheet(vehicle: vehicle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Vehicles',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          if (widget.isReadOnly)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Read-Only Mode. You can view vehicles but cannot edit or add them.',
                      style: TextStyle(color: Colors.amber.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _vehicles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildVehicleCard(_vehicles[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isReadOnly ? null : FloatingActionButton(
        onPressed: _showAddVehicleSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    final isActive = vehicle.status == VehicleStatus.active;
    final iconBgColor = isActive ? const Color(0xFFF59E0B).withValues(alpha: 0.1) : const Color(0xFF3B82F6).withValues(alpha: 0.1);
    final iconColor = isActive ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6);
    
    return InkWell(
      onTap: () => _showVehicleDetails(vehicle),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_shipping_outlined, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vehicle.numberPlate,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusPill(vehicle.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.type} · ${vehicle.manufacturer} · ${vehicle.capacity} capacity',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RC: ${vehicle.rcNumber}',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(VehicleStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case VehicleStatus.active:
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        text = 'ACTIVE';
        break;
      case VehicleStatus.onSite:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        text = 'ON SITE';
        break;
      case VehicleStatus.maintenance:
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        text = 'MAINTENANCE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
