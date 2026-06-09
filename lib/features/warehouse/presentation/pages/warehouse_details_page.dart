import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/warehouse/data/mock_warehouse_data.dart';

class WarehouseDetailsPage extends StatefulWidget {
  final Map<String, dynamic> warehouseData;

  const WarehouseDetailsPage({super.key, required this.warehouseData});

  @override
  State<WarehouseDetailsPage> createState() => _WarehouseDetailsPageState();
}

class _WarehouseDetailsPageState extends State<WarehouseDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUpdateStockModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _UpdateStockModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = mockWarehouseDetails[widget.warehouseData['id']] ?? {'currentStock': [], 'logs': []};

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.warehouseData['name'],
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.warehouseData['type']} · ${widget.warehouseData['address'].split(',')[0]}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white54),
            onPressed: _showUpdateStockModal,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF06B6D4),
          indicatorWeight: 3,
          labelColor: const Color(0xFF06B6D4),
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Current Stock'),
            Tab(text: 'In/Out Log'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCurrentStockTab(details['currentStock']),
          _buildLogsTab(details['logs']),
        ],
      ),
    );
  }

  Widget _buildCurrentStockTab(List<dynamic> stockList) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 48, // Slightly taller for a more modern feel
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search stock items...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.black45, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 15), // Adjust padding to perfectly center with the icon
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: stockList.length,
            itemBuilder: (context, index) {
              final item = stockList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: item['isLowStock'] ? Colors.redAccent.withValues(alpha: 0.4) : Colors.grey.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['material'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(item['brand'], style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '${item['quantity']} ',
                            style: TextStyle(
                              color: item['isLowStock'] ? Colors.redAccent : const Color(0xFF06B6D4),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: item['unit'],
                                style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        if (item['isLowStock']) ...[
                          const SizedBox(height: 4),
                          const Text('Low Stock Alert', style: TextStyle(color: Colors.redAccent, fontSize: 10)),
                        ]
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogsTab(List<dynamic> logs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isIn = log['type'] == 'in';
        final iconColor = isIn ? const Color(0xFF10B981) : const Color(0xFFEF4444);
        final bgColor = isIn ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2);
        final icon = isIn ? Icons.arrow_downward : Icons.arrow_upward;

        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(log['subtitle'], style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        log['quantity'],
                        style: TextStyle(color: iconColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(log['date'], style: const TextStyle(color: Colors.black45, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UpdateStockModal extends StatefulWidget {
  const _UpdateStockModal();

  @override
  State<_UpdateStockModal> createState() => _UpdateStockModalState();
}

class _UpdateStockModalState extends State<_UpdateStockModal> {
  final _formKey = GlobalKey<FormState>();
  String _entryType = 'in';
  String? _material;
  String? _unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1B1B28),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Update Stock Entry', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.close, color: Colors.white54, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildLabel('ENTRY TYPE'),
              Row(
                children: [
                  _buildRadioButton('Stock In (Inward)', 'in'),
                  const SizedBox(width: 20),
                  _buildRadioButton('Stock Out (Dispatch)', 'out'),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('MATERIAL *'),
              _buildDropdown(
                value: _material,
                items: ['OPC 53 Grade Cement', 'TMT Steel Bars (12mm)', 'M-Sand (Plastering)'],
                onChanged: (val) => setState(() => _material = val),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('QUANTITY *'),
                        _buildTextField('e.g. 50', isRequired: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('UNIT'),
                        _buildDropdown(
                          value: _unit,
                          items: ['Bags', 'Tons', 'Units'],
                          onChanged: (val) => setState(() => _unit = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildLabel('REFERENCE / REMARKS'),
              _buildTextField('PO Number or Target Site Name', isRequired: false),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String title, String value) {
    final isSelected = _entryType == value;
    return GestureDetector(
      onTap: () => setState(() => _entryType = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? const Color(0xFF06B6D4) : Colors.white54,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final isRequired = text.contains('*');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          text: text.replaceAll('*', '').trim(),
          style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          children: [
            if (isRequired)
              const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isRequired = false}) {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF06B6D4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: const Color(0xFF1B1B28),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF06B6D4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }
}
