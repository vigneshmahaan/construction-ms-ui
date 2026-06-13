import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class StepTwoClientDetails extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;

  const StepTwoClientDetails({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Section 2 - Client Details',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          CustomFormField(
            label: 'Client Name',
            isRequired: true,
            hint: 'e.g. Arun Kumar',
            controller: nameController,
          ),
          CustomFormField(
            label: 'Phone Number',
            isRequired: true,
            hint: 'e.g. 9876543210',
            controller: phoneController,
          ),
          CustomFormField(
            label: 'Email Address',
            hint: 'client@example.com',
            controller: emailController,
          ),
          CustomFormField(
            label: 'Current Address',
            hint: "Client's residential address",
            controller: addressController,
          ),
          const SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }
}
