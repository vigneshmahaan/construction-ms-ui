import 'package:flutter/material.dart';
import 'package:construction_ms_ui/shared/models/user_role.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/features/home/presentation/pages/home_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_home_page.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/worker_home_page.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/site_engineer_home_page.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/project_manager_home_page.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/supervisor_home_page.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:construction_ms_ui/shared/models/worker_role.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserRole _selectedRole = UserRole.admin;
  WorkerRole _selectedWorkerRole = WorkerRole.siteEngineer;
  bool _isOtpSent = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _onGetOtp() {
    setState(() {
      _isOtpSent = true;
    });
  }

  void _onSignIn() async {
    await AuthService.saveRole(_selectedRole);
    if (!mounted) return;

    Widget destination;
    switch (_selectedRole) {
      case UserRole.admin:
        destination = const HomePage();
        break;
      case UserRole.client:
        destination = const ClientHomePage();
        break;
      case UserRole.worker:
        switch (_selectedWorkerRole) {
          case WorkerRole.siteEngineer:
          case WorkerRole.projectManager:
          case WorkerRole.supervisor:
            destination = const SupervisorHomePage();
            break;
        }
        break;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              _buildLogo(),
              const SizedBox(height: 24),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to manage your construction projects',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 36),

              // ── Role Selector ──
              _buildRoleSelector(),
              if (_selectedRole == UserRole.worker) ...[
                const SizedBox(height: 16),
                _buildWorkerRoleSelector(),
              ],
              const SizedBox(height: 32),

              _buildPhoneField(),
              if (_isOtpSent) ...[
                const SizedBox(height: 16),
                _buildOtpField(),
              ],
              const SizedBox(height: 32),
              _buildActionBtn(),
              const SizedBox(height: 20),
              _buildSignUpRow(),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF06B6D4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Icon(Icons.bar_chart, color: Colors.white, size: 36),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CompleteProfilePage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF06B6D4),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ── Role Selector Widget ──
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SIGN IN AS',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRoleTile(
              role: UserRole.admin,
              icon: Icons.manage_accounts_rounded,
              label: 'Admin',
              color: const Color(0xFF06B6D4),
            ),
            const SizedBox(width: 10),
            _buildRoleTile(
              role: UserRole.client,
              icon: Icons.person_rounded,
              label: 'Client',
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(width: 10),
            _buildRoleTile(
              role: UserRole.worker,
              icon: Icons.construction_rounded,
              label: 'Worker',
              color: const Color(0xFF10B981),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkerRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SPECIFIC ROLE',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<WorkerRole>(
              value: _selectedWorkerRole,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E293B),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
              items: WorkerRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(
                    role.label,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedWorkerRole = val;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleTile({
    required UserRole role,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedRole = role;
          _isOtpSent = false;
          _phoneController.clear();
          _otpController.clear();
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? color : Colors.white38, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.white38,
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PHONE NUMBER',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '+91',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  enabled: !_isOtpSent,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                    hintStyle:
                        TextStyle(color: Colors.white24, fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OTP',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            controller: _otpController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter OTP (e.g. 1234)',
              hintStyle: TextStyle(color: Colors.white24, fontSize: 16),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn() {
    Color roleColor;
    switch (_selectedRole) {
      case UserRole.admin:
        roleColor = const Color(0xFF06B6D4);
        break;
      case UserRole.client:
        roleColor = const Color(0xFF3B82F6);
        break;
      case UserRole.worker:
        roleColor = const Color(0xFF10B981);
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: _isOtpSent ? _onSignIn : _onGetOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: roleColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isOtpSent ? 'Sign In' : 'Get OTP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isOtpSent) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward,
                    color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
