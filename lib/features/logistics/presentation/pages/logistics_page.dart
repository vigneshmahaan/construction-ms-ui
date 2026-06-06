import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';
import 'package:construction_ms_ui/features/logistics/data/models/logistic_model.dart';
import 'package:construction_ms_ui/features/logistics/presentation/widgets/create_logistic_sheet.dart';
import 'package:construction_ms_ui/features/logistics/presentation/widgets/trip_details_sheet.dart';

class LogisticsPage extends StatefulWidget {
  const LogisticsPage({Key? key}) : super(key: key);

  @override
  State<LogisticsPage> createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  final List<LogisticTrip> _trips = List.from(mockLogistics);

  void _showCreateLogisticSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CreateLogisticSheet(
        onSave: (newTrip) {
          setState(() {
            _trips.insert(0, newTrip);
          });
        },
      ),
    );
  }

  void _showTripDetails(LogisticTrip trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => TripDetailsSheet(
        trip: trip,
        onStatusChanged: (newStatus) {
          // Status updates could be implemented here
        },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Logistics',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _trips.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildTripCard(_trips[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateLogisticSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTripCard(LogisticTrip trip) {
    final isInTransit = trip.status == LogisticStatus.inTransit;
    
    return InkWell(
      onTap: () => _showTripDetails(trip),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6), // Blue dot
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('FROM', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          trip.fromLocation,
                          style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Color(0xFFCBD5E1), size: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B), // Orange dot
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('TO', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          trip.toLocation,
                          style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined, color: Color(0xFF64748B), size: 14),
                const SizedBox(width: 4),
                Text(trip.vehicleNumber, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.person_outline, color: Color(0xFF64748B), size: 14),
                const SizedBox(width: 4),
                Text('${trip.driverName} (Driver)', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(width: 12),
                Icon(
                  isInTransit ? Icons.inventory_2_outlined : Icons.check_circle_outline, 
                  color: const Color(0xFF64748B), 
                  size: 14
                ),
                const SizedBox(width: 4),
                Text(
                  isInTransit ? 'In Transit' : 'Delivered', 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusPill(trip.status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(LogisticStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    if (status == LogisticStatus.inTransit) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      text = 'IN TRANSIT';
    } else {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      text = 'DELIVERED';
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
