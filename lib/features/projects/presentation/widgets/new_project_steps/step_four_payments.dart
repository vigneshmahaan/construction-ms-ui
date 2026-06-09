import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class PaymentStage {
  TextEditingController nameController;
  TextEditingController amountController;

  PaymentStage({String name = '', String amount = ''})
      : nameController = TextEditingController(text: name),
        amountController = TextEditingController(text: amount);

  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}

class StepFourPayments extends StatefulWidget {
  final TextEditingController budgetController;
  const StepFourPayments({super.key, required this.budgetController});

  @override
  State<StepFourPayments> createState() => _StepFourPaymentsState();
}

class _StepFourPaymentsState extends State<StepFourPayments> {
  final TextEditingController _advanceController = TextEditingController();
  final List<PaymentStage> _stages = [
    PaymentStage() // Initial empty stage
  ];

  @override
  void dispose() {
    _advanceController.dispose();
    for (var stage in _stages) {
      stage.dispose();
    }
    super.dispose();
  }

  void _addStage() {
    setState(() {
      _stages.add(PaymentStage());
    });
  }

  void _removeStage(int index) {
    setState(() {
      _stages[index].dispose();
      _stages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Section 4 - Payments',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          CustomFormField(
            label: 'TOTAL PROJECT VALUE (BUDGET) ₹',
            isRequired: true,
            hint: 'e.g. 24000000',
            controller: widget.budgetController,
          ),
          CustomFormField(
            label: 'ADVANCE RECEIVED ₹',
            hint: 'e.g. 500000',
            controller: _advanceController,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Installment Stages',
                style: TextStyle(
                  color: AppColors.background, // Dark text
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextButton.icon(
                onPressed: _addStage,
                icon: const Icon(Icons.add, color: AppColors.primary, size: 16),
                label: const Text(
                  'Add Stage',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stages.length,
            itemBuilder: (context, index) {
              final stage = _stages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: stage.nameController,
                        style: const TextStyle(color: AppColors.textDark, fontSize: 14),
                        decoration: _buildInputDecoration('Stage Name (e.g. Plinth)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: stage.amountController,
                        style: const TextStyle(color: AppColors.textDark, fontSize: 14),
                        decoration: _buildInputDecoration('₹ Amt'),
                      ),
                    ),
                    if (index > 0 || _stages.length > 1) // Allow deletion if it's not the only one
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: GestureDetector(
                          onTap: () => _removeStage(index),
                          child: const Icon(Icons.delete_outline, color: AppColors.error),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 100), // spacing for sticky bottom bar
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
