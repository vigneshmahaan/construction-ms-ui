import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_ms_ui/shared/models/user_role.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/features/home/presentation/pages/home_page.dart';
import 'package:construction_ms_ui/features/client_portal/presentation/pages/client_home_page.dart';
import 'package:construction_ms_ui/features/auth/presentation/pages/login_page.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';
import 'package:construction_ms_ui/shared/utils/ui_utils.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int _currentStep = 0; // 0: Personal Info, 1: Company Details
  UserRole _selectedRole = UserRole.admin;

  // Step 1: Personal Info
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  File? _profileImage;

  // Step 2: Company Info
  final TextEditingController _companyCtrl = TextEditingController();
  final TextEditingController _estYearCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _stateCtrl = TextEditingController();
  final TextEditingController _companyAddressCtrl = TextEditingController();
  final TextEditingController _gstCtrl = TextEditingController();
  final TextEditingController _panCtrl = TextEditingController();
  final TextEditingController _companyPhoneCtrl = TextEditingController();
  final TextEditingController _companyEmailCtrl = TextEditingController();
  final TextEditingController _websiteCtrl = TextEditingController();
  File? _companyLogo;

  final ImagePicker _picker = ImagePicker();

  bool _isStep1Valid = false;
  bool _isStep2Valid = false;
  bool _isOtpSent = false;
  int _resendTimer = 30;
  Timer? _timer;
  Timer? _debounce;
  String? _usernameError;
  List<String> _usernameSuggestions = [];

  @override
  void initState() {
    super.initState();
    _fullNameCtrl.addListener(_validateForm);
    _emailCtrl.addListener(_validateForm);
    _usernameCtrl.addListener(() {
      _validateForm();
      _onUsernameChanged();
    });
    _phoneCtrl.addListener(_validateForm);
    _otpCtrl.addListener(_validateForm);

    _companyCtrl.addListener(_validateForm);
    _estYearCtrl.addListener(_validateForm);
    _cityCtrl.addListener(_validateForm);
    _stateCtrl.addListener(_validateForm);
    _companyAddressCtrl.addListener(_validateForm);
    _gstCtrl.addListener(_validateForm);
    _panCtrl.addListener(_validateForm);
    _companyPhoneCtrl.addListener(_validateForm);
    _companyEmailCtrl.addListener(_validateForm);
    _websiteCtrl.addListener(_validateForm);

    // Mock OTP
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
    _debounce?.cancel();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();

    _companyCtrl.dispose();
    _estYearCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _companyAddressCtrl.dispose();
    _gstCtrl.dispose();
    _panCtrl.dispose();
    _companyPhoneCtrl.dispose();
    _companyEmailCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isCompany) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isCompany) {
          _companyLogo = File(image.path);
        } else {
          _profileImage = File(image.path);
        }
      });
    }
  }

  void _onUsernameChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkUsername();
    });
  }

  Future<void> _checkUsername() async {
    final username = _usernameCtrl.text.trim();
    if (username.isEmpty) {
      setState(() {
        _usernameError = null;
        _usernameSuggestions = [];
      });
      return;
    }

    try {
      final api = ApiService();
      final res = await api.post('/auth/check-username', {'username': username});
      if (res['exists'] == true) {
        setState(() {
          _usernameError = 'Username is already taken';
          if (res['suggestions'] != null) {
            _usernameSuggestions = List<String>.from(res['suggestions']);
          }
        });
      } else {
        setState(() {
          _usernameError = null;
          _usernameSuggestions = [];
        });
      }
    } catch (e) {
      // ignore silently to not disrupt typing
    }
    _validateForm();
  }

  void _validateForm() {
    final s1Valid = _fullNameCtrl.text.trim().isNotEmpty &&
        _emailCtrl.text.trim().isNotEmpty &&
        _usernameCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _otpCtrl.text.trim().isNotEmpty;

    final s2Valid = _companyCtrl.text.trim().isNotEmpty &&
        _companyAddressCtrl.text.trim().isNotEmpty;

    setState(() {
      _isStep1Valid = s1Valid;
      _isStep2Valid = s2Valid;
    });
  }

  void _startResendTimer() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      UiUtils.showCustomSnackBar(context: context, message: 'Please enter a phone number');
      return;
    }

    try {
      final api = ApiService();
      final res = await api.post('/auth/check-phone', {'phone': phone});
      if (res['exists'] == true) {
        UiUtils.showCustomSnackBar(context: context, message: 'This number is already signed up. Please log in.');
        return;
      }
    } catch (e) {
      UiUtils.showCustomSnackBar(context: context, message: 'Error connecting to server.');
      return;
    }

    setState(() {
      _isOtpSent = true;
      _resendTimer = 30;
    });
    UiUtils.showCustomSnackBar(
      context: context, 
      message: 'OTP Sent! (Mock)', 
      isError: false
    );
  }

  void _onContinue() async {
    if (_currentStep == 0 && _selectedRole == UserRole.admin) {
      if (!_isStep1Valid || _usernameError != null) return;
      setState(() {
        _currentStep = 1;
      });
      return;
    }

    if (_selectedRole == UserRole.admin && !_isStep2Valid) return;
    if (_selectedRole == UserRole.client && (!_isStep1Valid || _usernameError != null)) return;

    try {
      final api = ApiService();
      final payload = {
        'role': _selectedRole == UserRole.admin ? 'ADMIN' : 'CLIENT',
        'fullName': _fullNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'username': _usernameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      };

      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        payload['profileImage'] = 'data:image/png;base64,${base64Encode(bytes)}';
      }

      if (_selectedRole == UserRole.admin) {
        payload['companyName'] = _companyCtrl.text.trim();
        payload['estYear'] = _estYearCtrl.text.trim();
        payload['city'] = _cityCtrl.text.trim();
        payload['state'] = _stateCtrl.text.trim();
        payload['companyAddress'] = _companyAddressCtrl.text.trim();
        payload['gstNumber'] = _gstCtrl.text.trim();
        payload['panNumber'] = _panCtrl.text.trim();
        payload['companyPhone'] = _companyPhoneCtrl.text.trim();
        payload['companyEmail'] = _companyEmailCtrl.text.trim();
        payload['website'] = _websiteCtrl.text.trim();

        if (_companyLogo != null) {
          final bytes = await _companyLogo!.readAsBytes();
          payload['companyLogo'] = 'data:image/png;base64,${base64Encode(bytes)}';
        }
      }

      final res = await api.post('/auth/signup', payload);
      
      ApiService.currentUserId = res['id'];
      ApiService.currentCompanyId = res['companyId'];

      await AuthService.saveRole(_selectedRole);

      if (!mounted) return;
      
      UiUtils.showCustomSnackBar(
        context: context, 
        message: 'Profile completed successfully!', 
        isError: false
      );

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = (_currentStep == 0 && _isStep1Valid && _usernameError == null) ||
        (_currentStep == 1 && _isStep2Valid);

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text.rich(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _currentStep == 0 ? 'Personal Details' : 'Company Details',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_selectedRole == UserRole.admin)
                            Text(
                              'Step ${_currentStep + 1} of 2',
                              style: const TextStyle(
                                color: Color(0xFF06B6D4),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentStep == 0
                            ? 'Tell us a bit about yourself to get started'
                            : 'Provide your business information to set up your profile',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (_currentStep == 0) _buildStep1() else _buildStep2(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_currentStep == 1) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep = 0;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF06B6D4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF06B6D4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isButtonActive ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4),
                        disabledBackgroundColor: const Color(0xFF1E293B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isButtonActive ? 4 : 0,
                      ),
                      child: Text(
                        _currentStep == 0 && _selectedRole == UserRole.admin ? 'Next' : 'Complete Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isButtonActive ? Colors.white : Colors.white38,
                        ),
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

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Profile Photo Picker ──
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(false),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1E293B),
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white54)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Role Selector ──
        _buildRoleSelector(),
        const SizedBox(height: 28),

        // ── Form Fields ──
        _buildInputField('Full Name', _fullNameCtrl),
        const SizedBox(height: 16),
        _buildInputField('Email Address', _emailCtrl, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildInputField('Username', _usernameCtrl),
        if (_usernameError != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              _usernameError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          if (_usernameSuggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                children: _usernameSuggestions.map((s) => ActionChip(
                  label: Text(s, style: const TextStyle(fontSize: 12)),
                  backgroundColor: const Color(0xFF1E293B),
                  labelStyle: const TextStyle(color: Color(0xFF06B6D4)),
                  onPressed: () {
                    _usernameCtrl.text = s;
                    _checkUsername();
                  },
                )).toList(),
              ),
            ),
        ],
        const SizedBox(height: 16),
        _buildPhoneField(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: _isOtpSent && _resendTimer > 0
              ? Text(
                  'Resend OTP in 00:${_resendTimer.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                )
              : TextButton(
                  onPressed: _startResendTimer,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Send OTP', style: TextStyle(color: Color(0xFF06B6D4), fontSize: 12)),
                ),
        ),
        if (_isOtpSent) ...[
          const SizedBox(height: 16),
          _buildInputField('Enter 6-digit OTP', _otpCtrl, keyboardType: TextInputType.number),
        ],
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Company Logo Picker ──
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(true),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                    image: _companyLogo != null
                        ? DecorationImage(image: FileImage(_companyLogo!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _companyLogo == null
                      ? const Icon(Icons.business, size: 40, color: Colors.white54)
                      : null,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0F172A), width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Form Fields ──
        _buildInputField('Company / Organisation Name *', _companyCtrl),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField('Est. Year', _estYearCtrl, keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(child: _buildInputField('City', _cityCtrl)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField('State / Province', _stateCtrl),
        const SizedBox(height: 16),
        _buildInputField('Full Address *', _companyAddressCtrl),
        const SizedBox(height: 16),
        _buildInputField('GST Number', _gstCtrl),
        const SizedBox(height: 16),
        _buildInputField('PAN Number', _panCtrl),
        const SizedBox(height: 16),
        _buildInputField('Company Phone', _companyPhoneCtrl, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildInputField('Company Email', _companyEmailCtrl, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildInputField('Website URL', _websiteCtrl, keyboardType: TextInputType.url),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _buildRoleCard(
          role: UserRole.admin,
          title: 'Admin',
          subtitle: 'I own/manage a company',
          icon: Icons.business,
          color: const Color(0xFF06B6D4),
        ),
        const SizedBox(width: 16),
        _buildRoleCard(
          role: UserRole.client,
          title: 'Client',
          subtitle: 'I am tracking my project',
          icon: Icons.person_outline,
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
            _validateForm();
          });
        },
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
                child: Icon(icon, color: isSelected ? color : Colors.white38, size: 18),
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
                style: const TextStyle(color: Colors.white38, fontSize: 10, height: 1.4),
              ),
              const SizedBox(height: 8),
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

  Widget _buildInputField(String hint, TextEditingController controller, {TextInputType? keyboardType}) {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                Text('+91', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
