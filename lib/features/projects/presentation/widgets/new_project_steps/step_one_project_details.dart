import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class StepOneProjectDetails extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController numFloorsController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final String? projectType;
  final String? houseType;
  final Function(String?) onProjectTypeChanged;
  final Function(String?) onHouseTypeChanged;
  final List<XFile> selectedImages;
  final Function(List<XFile>) onImagesSelected;
  final Function(int) onImageRemoved;

  const StepOneProjectDetails({
    super.key, 
    required this.nameController, 
    required this.addressController,
    required this.numFloorsController,
    required this.startDateController,
    required this.endDateController,
    required this.projectType,
    required this.houseType,
    required this.onProjectTypeChanged,
    required this.onHouseTypeChanged,
    required this.selectedImages,
    required this.onImagesSelected,
    required this.onImageRemoved,
  });

  @override
  State<StepOneProjectDetails> createState() => _StepOneProjectDetailsState();
}

class _StepOneProjectDetailsState extends State<StepOneProjectDetails> {
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        var status = await Permission.camera.request();
        if (status.isPermanentlyDenied) {
          openAppSettings();
          return;
        }
      } else if (Platform.isAndroid || Platform.isIOS) {
        // Just request photos, ignore result as some OS versions don't strictly require it for the new photo picker
        await Permission.photos.request();
      }

      if (source == ImageSource.gallery) {
        final List<XFile> pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
          widget.onImagesSelected(pickedFiles);
        }
      } else {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          widget.onImagesSelected([pickedFile]);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    widget.onImageRemoved(index);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Section 1 - Project Details',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          CustomFormField(
            label: 'Project Name',
            isRequired: true,
            hint: 'e.g. Sunrise Villa Phase 3',
            controller: widget.nameController,
          ),
          CustomFormField(
            label: 'Project Type',
            isRequired: true,
            hint: 'Select Project Type',
            isDropdown: true,
            dropdownValue: widget.projectType,
            dropdownItems: const ['Commercial', 'Residential', 'Interiors', 'Design'],
            onDropdownChanged: widget.onProjectTypeChanged,
          ),
          CustomFormField(
            label: 'House Type',
            isRequired: true,
            hint: 'Select House Type',
            isDropdown: true,
            dropdownValue: widget.houseType,
            dropdownItems: const ['Simplex', 'Duplex', 'Triplex', 'Others'],
            onDropdownChanged: widget.onHouseTypeChanged,
          ),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  label: 'No. of Floors',
                  hint: 'e.g. 5',
                  controller: widget.numFloorsController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Start Date',
                  isRequired: true,
                  hint: 'dd-mm-yyyy',
                  controller: widget.startDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, widget.startDateController),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black87),
                ),
              ),
            ],
          ),
          CustomFormField(
            label: 'End Date',
            isRequired: true,
            hint: 'dd-mm-yyyy',
            controller: widget.endDateController,
            readOnly: true,
            onTap: () => _selectDate(context, widget.endDateController),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black87),
          ),
          CustomFormField(
            label: 'Project Address',
            isRequired: true,
            hint: 'Full site address',
            controller: widget.addressController,
          ),
          Row(
            children: const [
              Expanded(
                child: CustomFormField(
                  label: 'Latitude',
                  hint: '11.0168',
                  suffixIcon: Icon(Icons.my_location, size: 18, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Longitude',
                  hint: '76.9558',
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'PROJECT PHOTOS',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (widget.selectedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(widget.selectedImages.length, (index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(widget.selectedImages[index].path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeImage(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library, color: AppColors.primary),
                            title: const Text('Select image from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                            title: const Text('Take photo with Camera'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.image_outlined, size: 40, color: Color(0xFF94A3B8)),
                  SizedBox(height: 12),
                  Text(
                    'Tap to upload photos',
                    style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Gallery or Camera',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }
}
