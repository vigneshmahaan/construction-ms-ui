import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/shared/models/worker.dart';
import 'package:construction_ms_ui/shared/services/worker_service.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class AddWorkerSheet extends StatefulWidget {
  final Worker? workerToEdit;

  const AddWorkerSheet({super.key, this.workerToEdit});

  @override
  State<AddWorkerSheet> createState() => _AddWorkerSheetState();
}

class _AddWorkerSheetState extends State<AddWorkerSheet> {
  final _pageController = PageController();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wageController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  // Permission Toggles
  bool _warehouse = false;
  bool _materialIndent = false;
  bool _purchaseOrders = false;
  bool _stocksHub = false;
  bool _logistics = false;
  bool _vehicles = false;
  bool _vendors = false;
  bool _centralizedAttendance = false;

  String? _selectedRole = 'Site Engineer';
  String? _selectedPayType = 'Daily';
  String? _selectedIdType = 'Aadhar';
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.workerToEdit != null) {
      final w = widget.workerToEdit!;
      _nameController.text = w.name;
      _phoneController.text = w.phone;
      _wageController.text = w.wageAmount;
      _idNumberController.text = w.idProofNumber;
      _selectedRole = w.role;
      _selectedPayType = w.payType;
      _selectedIdType = w.idProofType;
      _stateController.text = w.state;
      _cityController.text = w.city;
      
      _warehouse = w.permissions['warehouse'] ?? false;
      _materialIndent = w.permissions['material_indent'] ?? false;
      _purchaseOrders = w.permissions['purchase_orders'] ?? false;
      _stocksHub = w.permissions['stocks_hub'] ?? false;
      _logistics = w.permissions['logistics'] ?? false;
      _vehicles = w.permissions['vehicles'] ?? false;
      _vendors = w.permissions['vendors'] ?? false;
      _centralizedAttendance = w.permissions['centralized_attendance'] ?? false;
    }
    
    _nameController.addListener(_validateStep1);
    _phoneController.addListener(_validateStep1);
    _validateStep1();
  }

  bool _isStep1Valid = false;
  bool _isLoading = false;

  void _validateStep1() {
    final isValid = _nameController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty;
    if (_isStep1Valid != isValid) {
      setState(() => _isStep1Valid = isValid);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _wageController.dispose();
    _idNumberController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text('Take a photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Choose from gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickContact() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Pick Contact', style: TextStyle(color: Colors.white)),
        content: const Text('This will open the native contacts app to select a worker\'s phone number.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _nameController.text = 'John Doe (from Contacts)';
                _phoneController.text = '9876543210';
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Simulate Selection', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onNext() {
    if (!_isStep1Valid) return;
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _currentStep = 1);
  }

  void _onSave() {
    final worker = Worker(
      id: widget.workerToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole ?? 'Site Engineer',
      payType: _selectedPayType ?? 'Daily',
      wageAmount: _wageController.text.trim(),
      idProofType: _selectedIdType ?? 'Aadhar',
      idProofNumber: _idNumberController.text.trim(),
      state: _stateController.text.trim(),
      city: _cityController.text.trim(),
      permissions: {
        'warehouse': _warehouse,
        'material_indent': _materialIndent,
        'purchase_orders': _purchaseOrders,
        'stocks_hub': _stocksHub,
        'logistics': _logistics,
        'vehicles': _vehicles,
        'vendors': _vendors,
        'centralized_attendance': _centralizedAttendance,
      },
      assignedProjectIds: widget.workerToEdit?.assignedProjectIds ?? [],
      profileImageUrl: widget.workerToEdit?.profileImageUrl,
    );

    setState(() => _isLoading = true);
    try {
      if (widget.workerToEdit == null) {
        // In reality, this would be an API call
        WorkerService().addWorker(worker);
      } else {
        WorkerService().updateWorker(worker);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Worker saved successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save worker: $e'), backgroundColor: Colors.red),
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
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep == 1)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    setState(() => _currentStep = 0);
                  },
                )
              else
                const SizedBox(width: 48), // Placeholder to balance close button

              Text(
                widget.workerToEdit == null ? 'Add New Worker' : 'Edit Worker',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 30, height: 4, decoration: BoxDecoration(color: _currentStep == 0 ? AppColors.primary : Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Container(width: 30, height: 4, decoration: BoxDecoration(color: _currentStep == 1 ? AppColors.primary : Colors.white24, borderRadius: BorderRadius.circular(2))),
            ],
          ),
          const SizedBox(height: 16),

          // Use Expanded so PageView can be bounded inside the bottom sheet safely.
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Image Picker
          Center(
            child: GestureDetector(
              onTap: _showImagePickerOptions,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF1E293B),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) as ImageProvider
                        : (widget.workerToEdit?.profileImageUrl != null
                            ? NetworkImage(widget.workerToEdit!.profileImageUrl!)
                            : null),
                    child: (_profileImage == null && widget.workerToEdit?.profileImageUrl == null)
                        ? const Icon(Icons.person, size: 45, color: Colors.white38)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Phone number with contact picker
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'PHONE NUMBER',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Worker\'s phone number',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _pickContact,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.contacts, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomFormField(label: 'FULL NAME', isRequired: true, hint: 'e.g. Suresh Kannan', controller: _nameController, isDark: true),
          CustomFormField(
            label: 'ROLE', isRequired: true, hint: 'Select Role', isDropdown: true, isDark: true, dropdownValue: _selectedRole,
            dropdownItems: const ['Site Engineer', 'Project Manager', 'Supervisor', 'Architect', 'HR', 'Plumber', 'Electrician'],
            onDropdownChanged: (val) => setState(() => _selectedRole = val),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomFormField(
                  label: 'PAY TYPE', hint: 'Select', isDropdown: true, isDark: true, dropdownValue: _selectedPayType,
                  dropdownItems: const ['Daily', 'Weekly', 'Monthly'],
                  onDropdownChanged: (val) => setState(() => _selectedPayType = val),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: CustomFormField(label: '${_selectedPayType?.toUpperCase() ?? 'DAILY'} WAGE (₹)', hint: 'e.g. 800', controller: _wageController, isDark: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomFormField(
                  label: 'ID PROOF', hint: 'Type', isDropdown: true, isDark: true, dropdownValue: _selectedIdType,
                  dropdownItems: const ['Aadhar', 'PAN', 'Voter ID', 'Driving License'],
                  onDropdownChanged: (val) => setState(() => _selectedIdType = val),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: CustomFormField(label: 'ID NUMBER', hint: 'e.g. XXXX-XXXX', controller: _idNumberController, isDark: true),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 1, child: CustomFormField(label: 'STATE', hint: 'e.g. Tamil Nadu', controller: _stateController, isDark: true)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: CustomFormField(label: 'CITY', hint: 'e.g. Chennai', controller: _cityController, isDark: true)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isStep1Valid ? _onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Next', 
                style: TextStyle(
                  color: _isStep1Valid ? Colors.white : Colors.white54, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portal Permissions',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Turn ON to allow editing. Turn OFF to make it read-only.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                _buildToggle('Warehouse', _warehouse, (v) => setState(() => _warehouse = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Material Indent', _materialIndent, (v) => setState(() => _materialIndent = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Purchase Orders', _purchaseOrders, (v) => setState(() => _purchaseOrders = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Stocks Hub', _stocksHub, (v) => setState(() => _stocksHub = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Logistics', _logistics, (v) => setState(() => _logistics = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Vehicles', _vehicles, (v) => setState(() => _vehicles = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Vendors', _vendors, (v) => setState(() => _vendors = v)),
                const Divider(color: Color(0xFF334155), height: 1),
                _buildToggle('Centralized Attendance', _centralizedAttendance, (v) => setState(() => _centralizedAttendance = v)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    widget.workerToEdit == null ? 'Save Worker' : 'Save Changes',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: Text(value ? 'Can Edit' : 'Read-Only', style: TextStyle(color: value ? AppColors.primary : Colors.white54, fontSize: 11)),
      value: value,
      activeColor: AppColors.primary,
      onChanged: onChanged,
    );
  }
}
