import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../../../home/presentation/widgets/custom_drawer.dart';
import '../widgets/add_vendor_bottom_sheet.dart';
import '../widgets/vendor_details_bottom_sheet.dart';

class Vendor {
  final String id;
  final String initials;
  final Color avatarColor;
  final String name;
  final String phone;
  final String type; // 'Business' or 'Individual'

  Vendor({
    required this.id,
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.phone,
    required this.type,
  });
}

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  final List<Vendor> _vendors = [
    Vendor(
      id: '1',
      initials: 'RK',
      avatarColor: const Color(0xFF3B82F6), // Blue
      name: 'RK Steel Industries',
      phone: '+91 98451 23456',
      type: 'Business',
    ),
    Vendor(
      id: '2',
      initials: 'SR',
      avatarColor: const Color(0xFF10B981), // Green
      name: 'Suresh Ramesh',
      phone: '+91 94444 56789',
      type: 'Individual',
    ),
    Vendor(
      id: '3',
      initials: 'KM',
      avatarColor: const Color(0xFFF59E0B), // Orange
      name: 'KM Cement Works',
      phone: '+91 77771 88800',
      type: 'Business',
    ),
  ];

  void _showAddVendorSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddVendorBottomSheet(),
      ),
    );
  }

  void _showVendorDetails(Vendor vendor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VendorDetailsBottomSheet(vendor: vendor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: const Text(
          'Vendors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white54),
            onPressed: _showAddVendorSheet,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search vendors...',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          // Vendors List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _vendors.length,
              itemBuilder: (context, index) {
                final vendor = _vendors[index];
                return _buildVendorCard(vendor);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVendorSheet,
        backgroundColor: const Color(0xFF06B6D4), // Cyan theme
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
    Color typeBgColor;
    Color typeTextColor;

    if (vendor.type == 'Business') {
      typeBgColor = const Color(0xFF3B82F6).withValues(alpha: 0.15); // Blue
      typeTextColor = const Color(0xFF3B82F6);
    } else {
      typeBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.15); // Orange
      typeTextColor = const Color(0xFFF59E0B);
    }

    return GestureDetector(
      onTap: () => _showVendorDetails(vendor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: vendor.avatarColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                vendor.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 12, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        vendor.phone,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                vendor.type,
                style: TextStyle(
                  color: typeTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
