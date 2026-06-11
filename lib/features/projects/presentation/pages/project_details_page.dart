import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String title;
  final String type;
  final String subtitle;
  final double progress;
  final String dateRange;

  const ProjectDetailsPage({
    super.key,
    required this.title,
    required this.type,
    required this.subtitle,
    required this.progress,
    required this.dateRange,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State variables for edit
  late String _projectTitle;
  late String _projectType;
  late String _projectLocation;
  late String _projectStatus;
  late String _totalBudget;
  late String _progressPercentage;
  late String _startDate;
  late String _endDate;
  late String _clientName;
  late String _clientPhone;
  late String _clientAddress;

  DateTime _overviewDailyDate = DateTime(2026, 6, 11);
  DateTime _paymentDailyDate = DateTime(2025, 6, 4);
  DateTime _taskDate = DateTime(2025, 6, 4);

  List<Map<String, dynamic>> _uploadedFiles = [
    {
      'name': 'Floor_Plan_B2.pdf',
      'size': '2.4 MB',
      'date': 'Jun 1, 2025',
      'type': 'pdf'
    },
    {
      'name': 'Site_Photo_May30.jpg',
      'size': '1.8 MB',
      'date': 'May 30, 2025',
      'type': 'jpg'
    },
    {
      'name': 'Contract_Agreement.docx',
      'size': '560 KB',
      'date': 'Jan 5, 2025',
      'type': 'docx'
    }
  ];

  final Map<String, List<Map<String, dynamic>>> _mockOverviewExpenses = {
    '11-06-2026': [
      {'icon': Icons.people_outline, 'iconColor': Colors.blue, 'iconBg': Colors.blue.shade50, 'title': 'Salaries & Wages', 'subtitle': 'Paid to 15 Labours & 2 Engineers\nDirect Cash & UPI', 'amount': '₹14,500'},
      {'icon': Icons.layers_outlined, 'iconColor': Colors.orange, 'iconBg': Colors.orange.shade50, 'title': 'Vendor Payments', 'subtitle': 'Ramco Cements (200 Bags)\nBank Transfer', 'amount': '₹68,000'},
      {'icon': Icons.local_shipping_outlined, 'iconColor': Colors.purple, 'iconBg': Colors.purple.shade50, 'title': 'Transport', 'subtitle': 'Material unload & Truck hire\nCash', 'amount': '₹4,500'},
      {'icon': Icons.coffee_outlined, 'iconColor': Colors.teal, 'iconBg': Colors.teal.shade50, 'title': 'Tea & Snacks', 'subtitle': 'Evening refreshments\nPetty Cash', 'amount': '₹450'},
    ],
    '12-06-2026': [
      {'icon': Icons.people_outline, 'iconColor': Colors.blue, 'iconBg': Colors.blue.shade50, 'title': 'Salaries & Wages', 'subtitle': 'Paid to 12 Labours\nDirect Cash', 'amount': '₹9,600'},
      {'icon': Icons.coffee_outlined, 'iconColor': Colors.teal, 'iconBg': Colors.teal.shade50, 'title': 'Tea & Snacks', 'subtitle': 'Evening refreshments\nPetty Cash', 'amount': '₹300'},
    ]
  };

  final Map<String, Map<String, dynamic>> _mockPaymentExpenses = {
    '04-06-2025': {
      'total': '₹ 11,450',
      'workers': '15',
      'salary': '₹10,800',
      'tea': '₹450',
      'other': '₹200',
      'breakdown': [
        {'title': 'Full-Day Wages (12 Workers)', 'subtitle': '₹800 / head', 'amount': '₹9,600'},
        {'title': 'Half-Day Wages (3 Workers)', 'subtitle': '₹400 / head', 'amount': '₹1,200'},
        {'title': 'Tea & Snacks', 'subtitle': 'Daily refreshment cost', 'amount': '₹450'},
        {'title': 'Other Expenses', 'subtitle': 'Transport, Materials', 'amount': '₹200'},
      ]
    },
    '05-06-2025': {
      'total': '₹ 8,300',
      'workers': '10',
      'salary': '₹8,000',
      'tea': '₹300',
      'other': '₹0',
      'breakdown': [
        {'title': 'Full-Day Wages (10 Workers)', 'subtitle': '₹800 / head', 'amount': '₹8,000'},
        {'title': 'Tea & Snacks', 'subtitle': 'Daily refreshment cost', 'amount': '₹300'},
      ]
    }
  };

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
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize mock data based on widget props
    _projectTitle = widget.title;
    _projectType = widget.type == 'COMMERCIAL' ? 'Commercial' : 'Residential';
    _projectLocation = widget.subtitle;
    _projectStatus = 'Active';
    _totalBudget = '24000000';
    _progressPercentage = (widget.progress * 100).toInt().toString();
    _startDate = '01-01-2025';
    _endDate = '31-12-2025';
    _clientName = '';
    _clientPhone = '';
    _clientAddress = '';
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Under Budget',
                  style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '₹ 45.2L',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(width: 4),
              Text(
                '/ 80L',
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

  Widget _buildDailyExpenses() {
    final dateStr = _formatDate(_overviewDailyDate);
    final expenses = _mockOverviewExpenses[dateStr] ?? [];

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
        if (expenses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No expenses recorded for this date.', style: TextStyle(color: Colors.grey)),
          )
        else
          ...expenses.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildExpenseItem(
                icon: e['icon'],
                iconColor: e['iconColor'],
                iconBg: e['iconBg'],
                title: e['title'],
                subtitle: e['subtitle'],
                amount: e['amount'],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Stages',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 16),
        _buildStageItem(
          icon: Icons.check_circle,
          iconColor: const Color(0xFF10B981),
          title: 'Foundation & Excavation',
          subtitle: 'Completed Mar 15, 2025',
          isLast: false,
        ),
        _buildStageItem(
          icon: Icons.radio_button_checked,
          iconColor: const Color(0xFF06B6D4),
          title: 'Structural Work',
          subtitle: 'In Progress (Est. May 2025)',
          isLast: false,
          titleColor: const Color(0xFF06B6D4),
        ),
        _buildStageItem(
          icon: Icons.circle,
          iconColor: const Color(0xFF0F172A),
          title: 'Finishing & Interiors',
          subtitle: 'Planned for Sep 2025',
          isLast: true,
        ),
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
        _buildTeamMemberItem(
          initials: 'RK',
          bgColor: Colors.blue,
          name: 'Raj Kumar',
          role: 'Project Manager',
          badgeText: 'PM',
          badgeBg: Colors.blue.shade50,
          badgeColor: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildTeamMemberItem(
          initials: 'SK',
          bgColor: const Color(0xFF10B981),
          name: 'Suresh Kannan',
          role: 'Site Engineer',
          badgeText: 'PRESENT',
          badgeBg: const Color(0xFFD1FAE5),
          badgeColor: const Color(0xFF059669),
          roleBadgeText: 'ENGINEER',
          roleBadgeBg: Colors.orange.shade50,
          roleBadgeColor: Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildTeamMemberItem(
          initials: 'PM',
          bgColor: Colors.orange,
          name: 'Priya Murugan',
          role: 'Supervisor',
          badgeText: 'LEAVE APPROVED',
          badgeBg: Colors.orange.shade50,
          badgeColor: Colors.orange,
          roleBadgeText: 'SUPERVISOR',
          roleBadgeBg: const Color(0xFFD1FAE5),
          roleBadgeColor: const Color(0xFF059669),
        ),
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
              const Text('₹2,40,00,000', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 55,
                    child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(3))),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 45,
                    child: Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(3))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Received: ₹1,32,00,000', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w600)),
                  const Text('Pending: ₹1,08,00,000', style: TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
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
        _buildInstallmentItem('Foundation Completion', 'Paid on Mar 15, 2025', '₹40L', 'PAID', const Color(0xFF10B981), const Color(0xFFD1FAE5)),
        Divider(color: Colors.grey.shade200),
        _buildInstallmentItem('Structural Work', 'Due: May 30, 2025', '₹60L', 'PENDING', const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
        Divider(color: Colors.grey.shade200),
        _buildInstallmentItem('Finishing Work', 'Due: Sep 30, 2025', '₹80L', 'UPCOMING', Colors.grey.shade600, Colors.grey.shade200),
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
    final data = _mockPaymentExpenses[dateStr];

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
        if (data == null)
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
                            Text(data['total'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
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
                            Text(data['workers'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
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
                       _buildDarkOverviewRow('Salary Expense (${data['workers']} Headcount)', data['salary']),
                       const SizedBox(height: 8),
                       _buildDarkOverviewRow('Tea & Snacks', data['tea']),
                       const SizedBox(height: 8),
                       _buildDarkOverviewRow('Other Daily Expenses', data['other']),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('DETAILED BREAKDOWN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          ...((data['breakdown'] as List).asMap().entries.map((entry) {
             final item = entry.value;
             final isLast = entry.key == (data['breakdown'] as List).length - 1;
             return Column(
               children: [
                 _buildDetailedBreakdownItem(item['title'], item['subtitle'], item['amount']),
                 if (!isLast) Divider(color: Colors.grey.shade200),
               ]
             );
          }).toList()),
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

  Widget _buildTasksList(String status) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (status == 'Planned') ...[
          _buildTaskItem('Install electrical conduits Floor 8', 'Jun 20', 'High', const Color(0xFFEF4444), const Color(0xFFFEE2E2), assignee: 'Vimal R.'),
          const SizedBox(height: 12),
          _buildTaskItem('Tile work – 6th floor bathrooms', 'Jun 28', 'Low', const Color(0xFF10B981), const Color(0xFFD1FAE5)),
        ],
        if (status == 'In Progress') ...[
          _buildTaskItem('Plastering – Floors 9-11', 'Jun 15', 'High', const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
        ],
        if (status == 'Blocked') ...[
          _buildWarningTaskItem('Waterproofing – Terrace', 'Material not delivered'),
        ],
        if (status == 'Completed') ...[
          _buildCompletedTaskItem('Foundation & Footing', 'Completed Mar 10'),
          const SizedBox(height: 12),
          _buildCompletedTaskItem('Structural columns up to 8F', 'Completed May 2'),
        ],
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
    String assignee = 'Raj Kumar';
    String deadline = '19-06-2026';
    String priority = 'Low';

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
                        _buildTextField('TASK NAME *', taskName, (val) => taskName = val, hint: 'e.g. celling'),
                        const SizedBox(height: 16),
                        _buildDropdown('ASSIGNED TO *', ['Raj Kumar', 'Suresh Kannan', 'Priya Murugan'], assignee, (val) => setState(() => assignee = val!)),
                        const SizedBox(height: 16),
                        _buildTextField('DEADLINE *', deadline, (val) => deadline = val, isDate: true),
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
                        onPressed: () => Navigator.pop(context),
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
