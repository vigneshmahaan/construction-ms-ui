import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/logistics/data/models/logistic_model.dart';

class CreateLogisticSheet extends StatefulWidget {
  final Function(LogisticTrip) onSave;

  const CreateLogisticSheet({super.key, required this.onSave});

  @override
  State<CreateLogisticSheet> createState() => _CreateLogisticSheetState();
}

class _CreateLogisticSheetState extends State<CreateLogisticSheet> {
  String _fromLocation = 'Chennai Main Godown';
  String _toLocation = 'Metro Towers Site';
  String _vehicle = 'TN-38 AK 4521 (Tipper)';
  String _driver = 'Murugan';

  void _createLogistic() {
    // Generate a simple ID
    final newId = '#TR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    final newTrip = LogisticTrip(
      id: newId,
      fromLocation: _fromLocation,
      toLocation: _toLocation,
      vehicleNumber: _vehicle.split(' ').sublist(0, 3).join(' '), // simple parsing for mock
      vehicleType: _vehicle.contains('Tipper') ? 'Tipper' : 'Truck',
      driverName: _driver,
      driverPhone: '+91 98451 22340', // Mock data
      status: LogisticStatus.inTransit,
      materials: [], // Empty for now, but UI shows form can add indent
    );
    
    widget.onSave(newTrip);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
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
            const SizedBox(height: 24),
            
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Logistic',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 24),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownField('FROM LOCATION *', _fromLocation, ['Chennai Main Godown', 'RK Steel Industries']),
                    const SizedBox(height: 16),
                    _buildDropdownField('TO LOCATION *', _toLocation, ['Metro Towers Site', 'Chennai Main Godown', 'Sunrise Villa']),
                    const SizedBox(height: 16),
                    _buildDropdownField('ADD MATERIAL INDENT', 'None', ['None', '#IND-2025-041']),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildDateField('START DATE', 'dd-mm-yyyy')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDateField('END DATE', 'dd-mm-yyyy')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField('SELECT VEHICLE', _vehicle, ['TN-38 AK 4521 (Tipper)', 'TN-07 BM 9983 (Truck)']),
                    const SizedBox(height: 16),
                    _buildDropdownField('SELECT DRIVER', _driver, ['Murugan', 'Senthil', 'Rajesh']),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createLogistic,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Create Logistic',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface, // Dark background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option, style: const TextStyle(color: Colors.white, fontSize: 14)),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    if (label.contains('FROM')) _fromLocation = newValue;
                    if (label.contains('TO')) _toLocation = newValue;
                    if (label.contains('VEHICLE')) _vehicle = newValue;
                    if (label.contains('DRIVER')) _driver = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface, // Dark background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Icon(Icons.calendar_today_outlined, color: Colors.white54, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
