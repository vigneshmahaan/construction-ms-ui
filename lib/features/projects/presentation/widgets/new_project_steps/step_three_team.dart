import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';

class TeamMember {
  final String phone;
  final String name;
  final String role;
  final String payType;
  final String payAmount;

  TeamMember({
    required this.phone,
    required this.name,
    required this.role,
    this.payType = '',
    this.payAmount = '',
  });
}

class StepThreeTeamDetails extends StatefulWidget {
  const StepThreeTeamDetails({Key? key}) : super(key: key);

  @override
  State<StepThreeTeamDetails> createState() => _StepThreeTeamDetailsState();
}

class _StepThreeTeamDetailsState extends State<StepThreeTeamDetails> {
  final List<TeamMember> _teamMembers = [];

  void _showAssignMemberSheet() {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    final payAmountController = TextEditingController();
    String? selectedRole = 'Site Engineer';
    String? selectedPayType = 'Monthly Salary';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                        const Text(
                          'Assign Team Member',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      label: 'PHONE NUMBER',
                      isRequired: true,
                      hint: 'Worker\'s phone number',
                      controller: phoneController,
                      isDark: true,
                      // Note: you could prefix +91 via the controller or a prefix icon, for simplicity using hint
                    ),
                    CustomFormField(
                      label: 'FULL NAME',
                      isRequired: true,
                      hint: 'e.g. Suresh Kannan',
                      controller: nameController,
                      isDark: true,
                    ),
                    CustomFormField(
                      label: 'ASSIGN ROLE',
                      isRequired: true,
                      hint: 'Select Role',
                      isDropdown: true,
                      isDark: true,
                      dropdownValue: selectedRole,
                      dropdownItems: const ['Site Engineer', 'Project Manager', 'Supervisor', 'Architect'],
                      onDropdownChanged: (val) {
                        setSheetState(() {
                          selectedRole = val;
                        });
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'PAY STRUCTURE (OPTIONAL)',
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
                          child: DropdownButtonFormField<String>(
                            value: selectedPayType,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 20),
                            dropdownColor: const Color(0xFF1E293B),
                            decoration: _buildDarkInputDecoration(),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            items: const ['Monthly Salary', 'Daily Wages', 'Contract'].map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setSheetState(() {
                                selectedPayType = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: payAmountController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: _buildDarkInputDecoration().copyWith(
                              hintText: '₹ Amount',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (phoneController.text.isNotEmpty && nameController.text.isNotEmpty) {
                            setState(() {
                              _teamMembers.add(TeamMember(
                                phone: phoneController.text,
                                name: nameController.text,
                                role: selectedRole ?? 'Site Engineer',
                                payType: selectedPayType ?? '',
                                payAmount: payAmountController.text,
                              ));
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Assign to Project',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _buildDarkInputDecoration() {
    return InputDecoration(
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF1E293B), // Dark input background
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Section 3 - Team',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton.icon(
                onPressed: _showAssignMemberSheet,
                icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
                label: const Text(
                  'Assign',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_teamMembers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Text(
                'Click "+ Assign" to add team members to this project.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _teamMembers.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFFE2E8F0)),
              itemBuilder: (context, index) {
                final member = _teamMembers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 24,
                        child: Text(
                          member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.role,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+91 ${member.phone}',
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                    ),
                                  ],
                                ),
                                if (member.payAmount.isNotEmpty)
                                  Text(
                                    '${member.payType}: ₹${member.payAmount}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () {
                          setState(() {
                            _teamMembers.removeAt(index);
                          });
                        },
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
}
