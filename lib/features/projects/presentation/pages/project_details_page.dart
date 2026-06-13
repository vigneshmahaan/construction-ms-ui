import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import 'package:construction_ms_ui/core/network/api_service.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _project;

  // State variables for edit
  String _projectTitle = '';
  String _projectType = 'Residential';
  String _projectLocation = '';
  String _projectStatus = 'Active';
  String _totalBudget = '';
  String _progressPercentage = '0';
  String _startDate = '';
  String _endDate = '';
  String _clientName = '';
  String _clientPhone = '';
  String _clientAddress = '';

  DateTime _overviewDailyDate = DateTime.now();
  DateTime _paymentDailyDate = DateTime.now();
  DateTime _taskDate = DateTime.now();

  List<dynamic> _expenses = [];

  List<Map<String, dynamic>> _uploadedFiles = [];

  // Mock Payment Expenses removed


  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _selectOverviewDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _overviewDailyDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF06B6D4)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _overviewDailyDate) {
      setState(() => _overviewDailyDate = picked);
    }
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDailyDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF06B6D4)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _paymentDailyDate) {
      setState(() => _paymentDailyDate = picked);
    }
  }

  Future<void> _selectTaskDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _taskDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF06B6D4)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _taskDate) {
      setState(() => _taskDate = picked);
    }
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      
      String ext = file.extension?.toLowerCase() ?? 'file';
      
      double sizeInMb = file.size / (1024 * 1024);
      String sizeStr = sizeInMb > 1 ? '${sizeInMb.toStringAsFixed(1)} MB' : '${(file.size / 1024).toStringAsFixed(0)} KB';
      
      final now = DateTime.now();
      const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      String dateStr = '${monthNames[now.month - 1]} ${now.day}, ${now.year}';
      
      setState(() {
        _uploadedFiles.insert(0, {
          'name': file.name,
          'size': sizeStr,
          'date': dateStr,
          'type': ext,
        });
      });
      try {
        await _apiService.patch('/projects/${widget.projectId}', {'agreements': _uploadedFiles});
      } catch (e) {
        print('Error saving file data: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchProjectDetails();
  }

  Future<void> _fetchProjectDetails() async {
    try {
      final response = await _apiService.get('/projects/${widget.projectId}');
      if (response != null) {
        setState(() {
          _project = response;
          _projectTitle = _project?['name'] ?? '';
          _projectType = _project?['projectType'] ?? 'Commercial';
          _projectLocation = _project?['address'] ?? '';
          _totalBudget = _project?['totalBudget']?.toString() ?? '0';
          _startDate = _project?['startDate']?.toString() ?? '';
          _endDate = _project?['endDate']?.toString() ?? '';
          
          if (_project?['client'] != null) {
            _clientName = _project?['client']['fullName'] ?? '';
            _clientPhone = _project?['client']['phone'] ?? '';
          }
          
          if (_project?['expenses'] != null) {
            _expenses = _project?['expenses'];
          }
          if (_project?['agreements'] != null) {
            try {
              final agreementsList = _project?['agreements'] as List;
              _uploadedFiles = agreementsList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
            } catch (_) {}
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching project details: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _shareProject() {
    Share.share('Check out this project: $_projectTitle\nLocation: $_projectLocation\nProgress: $_progressPercentage%');
  }

  void _showEditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Project Details',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField('PROJECT NAME *', _projectTitle, (val) => _projectTitle = val),
                            const SizedBox(height: 16),
                            _buildDropdown('TYPE', ['Commercial', 'Residential'], _projectType, (val) => _projectType = val!),
                            const SizedBox(height: 16),
                            _buildTextField('LOCATION / ADDRESS', _projectLocation, (val) => _projectLocation = val),
                            const SizedBox(height: 16),
                            _buildDropdown('STATUS', ['Active', 'On Hold', 'Completed'], _projectStatus, (val) => _projectStatus = val!),
                            const SizedBox(height: 16),
                            _buildTextField('TOTAL BUDGET (₹)', _totalBudget, (val) => _totalBudget = val, isNumeric: true),
                            const SizedBox(height: 16),
                            _buildTextField('PROGRESS PERCENTAGE (%)', _progressPercentage, (val) => _progressPercentage = val, isNumeric: true),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField('START DATE', _startDate, (val) => _startDate = val, isDate: true)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField('END DATE', _endDate, (val) => _endDate = val, isDate: true)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Client Details',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField('CLIENT NAME', _clientName, (val) => _clientName = val, hint: 'e.g. Arun Kumar'),
                            const SizedBox(height: 16),
                            _buildTextField('CLIENT PHONE *', _clientPhone, (val) => _clientPhone = val, hint: 'Mobile number for client login'),
                            const SizedBox(height: 16),
                            _buildTextField('CLIENT ADDRESS', _clientAddress, (val) => _clientAddress = val, hint: 'Residential/Office address'),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          this.setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddInstallmentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Installment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('INSTALLMENT NAME *', '', (val){}, hint: 'e.g. Foundation Completion'),
                        const SizedBox(height: 16),
                        _buildTextField('AMOUNT (₹) *', '', (val){}, hint: 'e.g. 4000000', isNumeric: true),
                        const SizedBox(height: 16),
                        _buildTextField('ADDITIONAL COST (₹)', '0', (val){}, isNumeric: true),
                        const SizedBox(height: 16),
                        _buildTextField('DUE DATE', 'dd-mm-yyyy', (val){}, isDate: true),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Add Installment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged, {bool isNumeric = false, bool isDate = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label.replaceAll(' *', ''), style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
            if (label.contains('*')) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF06B6D4))),
            suffixIcon: isDate ? const Icon(Icons.calendar_today, color: Colors.grey, size: 18) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blueGrey.shade800)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF06B6D4))),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(backgroundColor: const Color(0xFF0F172A)),
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4))),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _projectTitle,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: _showEditModal,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: _shareProject,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.5)),
                      ),
                      child: Text(
                        _projectType.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF60A5FA),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _projectLocation,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_progressPercentage% Complete',
                      style: const TextStyle(color: Color(0xFF06B6D4), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: int.parse(_progressPercentage) / 100,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      '$_startDate - $_endDate',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF06B6D4),
                indicatorWeight: 3,
                labelColor: const Color(0xFF06B6D4),
                unselectedLabelColor: Colors.grey.shade500,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Payment'),
                  Tab(text: 'Tasks'),
                  Tab(text: 'Files'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPaymentTab(),
          _buildTasksTab(),
          _buildFilesTab(),
        ],
      ),
    );
  }

  // OVERVIEW TAB
  double _getTotalSpent() {
    double total = 0;
    for (var e in _expenses) {
      total += (e['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹ ${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '₹ ${(amount / 100000).toStringAsFixed(1)}L';
    } else {
      return '₹ ${amount.toStringAsFixed(0)}';
    }
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBudgetCard(),
        const SizedBox(height: 24),
        _buildDailyExpenses(),
        const SizedBox(height: 24),
        _buildProjectStages(),
        const SizedBox(height: 24),
        _buildTeamMembers(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBudgetCard() {
    final budget = double.tryParse(_totalBudget) ?? 0.0;
    final spent = _getTotalSpent();
    final isOverBudget = budget > 0 && spent > budget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL SPENT (TILL DATE)',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              if (budget > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverBudget ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOverBudget ? 'Over Budget' : 'Under Budget',
                    style: TextStyle(color: isOverBudget ? const Color(0xFFE11D48) : const Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(spent),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ${_formatAmount(budget)}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Project Completion Progress',
            style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ChartPainter(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jan', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                      Text('Feb', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                      Text('Mar', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                      Text('Apr', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                      Text('May', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                      const Text('Jun (72%)', style: TextStyle(color: Color(0xFF06B6D4), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExpenseIcon(String category) {
    switch (category.toUpperCase()) {
      case 'WAGES': return Icons.people_outline;
      case 'VENDOR': return Icons.layers_outlined;
      case 'TRANSPORT': return Icons.local_shipping_outlined;
      case 'TEA_SNACKS': return Icons.coffee_outlined;
      default: return Icons.receipt_long;
    }
  }

  Color _getExpenseColor(String category) {
    switch (category.toUpperCase()) {
      case 'WAGES': return Colors.blue;
      case 'VENDOR': return Colors.orange;
      case 'TRANSPORT': return Colors.purple;
      case 'TEA_SNACKS': return Colors.teal;
      default: return Colors.grey;
    }
  }

  Widget _buildDailyExpenses() {
    final dateStr = _formatDate(_overviewDailyDate);
    final dailyExpenses = _expenses.where((e) {
      if (e['date'] == null) return false;
      final eDate = DateTime.tryParse(e['date'].toString());
      if (eDate == null) return false;
      return _formatDate(eDate) == dateStr;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daily Expenses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            GestureDetector(
              onTap: () => _selectOverviewDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF06B6D4)),
                    const SizedBox(width: 8),
                    Text(dateStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (dailyExpenses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No expenses recorded for this date.', style: TextStyle(color: Colors.grey)),
          )
        else
          ...dailyExpenses.map((e) {
            final category = e['category']?.toString() ?? 'OTHER';
            final color = _getExpenseColor(category);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildExpenseItem(
                icon: _getExpenseIcon(category),
                iconColor: color,
                iconBg: color.withOpacity(0.1),
                title: e['title'] ?? 'Expense',
                subtitle: e['subtitle'] ?? category,
                amount: '₹${e['amount'] ?? 0}',
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildExpenseItem({required IconData icon, required Color iconColor, required Color iconBg, required String title, required String subtitle, required String amount}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildProjectStages() {
    final installments = _project?['installments'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Stages',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 16),
        if (installments.isEmpty)
          const Text('No stages defined yet.', style: TextStyle(color: Colors.grey)),
        ...installments.asMap().entries.map((entry) {
          final idx = entry.key;
          final inst = entry.value;
          final isPaid = inst['isPaid'] == true;
          final isLast = idx == installments.length - 1;
          
          return _buildStageItem(
            icon: isPaid ? Icons.check_circle : Icons.circle,
            iconColor: isPaid ? const Color(0xFF10B981) : const Color(0xFF0F172A),
            title: inst['stageName'] ?? 'Stage ${idx + 1}',
            subtitle: isPaid ? 'Completed' : 'Planned',
            isLast: isLast,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStageItem({required IconData icon, required Color iconColor, required String title, required String subtitle, required bool isLast, Color? titleColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor ?? const Color(0xFF1E293B))),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamMembers() {
    final assignments = _project?['assignments'] as List? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Team Members',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('+ Assign', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (assignments.isEmpty)
          const Text('No team members assigned', style: TextStyle(color: Colors.grey)),
        ...assignments.map((assignment) {
          final user = assignment['user'] ?? {};
          final name = user['fullName'] ?? 'Unknown';
          final role = user['role'] ?? 'WORKER';
          
          String initials = '?';
          final nameParts = name.toString().split(' ');
          if (nameParts.length >= 2) {
            initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
          } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
            initials = '${nameParts[0][0]}'.toUpperCase();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTeamMemberItem(
              initials: initials,
              bgColor: Colors.blue,
              name: name,
              role: role,
              badgeText: 'ASSIGNED',
              badgeBg: Colors.blue.shade50,
              badgeColor: Colors.blue,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTeamMemberItem({
    required String initials,
    required Color bgColor,
    required String name,
    required String role,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    String? roleBadgeText,
    Color? roleBadgeBg,
    Color? roleBadgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 20,
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(role, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (roleBadgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: roleBadgeBg, borderRadius: BorderRadius.circular(4)),
                  child: Text(roleBadgeText, style: TextStyle(color: roleBadgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: roleBadgeText == null ? null : Border.all(color: badgeColor.withOpacity(0.3)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PAYMENT TAB
  Widget _buildPaymentTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF0F172A),
            child: const TabBar(
              indicatorColor: Color(0xFF06B6D4),
              indicatorWeight: 3,
              labelColor: Color(0xFF06B6D4),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Client Payments'),
                Tab(text: 'Daily Site Expenses'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildClientPaymentsTab(),
                _buildDailySiteExpensesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientPaymentsTab() {
    final budget = double.tryParse(_totalBudget) ?? 0.0;
    final advance = (_project?['advanceReceived'] as num?)?.toDouble() ?? 0.0;
    
    final installments = _project?['installments'] as List<dynamic>? ?? [];
    double paidInstallments = 0.0;
    for (var inst in installments) {
      if (inst['isPaid'] == true) {
        paidInstallments += (inst['amount'] as num?)?.toDouble() ?? 0.0;
      }
    }

    final totalReceived = advance + paidInstallments;
    final pending = budget - totalReceived > 0 ? budget - totalReceived : 0.0;

    int flexReceived = 0;
    int flexPending = 100;
    if (budget > 0) {
      flexReceived = ((totalReceived / budget) * 100).toInt();
      flexReceived = flexReceived > 100 ? 100 : flexReceived;
      flexPending = 100 - flexReceived;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CLIENT BUDGET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(_formatAmount(budget), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (flexReceived > 0)
                    Expanded(
                      flex: flexReceived,
                      child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(3))),
                    ),
                  if (flexReceived > 0 && flexPending > 0) const SizedBox(width: 4),
                  if (flexPending > 0)
                    Expanded(
                      flex: flexPending,
                      child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(3))),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Received: ${_formatAmount(totalReceived)}', style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w600)),
                  Text('Pending: ${_formatAmount(pending)}', style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Installments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            TextButton(
              onPressed: _showAddInstallmentModal,
              child: const Text('+ Add', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (installments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No installments defined.', style: TextStyle(color: Colors.grey)),
          )
        else
          ...installments.map((inst) {
            final isPaid = inst['isPaid'] == true;
            final amount = (inst['amount'] as num?)?.toDouble() ?? 0.0;
            return Column(
              children: [
                _buildInstallmentItem(
                  inst['stageName'] ?? 'Installment',
                  isPaid ? 'Paid' : 'Pending',
                  _formatAmount(amount),
                  isPaid ? 'PAID' : 'PENDING',
                  isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                  isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                ),
                Divider(color: Colors.grey.shade200),
              ],
            );
          }).toList(),
      ],
    );
  }

  Widget _buildInstallmentItem(String title, String subtitle, String amount, String badge, Color badgeColor, Color badgeBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailySiteExpensesTab() {
    final dateStr = _formatDate(_paymentDailyDate);
    final dailyExpenses = _expenses.where((e) {
      if (e['date'] == null) return false;
      final eDate = DateTime.tryParse(e['date'].toString());
      if (eDate == null) return false;
      return _formatDate(eDate) == dateStr;
    }).toList();

    double total = 0;
    double wages = 0;
    double tea = 0;
    double other = 0;
    int workers = 0;

    for (var e in dailyExpenses) {
      final amt = double.tryParse(e['amount']?.toString() ?? '0') ?? 0;
      total += amt;
      final category = e['category']?.toString().toUpperCase();
      if (category == 'WAGES') {
        wages += amt;
        workers++; // rough proxy
      } else if (category == 'TEA_SNACKS') {
        tea += amt;
      } else {
        other += amt;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('FILTER BY DATE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectPaymentDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateStr, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                Icon(Icons.calendar_today, size: 18, color: Colors.grey.shade800),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (dailyExpenses.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No expenses recorded for this date.', style: TextStyle(color: Colors.grey)),
          ))
        else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DAILY OVERVIEW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFE6F8F3), borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('TOTAL EXPENSE', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('WORKERS PRESENT', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('$workers', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                       _buildDarkOverviewRow('Salary Expense ($workers Headcount)', '₹${wages.toStringAsFixed(0)}'),
                       const SizedBox(height: 8),
                       _buildDarkOverviewRow('Tea & Snacks', '₹${tea.toStringAsFixed(0)}'),
                       const SizedBox(height: 8),
                       _buildDarkOverviewRow('Other Daily Expenses', '₹${other.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('DETAILED BREAKDOWN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          ...dailyExpenses.asMap().entries.map((entry) {
             final item = entry.value;
             final isLast = entry.key == dailyExpenses.length - 1;
             return Column(
               children: [
                 _buildDetailedBreakdownItem(item['title'] ?? 'Expense', item['subtitle'] ?? item['category']?.toString() ?? '', '₹${item['amount'] ?? 0}'),
                 if (!isLast) Divider(color: Colors.grey.shade200),
               ]
             );
          }).toList(),
        ]
      ],
    );
  }

  Widget _buildDarkOverviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDetailedBreakdownItem(String title, String subtitle, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  // TASKS TAB
  Widget _buildTasksTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: const TabBar(
              indicatorColor: Color(0xFF06B6D4),
              indicatorWeight: 3,
              labelColor: Color(0xFF06B6D4),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Planned'),
                Tab(text: 'In Progress'),
                Tab(text: 'Blocked'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter by Date:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                GestureDetector(
                  onTap: () => _selectTaskDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(_formatDate(_taskDate), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTasksList('Planned'),
                _buildTasksList('In Progress'),
                _buildTasksList('Blocked'),
                _buildTasksList('Completed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    try {
      final response = await _apiService.patch('/daily-tasks/$taskId/status', {'status': newStatus});
      if (response != null) {
        _fetchProjectDetails(); // Refresh
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  void _showTaskActionModal(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final currentStatus = task['status']?.toString() ?? '';
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task['title'] ?? 'Task', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(task['description'] ?? 'No description', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              if (currentStatus == 'PLANNED') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'IN_PROGRESS'); },
                    child: const Text('Move to In Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444)), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'BLOCKED'); },
                    child: const Text('Blocked', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else if (currentStatus == 'IN_PROGRESS') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'COMPLETED'); },
                    child: const Text('Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444)), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'BLOCKED'); },
                    child: const Text('Blocked', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else if (currentStatus == 'BLOCKED') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'IN_PROGRESS'); },
                    child: const Text('Assign task again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else if (currentStatus == 'COMPLETED') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'This task has been successfully completed.',
                          style: TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF06B6D4),
                      side: const BorderSide(color: Color(0xFF06B6D4)),
                      padding: const EdgeInsets.symmetric(vertical: 14)
                    ),
                    onPressed: () { Navigator.pop(ctx); _updateTaskStatus(task['id'], 'IN_PROGRESS'); },
                    child: const Text('Reopen Task', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ]
            ],
          ),
        );
      }
    );
  }

  Widget _buildTasksList(String status) {
    final allTasks = _project?['dailyTasks'] as List<dynamic>? ?? [];
    
    // Map UI tab status to DB status
    String dbStatus = '';
    if (status == 'Planned') dbStatus = 'PLANNED';
    else if (status == 'In Progress') dbStatus = 'IN_PROGRESS';
    else if (status == 'Blocked') dbStatus = 'BLOCKED';
    else if (status == 'Completed') dbStatus = 'COMPLETED';

    final tasks = allTasks.where((t) => t['status'] == dbStatus).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('No tasks found.', style: TextStyle(color: Colors.grey)),
          )
        else
          ...tasks.map((task) {
            final title = task['title']?.toString() ?? 'Task';
            final desc = task['description']?.toString() ?? '';
            final assignee = task['worker']?['fullName']?.toString();
            final priority = task['priority']?.toString() ?? 'LOW';
            final deadlineStr = task['deadline']?.toString();
            
            String displayDate = 'No date';
            if (deadlineStr != null) {
               final d = DateTime.tryParse(deadlineStr);
               if (d != null) {
                 const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                 displayDate = '${months[d.month - 1]} ${d.day}';
               }
            }

            final isHigh = priority == 'HIGH';
            final badgeColor = isHigh ? const Color(0xFFEF4444) : const Color(0xFF10B981);
            final badgeBg = isHigh ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5);
            final badgeLabel = isHigh ? 'High' : 'Low';

            Widget item;
            if (dbStatus == 'BLOCKED') {
               item = _buildWarningTaskItem(title, desc.isNotEmpty ? desc : 'Blocked task');
            } else if (dbStatus == 'COMPLETED') {
               item = _buildCompletedTaskItem(title, 'Completed');
            } else {
               item = _buildTaskItem(title, displayDate, badgeLabel, badgeColor, badgeBg, assignee: assignee);
            }

            return GestureDetector(
              onTap: () => _showTaskActionModal(task),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: item,
              ),
            );
          }).toList(),

        if (status == 'Planned') ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showAddTaskModal,
            child: CustomPaint(
              painter: DashedBorderPainter(color: const Color(0xFF06B6D4)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: Color(0xFF06B6D4), size: 18),
                    SizedBox(width: 8),
                    Text('Add Task', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWarningTaskItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTaskItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, decoration: TextDecoration.lineThrough)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF10B981)),
              const SizedBox(width: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String dueDate, String badge, Color badgeColor, Color badgeBg, {String? assignee}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text('Due: $dueDate', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    if (assignee != null) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(assignee, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ]
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
            child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GestureDetector(
          onTap: _uploadFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_upload_outlined, color: Colors.blueGrey.shade600, size: 20),
                const SizedBox(width: 8),
                Text('Upload Files', style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Uploaded Files', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        ..._uploadedFiles.asMap().entries.map((entry) {
          final isLast = entry.key == _uploadedFiles.length - 1;
          final file = entry.value;
          return Column(
            children: [
              _buildFileItem(file),
              if (!isLast) Divider(color: Colors.grey.shade200, height: 32),
            ]
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file) {
    Color iconColor;
    Color bgColor;
    IconData iconData;

    final type = file['type'] as String;
    if (type == 'pdf') {
      iconColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
      iconData = Icons.insert_drive_file_outlined;
    } else if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      iconColor = const Color(0xFF3B82F6);
      bgColor = const Color(0xFFDBEAFE);
      iconData = Icons.image_outlined;
    } else if (type == 'docx' || type == 'doc') {
      iconColor = const Color(0xFF10B981);
      bgColor = const Color(0xFFD1FAE5);
      iconData = Icons.description_outlined;
    } else {
      iconColor = Colors.grey.shade600;
      bgColor = Colors.grey.shade200;
      iconData = Icons.insert_drive_file_outlined;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(file['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text('${file['size']} · ${file['date']}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddTaskModal() {
    String taskName = '';
    String deadline = '';
    String priority = 'High';
    
    final assignments = _project?['assignments'] as List<dynamic>? ?? [];
    List<Map<String, String>> workers = assignments.map((a) {
      return {
        'id': a['user']?['id']?.toString() ?? '',
        'name': a['user']?['fullName']?.toString() ?? 'Unknown Worker',
      };
    }).toList();
    
    if (workers.isEmpty) {
      workers = [{'id': '', 'name': 'No workers assigned'}];
    }
    
    String assigneeId = workers.first['id']!;
    String assigneeName = workers.first['name']!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('TASK NAME *', taskName, (val) => taskName = val, hint: 'e.g. ceiling'),
                        const SizedBox(height: 16),
                        _buildDropdown('ASSIGNED TO *', workers.map((w) => w['name']!).toList(), assigneeName, (val) {
                          setState(() {
                            assigneeName = val!;
                            assigneeId = workers.firstWhere((w) => w['name'] == val)['id']!;
                          });
                        }),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            DateTime firstD = DateTime(2000);
                            DateTime lastD = DateTime(2101);
                            
                            if (_startDate.isNotEmpty) {
                              final s = DateTime.tryParse(_startDate);
                              if (s != null) firstD = s;
                            }
                            if (_endDate.isNotEmpty) {
                              final e = DateTime.tryParse(_endDate);
                              if (e != null) lastD = e;
                            }
                            
                            DateTime initDate = DateTime.now();
                            if (initDate.isBefore(firstD)) initDate = firstD;
                            if (initDate.isAfter(lastD)) initDate = lastD;

                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initDate,
                              firstDate: firstD,
                              lastDate: lastD,
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(primary: Color(0xFF06B6D4)),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                deadline = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('DEADLINE *', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blueGrey.shade800),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      deadline.isEmpty ? 'YYYY-MM-DD' : deadline,
                                      style: TextStyle(color: deadline.isEmpty ? Colors.grey.shade600 : Colors.white, fontSize: 16),
                                    ),
                                    const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('PRIORITY', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => priority = 'High'),
                              child: Row(
                                children: [
                                  Icon(priority == 'High' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: priority == 'High' ? const Color(0xFF06B6D4) : Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  const Text('High', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            GestureDetector(
                              onTap: () => setState(() => priority = 'Low'),
                              child: Row(
                                children: [
                                  Icon(priority == 'Low' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: priority == 'Low' ? const Color(0xFF06B6D4) : Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  const Text('Low', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF06B6D4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (taskName.isEmpty || assigneeId.isEmpty) return;
                          try {
                            String? isoDate;
                            if (deadline.isNotEmpty) {
                              try {
                                final d = DateTime.parse(deadline);
                                isoDate = d.toIso8601String();
                              } catch (_) {}
                            }
                            
                            await _apiService.post('/daily-tasks', {
                              'title': taskName,
                              'description': 'Task assigned to $assigneeName',
                              'deadline': isoDate,
                              'priority': priority.toUpperCase(),
                              'status': 'PLANNED',
                              'project': { 'connect': { 'id': widget.projectId } },
                              'worker': { 'connect': { 'id': assigneeId } }
                            });
                            Navigator.pop(context);
                            _fetchProjectDetails();
                          } catch (e) {
                            print('Error creating task: $e');
                          }
                        },
                        child: const Text('Add Task', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF06B6D4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF06B6D4).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    final points = [
      Offset(10, size.height - 20),
      Offset(size.width * 0.2, size.height - 30),
      Offset(size.width * 0.4, size.height - 25),
      Offset(size.width * 0.6, size.height - 50),
      Offset(size.width * 0.8, size.height - 60),
      Offset(size.width - 10, size.height - 75),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, size.height - 15);
    fillPath.lineTo(points.first.dx, size.height - 15);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final dotBorderPaint = Paint()
      ..color = const Color(0xFF06B6D4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({required this.color, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)));

    final dashPath = Path();
    bool draw = true;
    for (PathMetric measurePath in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        final double length = gap;
        if (draw) {
          dashPath.addPath(measurePath.extractPath(distance, distance + length), Offset.zero);
        }
        distance += length;
        draw = !draw;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
