import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/vehicles/data/models/vehicle_model.dart';

class AddVehicleSheet extends StatefulWidget {
  final Function(Vehicle) onSave;

  const AddVehicleSheet({super.key, required this.onSave});

  @override
  State<AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<AddVehicleSheet> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _rcNumberController = TextEditingController();

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _typeController.addListener(_validateForm);
    _numberPlateController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _typeController.text.trim().isNotEmpty && _numberPlateController.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && _selectedImages.length < 4) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addVehicle() async {
    final type = _typeController.text.trim();
    final numberPlate = _numberPlateController.text.trim();
    
    if (!_isFormValid) return;
    
    final newVehicle = Vehicle(
      id: 'V-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      numberPlate: numberPlate,
      type: type,
      manufacturer: _manufacturerController.text.trim(),
      capacity: _capacityController.text.trim(),
      rcNumber: _rcNumberController.text.trim(),
      status: VehicleStatus.active,
      insuranceExpiry: 'Pending Info',
      fcExpiry: 'Pending Info',
      serviceDue: '0 km',
      isServiceOverdue: false,
      assignedDriverName: 'Unassigned',
      assignedDriverPhone: '',
    );
    
    setState(() => _isLoading = true);
    try {
      // Simulate or await API
      await Future.delayed(const Duration(milliseconds: 500)); 
      widget.onSave(newVehicle);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle added successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vehicle: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  'Add Vehicle',
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
                    _buildTextField('VEHICLE TYPE *', 'e.g. Tipper, JCB, Lorry', _typeController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('MANUFACTURER', 'e.g. TATA, Mahindra', _manufacturerController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('CAPACITY', 'e.g. 8T', _capacityController)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('VEHICLE NAME / NICKNAME', 'e.g. Big Red', _nameController),
                    const SizedBox(height: 16),
                    _buildTextField('NUMBER PLATE *', 'e.g. TN-38 AK 4521', _numberPlateController),
                    const SizedBox(height: 16),
                    _buildTextField('RC NUMBER', 'Registration certificate number', _rcNumberController),
                    const SizedBox(height: 16),
                    const Text('VEHICLE PHOTOS (Up to 4)', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (int index = 0; index < 4; index++) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: index == _selectedImages.length ? _showImageSourceDialog : null,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface, // Dark background
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: index == _selectedImages.length ? Colors.white30 : Colors.white10,
                                      width: 1.0, // Uniform width
                                    ),
                                  ),
                                  child: index < _selectedImages.length
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : index == _selectedImages.length
                                          ? const Center(
                                              child: Icon(Icons.add_a_photo_outlined, color: Colors.white54, size: 24),
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ),
                          if (index < 3) const SizedBox(width: 12),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isFormValid && !_isLoading) ? _addVehicle : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        'Add Vehicle',
                        style: TextStyle(
                          color: _isFormValid ? Colors.white : Colors.white54, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface, // Dark background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _typeController.dispose();
    _manufacturerController.dispose();
    _capacityController.dispose();
    _nameController.dispose();
    _numberPlateController.dispose();
    _rcNumberController.dispose();
    super.dispose();
  }
}
