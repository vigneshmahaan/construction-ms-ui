import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:construction_ms_ui/shared/models/user_role.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/features/home/presentation/pages/home_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_home_page.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  // Role selection — Admin and Client only (Workers are created by Admin)
  UserRole _selectedRole = UserRole.admin;

  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _companyCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();

  bool _isFormValid = false;
  bool _isOtpSent = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl.addListener(_validateForm);
    _emailCtrl.addListener(_validateForm);
    _usernameCtrl.addListener(_validateForm);
    _companyCtrl.addListener(_validateForm);
    _phoneCtrl.addListener(_validateForm);
    _otpCtrl.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _fullNameCtrl.text.trim().isNotEmpty &&
        _emailCtrl.text.trim().isNotEmpty &&
        _usernameCtrl.text.trim().isNotEmpty &&
        _companyCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _otpCtrl.text.trim().isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _startResendTimer() {
    setState(() {
      _isOtpSent = true;
      _resendTimer = 30;
    });

    // Mocking OTP receipt
    _otpCtrl.text = '123456';
    _validateForm();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _companyCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (!_isFormValid) return;

    await AuthService.completeSetup(_selectedRole);

    if (!mounted) return;

    Widget destination;
    switch (_selectedRole) {
      case UserRole.admin:
        destination = const HomePage();
        break;
      case UserRole.client:
        destination = const ClientHomePage();
        break;
      default:
        destination = const HomePage();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF0F172A),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: const Text.rich(
                TextSpan(
                  text: 'Aatzy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Build',
                      style: TextStyle(color: Color(0xFF06B6D4)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tell us a bit about yourself to get started',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Role Selector ──
                      _buildRoleSelector(),
                      const SizedBox(height: 28),

                      // ── Form Fields ──
                      _buildInputField('Full Name', _fullNameCtrl),
                      const SizedBox(height: 16),
                      _buildInputField('Email Address', _emailCtrl,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildInputField('Username', _usernameCtrl),
                      const SizedBox(height: 16),
                      _buildInputField(
                        _selectedRole == UserRole.client
                            ? 'Company / Organisation Name'
                            : 'Company Name',
                        _companyCtrl,
                      ),
                      const SizedBox(height: 16),
                      _buildPhoneField(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isOtpSent && _resendTimer > 0
                            ? Text(
                                'Resend OTP in 00:${_resendTimer.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              )
                            : TextButton(
                                onPressed: _startResendTimer,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _isOtpSent ? 'Resend OTP' : 'Get OTP',
                                  style: const TextStyle(
                                    color: Color(0xFF06B6D4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      if (_isOtpSent) ...[
                        const SizedBox(height: 16),
                        _buildInputField('OTP', _otpCtrl,
                            keyboardType: TextInputType.number),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // ── Continue Button (pinned to bottom) ──
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedRole == UserRole.admin
                        ? const Color(0xFF06B6D4)
                        : const Color(0xFF3B82F6),
                    disabledBackgroundColor:
                        const Color(0xFF06B6D4).withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue as ${_selectedRole.label}',
                    style: TextStyle(
                      color: _isFormValid ? Colors.white : Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFF06B6D4),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Role Selector — Admin & Client only ──
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I AM REGISTERING AS',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRoleCard(
                role: UserRole.admin,
                icon: Icons.manage_accounts_rounded,
                title: 'Admin',
                subtitle: 'Manage projects, workers & operations',
                color: const Color(0xFF06B6D4),
              ),
              const SizedBox(width: 12),
              _buildRoleCard(
                role: UserRole.client,
                icon: Icons.person_rounded,
                title: 'Client',
                subtitle: 'Track your project progress',
                color: const Color(0xFF3B82F6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Subtle hint about Worker
        Row(
          children: [
            Icon(Icons.info_outline_rounded,
                color: Colors.white24, size: 14),
            const SizedBox(width: 6),
            const Text(
              'Worker accounts are created by Admin',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon,
                    color: isSelected ? color : Colors.white38, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? color : Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              // Selection indicator
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 16 : 12,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.5) : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 16),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Text(
                  '+91',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.white54, size: 16),
              ],
            ),
          ),
          Container(width: 1, height: 24, color: Colors.white10),
          Expanded(
            child: TextField(
              controller: _phoneCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '000000000',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 16),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
