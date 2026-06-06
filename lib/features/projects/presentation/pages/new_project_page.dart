import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_one_project_details.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_two_client_details.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_three_team.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_four_payments.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_five_agreements.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/new_project_steps/step_six_preview.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({Key? key}) : super(key: key);

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  int _currentStep = 0;
  
  final List<String> _stepTitles = [
    'Project', 'Client', 'Team', 'Payments', 'Docs', 'Preview'
  ];

  final TextEditingController budgetController = TextEditingController();

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Finished
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
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
        const StepOneProjectDetails(),
        const StepTwoClientDetails(),
        const StepThreeTeamDetails(),
        StepFourPayments(budgetController: budgetController),
        const StepFiveAgreements(),
        StepSixPreview(budgetController: budgetController),
      ],
    );
  }

  Widget _buildComingSoonPlaceholder(int stepIndex) {
    return Center(
      child: Text(
        '${_stepTitles[stepIndex]} Configuration\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
      ),
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
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _currentStep == _stepTitles.length - 1 ? 'Publish Project' : 'Next',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
