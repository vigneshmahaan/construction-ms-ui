import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_one_project_details.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_two_client_details.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_three_team.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_four_payments.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_five_agreements.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_six_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  int _currentStep = 0;
  bool _isStepValid = false;
  bool _isLoading = false;
  
  final List<String> _stepTitles = [
    'Project', 'Client', 'Team', 'Payments', 'Docs', 'Preview'
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numFloorsController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  String? projectType = 'Commercial';
  String? houseType = 'Simplex';
  List<XFile> selectedImages = [];
  
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientPhoneController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  final TextEditingController clientAddressController = TextEditingController();
  
  final List<TeamMember> teamMembers = [];

  final TextEditingController budgetController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final List<PaymentStage> stages = [PaymentStage()];

  final TextEditingController notesController = TextEditingController();
  final List<PlatformFile> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateCurrentStep);
    addressController.addListener(_validateCurrentStep);
    budgetController.addListener(_validateCurrentStep);
    clientNameController.addListener(_validateCurrentStep);
    clientPhoneController.addListener(_validateCurrentStep);
    _validateCurrentStep();
  }

  void _validateCurrentStep() {
    bool isValid = true;
    if (_currentStep == 0) {
      isValid = nameController.text.trim().isNotEmpty && addressController.text.trim().isNotEmpty;
    } else if (_currentStep == 1) {
      isValid = clientNameController.text.trim().isNotEmpty && clientPhoneController.text.trim().isNotEmpty;
    } else if (_currentStep == 3) {
      isValid = budgetController.text.trim().isNotEmpty;
    }
    
    if (_isStepValid != isValid) {
      setState(() => _isStepValid = isValid);
    }
  }

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    numFloorsController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    budgetController.dispose();
    advanceController.dispose();
    clientNameController.dispose();
    clientPhoneController.dispose();
    clientEmailController.dispose();
    clientAddressController.dispose();
    notesController.dispose();
    for (var stage in stages) {
      stage.dispose();
    }
    super.dispose();
  }

  void _nextStep() async {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _validateCurrentStep();
    } else {
      // Publish Project
      setState(() => _isLoading = true);
      try {
        final api = ApiService();
        final payload = {
          'name': nameController.text.trim(),
          'address': addressController.text.trim(),
          'projectType': projectType,
          'houseType': houseType,
          'numFloors': numFloorsController.text.trim(),
          'startDate': startDateController.text.trim(),
          'endDate': endDateController.text.trim(),
          'totalBudget': double.tryParse(budgetController.text.trim()) ?? 0,
          'advanceReceived': double.tryParse(advanceController.text.trim()) ?? 0,
          'clientName': clientNameController.text.trim(),
          'clientPhone': clientPhoneController.text.trim(),
          'clientEmail': clientEmailController.text.trim(),
          'clientAddress': clientAddressController.text.trim(),
          'notes': notesController.text.trim(),
          'agreements': selectedFiles.map((e) => e.name).toList(),
          'installments': stages.map((e) => {
            'name': e.nameController.text.trim(),
            'amount': e.amountController.text.trim(),
          }).toList(),
          'team': teamMembers.map((e) => {
            'name': e.name,
            'phone': e.phone,
            'role': e.role,
            'payType': e.payType,
            'payAmount': e.payAmount,
          }).toList(),
        };
        
        final response = await api.post('/projects', payload);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project created successfully!'), backgroundColor: Colors.green),
          );
          
          if (response != null && response is Map<String, dynamic>) {
             Navigator.of(context).pop(response);
          } else {
             Navigator.of(context).pop();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create project: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _validateCurrentStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Project',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: _buildStepContent(),
              ),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_stepTitles.length * 2 - 1, (index) {
          if (index % 2 != 0) {
            // Dash separator
            return Container(
              width: 12,
              height: 2,
              color: const Color(0xFF1E293B), // Dark slate
            );
          }
          
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < _currentStep;
          final isActive = stepIndex == _currentStep;
          
          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isCompleted || isActive) ? AppColors.primary : const Color(0xFF1E293B),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    color: (isCompleted || isActive) ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _stepTitles[stepIndex],
                style: TextStyle(
                  color: (isCompleted || isActive) ? AppColors.primary : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    return IndexedStack(
      index: _currentStep,
      children: [
        StepOneProjectDetails(
          nameController: nameController,
          addressController: addressController,
          numFloorsController: numFloorsController,
          startDateController: startDateController,
          endDateController: endDateController,
          projectType: projectType,
          houseType: houseType,
          onProjectTypeChanged: (val) => setState(() => projectType = val),
          onHouseTypeChanged: (val) => setState(() => houseType = val),
          selectedImages: selectedImages,
          onImagesSelected: (files) => setState(() => selectedImages.addAll(files)),
          onImageRemoved: (index) => setState(() => selectedImages.removeAt(index)),
        ),
        StepTwoClientDetails(
          nameController: clientNameController,
          phoneController: clientPhoneController,
          emailController: clientEmailController,
          addressController: clientAddressController,
        ),
        StepThreeTeamDetails(teamMembers: teamMembers),
        StepFourPayments(
          budgetController: budgetController,
          advanceController: advanceController,
          stages: stages,
          onAddStage: () => setState(() => stages.add(PaymentStage())),
          onRemoveStage: (index) {
            setState(() {
              stages[index].dispose();
              stages.removeAt(index);
            });
          },
        ),
        StepFiveAgreements(
          notesController: notesController,
          selectedFiles: selectedFiles,
          onPickFiles: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg'],
              );
              if (result != null) {
                setState(() => selectedFiles.addAll(result.files));
              }
            } catch (e) {
              debugPrint("Error picking files: $e");
            }
          },
          onRemoveFile: (index) => setState(() => selectedFiles.removeAt(index)),
        ),
        StepSixPreview(
          name: nameController.text,
          address: addressController.text,
          projectType: projectType ?? '',
          houseType: houseType ?? '',
          numFloors: numFloorsController.text,
          startDate: startDateController.text,
          endDate: endDateController.text,
          budget: budgetController.text,
          advance: advanceController.text,
          clientName: clientNameController.text,
          clientPhone: clientPhoneController.text,
          clientEmail: clientEmailController.text,
          clientAddress: clientAddressController.text,
          teamMembers: teamMembers,
          installments: stages,
          notes: notesController.text,
          agreements: selectedFiles.map((e) => e.name).toList(),
        ),
      ],
    );
  }


  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: (_isStepValid && !_isLoading) ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        _currentStep == _stepTitles.length - 1 ? 'Publish Project' : 'Next',
                        style: TextStyle(
                          color: _isStepValid ? Colors.white : Colors.white54, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
