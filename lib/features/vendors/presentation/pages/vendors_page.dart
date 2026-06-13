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
  final bool isReadOnly;
  const VendorsPage({super.key, this.isReadOnly = false});

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

  String _searchQuery = '';
  String _filterType = 'All'; // 'All', 'Business', 'Individual'

  List<Vendor> get _filteredVendors {
    return _vendors.where((vendor) {
      final matchesSearch = vendor.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            vendor.phone.contains(_searchQuery);
      final matchesFilter = _filterType == 'All' || vendor.type == _filterType;
      return matchesSearch && matchesFilter;
    }).toList();
  }

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
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white54),
              onPressed: _showAddVendorSheet,
            ),
        ],
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
                      'Read-Only Mode. You can view vendors but cannot edit or add them.',
                      style: TextStyle(color: Colors.amber.shade900, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          // Search and Filter Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black87),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.black54),
                        hintText: 'Search vendors...',
                        hintStyle: TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterType,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list, color: Colors.black54),
                        items: ['All', 'Business', 'Individual'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _filterType = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Vendors List
          Expanded(
            child: _filteredVendors.isEmpty
                ? const Center(
                    child: Text('No vendors found.', style: TextStyle(color: Colors.black54)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredVendors.length,
                    itemBuilder: (context, index) {
                      final vendor = _filteredVendors[index];
                      return _buildVendorCard(vendor);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.isReadOnly ? null : FloatingActionButton(
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
