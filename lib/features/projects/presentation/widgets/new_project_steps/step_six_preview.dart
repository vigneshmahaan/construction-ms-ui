import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_three_team.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_four_payments.dart';

class StepSixPreview extends StatelessWidget {
  final String name;
  final String address;
  final String projectType;
  final String houseType;
  final String numFloors;
  final String startDate;
  final String endDate;
  final String budget;
  final String advance;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String clientAddress;
  final List<TeamMember> teamMembers;
  final List<PaymentStage> installments;
  final String notes;
  final List<String> agreements;

  const StepSixPreview({
    super.key, 
    required this.name,
    required this.address,
    required this.projectType,
    required this.houseType,
    required this.numFloors,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.advance,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.clientAddress,
    required this.teamMembers,
    required this.installments,
    required this.notes,
    required this.agreements,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Section 6 - Preview & Publish',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Untitled Project',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Project Details'),
                _buildInfoRow('Address:', address),
                _buildInfoRow('Type:', '$projectType / $houseType'),
                _buildInfoRow('Floors:', numFloors.isNotEmpty ? numFloors : 'N/A'),
                _buildInfoRow('Timeline:', '$startDate to $endDate'),
                
                const SizedBox(height: 16),
                _buildSectionHeader('Client Details'),
                _buildInfoRow('Name:', clientName.isNotEmpty ? clientName : 'Unknown Client'),
                _buildInfoRow('Phone:', clientPhone.isNotEmpty ? clientPhone : 'N/A'),
                _buildInfoRow('Email:', clientEmail.isNotEmpty ? clientEmail : 'N/A'),
                _buildInfoRow('Address:', clientAddress.isNotEmpty ? clientAddress : 'N/A'),

                const SizedBox(height: 16),
                _buildSectionHeader('Financials'),
                _buildInfoRow('Budget:', budget.isNotEmpty ? '₹$budget' : '₹0'),
                _buildInfoRow('Advance:', advance.isNotEmpty ? '₹$advance' : '₹0'),
                if (installments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Installments:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                  ...installments.map((inst) => Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text('- ${inst.nameController.text}: ₹${inst.amountController.text}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  )).toList()
                ],

                const SizedBox(height: 16),
                _buildSectionHeader('Team Assigned'),
                _buildInfoRow('Members:', teamMembers.isNotEmpty ? teamMembers.map((m) => '${m.name} (${m.role})').join(', ') : 'None assigned'),

                const SizedBox(height: 16),
                _buildSectionHeader('Agreements & Notes'),
                if (agreements.isNotEmpty) ...[
                  const Text('Files:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                  ...agreements.map((file) => Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text('- $file', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  )).toList(),
                  const SizedBox(height: 8),
                ],
                _buildInfoRow('Notes:', notes.isNotEmpty ? notes : 'None'),

                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),
                const Text(
                  'Please review the details above. Click Publish Project to submit.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
