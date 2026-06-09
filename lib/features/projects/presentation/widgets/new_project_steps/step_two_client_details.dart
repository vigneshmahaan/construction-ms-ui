import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class StepTwoClientDetails extends StatelessWidget {
  const StepTwoClientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Section 2 - Client Details',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 24),
          CustomFormField(
            label: 'Client Name',
            isRequired: true,
            hint: 'e.g. Arun Kumar',
          ),
          CustomFormField(
            label: 'Phone Number',
            isRequired: true,
            hint: 'e.g. 9876543210',
          ),
          CustomFormField(
            label: 'Email Address',
            hint: 'client@example.com',
          ),
          CustomFormField(
            label: 'Current Address',
            hint: "Client's residential address",
          ),
          SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }
}
