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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wageController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  bool _canUpdateTasks = true;
  bool _canUploadPhotos = true;
  bool _canRequestMaterials = true;

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
      _canUpdateTasks = w.permissions['canUpdateTasks'] ?? true;
      _canUploadPhotos = w.permissions['canUploadPhotos'] ?? true;
      _canRequestMaterials = w.permissions['canRequestMaterials'] ?? true;
      // We are skipping loading profile image from URL for simplicity in edit mode
    }
  }

  @override
  void dispose() {
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
    // In a real app, you would request permissions and open the contact picker here.
    // For this prototype, we will simulate picking a contact.
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

  void _onSave() {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Phone are required.')),
      );
      return;
    }

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
        'canUpdateTasks': _canUpdateTasks,
        'canUploadPhotos': _canUploadPhotos,
        'canRequestMaterials': _canRequestMaterials,
      },
      assignedProjectIds: widget.workerToEdit?.assignedProjectIds ?? [],
      // In a real app, upload _profileImage to server and get URL
      profileImageUrl: widget.workerToEdit?.profileImageUrl,
    );

    if (widget.workerToEdit == null) {
      WorkerService().addWorker(worker);
    } else {
      WorkerService().updateWorker(worker);
    }

    Navigator.of(context).pop();
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
      child: SingleChildScrollView(
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
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'PHONE NUMBER',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
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

            CustomFormField(
              label: 'FULL NAME',
              isRequired: true,
              hint: 'e.g. Suresh Kannan',
              controller: _nameController,
              isDark: true,
            ),
            CustomFormField(
              label: 'ROLE',
              isRequired: true,
              hint: 'Select Role',
              isDropdown: true,
              isDark: true,
              dropdownValue: _selectedRole,
              dropdownItems: const ['Site Engineer', 'Project Manager', 'Supervisor', 'Architect', 'HR', 'Plumber', 'Electrician'],
              onDropdownChanged: (val) {
                setState(() {
                  _selectedRole = val;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormField(
                    label: 'PAY TYPE',
                    hint: 'Select',
                    isDropdown: true,
                    isDark: true,
                    dropdownValue: _selectedPayType,
                    dropdownItems: const ['Daily', 'Weekly', 'Monthly'],
                    onDropdownChanged: (val) {
                      setState(() {
                        _selectedPayType = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: CustomFormField(
                    label: '${_selectedPayType?.toUpperCase() ?? 'DAILY'} WAGE (₹)',
                    hint: 'e.g. 800',
                    controller: _wageController,
                    isDark: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomFormField(
                    label: 'ID PROOF',
                    hint: 'Type',
                    isDropdown: true,
                    isDark: true,
                    dropdownValue: _selectedIdType,
                    dropdownItems: const ['Aadhar', 'PAN', 'Voter ID', 'Driving License'],
                    onDropdownChanged: (val) {
                      setState(() {
                        _selectedIdType = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: CustomFormField(
                    label: 'ID NUMBER',
                    hint: 'e.g. XXXX-XXXX',
                    controller: _idNumberController,
                    isDark: true,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomFormField(
                    label: 'STATE',
                    hint: 'e.g. Tamil Nadu',
                    controller: _stateController,
                    isDark: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: CustomFormField(
                    label: 'CITY',
                    hint: 'e.g. Chennai',
                    controller: _cityController,
                    isDark: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Permissions Section
            const Text(
              'PORTAL PERMISSIONS',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Update Daily Tasks', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Can mark assigned tasks as complete/blocked', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: _canUpdateTasks,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _canUpdateTasks = val),
                  ),
                  const Divider(color: Color(0xFF334155), height: 1),
                  SwitchListTile(
                    title: const Text('Upload Site Photos', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Can upload and share progress photos', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: _canUploadPhotos,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _canUploadPhotos = val),
                  ),
                  const Divider(color: Color(0xFF334155), height: 1),
                  SwitchListTile(
                    title: const Text('Request Materials', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Can raise indents for warehouse materials', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    value: _canRequestMaterials,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _canRequestMaterials = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  widget.workerToEdit == null ? 'Add Now' : 'Save Changes',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
