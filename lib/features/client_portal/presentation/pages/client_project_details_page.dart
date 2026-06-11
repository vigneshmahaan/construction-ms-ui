import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/client_portal/data/models/project_models.dart';
import 'dart:math';

class ClientProjectDetailsPage extends StatefulWidget {
  final ClientProject project;

  const ClientProjectDetailsPage({
    super.key,
    required this.project,
  });

  @override
  State<ClientProjectDetailsPage> createState() => _ClientProjectDetailsPageState();
}

class _ClientProjectDetailsPageState extends State<ClientProjectDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  DateTime _selectedDate = DateTime(2026, 6, 11);

  // --- SYNCED ADMIN MOCK DATA ---
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
    '11-06-2026': {
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
  };

  final List<Map<String, dynamic>> _uploadedFiles = [
    {
      'name': 'Floor_Plan_B2.pdf',
      'size': '2.4 MB',
      'date': 'Jun 1, 2026',
      'type': 'pdf'
    },
    {
      'name': 'Site_Photo_May30.jpg',
      'size': '1.8 MB',
      'date': 'May 30, 2026',
      'type': 'jpg'
    },
    {
      'name': 'Contract_Agreement.docx',
      'size': '560 KB',
      'date': 'Jan 5, 2026',
      'type': 'docx'
    }
  ];

  // --- NEW DOMAIN MOCK DATA ---
  final List<Map<String, dynamic>> _mockVehicles = [
    {'name': 'Excavator (JCB 3DX)', 'plate': 'TN 38 BX 4455', 'status': 'Active on Site', 'operator': 'Ramesh Kumar'},
    {'name': 'Concrete Mixer Truck', 'plate': 'TN 43 AA 1122', 'status': 'In Transit', 'operator': 'Selvam'},
    {'name': 'Tractor with Trailer', 'plate': 'TN 38 CZ 9988', 'status': 'Maintenance', 'operator': 'Unassigned'},
  ];

  final List<Map<String, dynamic>> _mockMaterials = [
    {'item': 'Ramco Portland Cement', 'qty': '200 Bags', 'status': 'Delivered', 'date': '11-06-2026'},
    {'item': 'TMT Steel 12mm', 'qty': '1.5 Tons', 'status': 'In Transit', 'date': '12-06-2026'},
    {'item': 'River Sand', 'qty': '2 Loads', 'status': 'Requested', 'date': '13-06-2026'},
  ];

  final Map<String, dynamic> _mockWorkforce = {
    'total': 25,
    'breakdown': [
      {'role': 'Masons', 'count': 8, 'color': Colors.blue},
      {'role': 'Helpers / Bar Benders', 'count': 12, 'color': Colors.orange},
      {'role': 'Site Engineers', 'count': 2, 'color': Colors.green},
      {'role': 'Supervisors', 'count': 3, 'color': Colors.purple},
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
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
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.project.name,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProjectHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildPaymentsTab(),
                  _buildTasksTab(),
                  _buildDocumentsTab(),
                  _buildVehiclesTab(),
                  _buildMaterialsTab(),
                  _buildWorkforceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin/Contractor: ${widget.project.contractorName}',
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.project.status,
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Viewing records for:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(_formatDate(_selectedDate), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.black54,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Payments'),
          Tab(text: 'Tasks'),
          Tab(text: 'Files'),
          Tab(text: 'Vehicles'),
          Tab(text: 'Materials'),
          Tab(text: 'Workforce'),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: OVERVIEW (Daily Expenses)
  // ==========================================
  Widget _buildOverviewTab() {
    final dateStr = _formatDate(_selectedDate);
    final expenses = _mockOverviewExpenses[dateStr] ?? [];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProgressDonutChart(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Expenses for $dateStr', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              if (expenses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No expenses recorded for this date.', style: TextStyle(color: Colors.grey))),
                )
              else
                ...expenses.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: e['iconBg'], borderRadius: BorderRadius.circular(12)),
                            child: Icon(e['icon'], color: e['iconColor'], size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                const SizedBox(height: 4),
                                Text(e['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Text(e['amount'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressDonutChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          const Text('Overall Completion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            width: 140,
            child: CustomPaint(
              painter: DonutChartPainter(
                percentage: widget.project.completionPercentage / 100,
                color: AppColors.primary,
                backgroundColor: Colors.grey.shade200,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${widget.project.completionPercentage}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const Text('Completed', style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: PAYMENTS (Labour & Vendor Synced)
  // ==========================================
  Widget _buildPaymentsTab() {
    final dateStr = _formatDate(_selectedDate);
    final data = _mockPaymentExpenses[dateStr];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (data == null)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: const Center(child: Text('No payment data for this date.', style: TextStyle(color: Colors.grey))),
          )
        else
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('Total Paid on this Date', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(data['total'], style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPaymentStat('Workers', data['workers'], Icons.people),
                        _buildPaymentStat('Wages', data['salary'], Icons.money),
                        _buildPaymentStat('Tea/Snacks', data['tea'], Icons.coffee),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Payment Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 16),
                    ...(data['breakdown'] as List).map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.receipt_long, color: Colors.blue, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(b['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(b['subtitle'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(b['amount'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPaymentStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // ==========================================
  // TAB 3: TASKS
  // ==========================================
  Widget _buildTasksTab() {
    final tasks = [
      {'title': 'Concrete Curing (Ground Floor)', 'status': 'completed'},
      {'title': 'First Floor Pillar Formwork', 'status': 'in_progress'},
      {'title': 'Steel Binding for Beams', 'status': 'blocked', 'reason': 'Vendor delivery delayed'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tasks for ${_formatDate(_selectedDate)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ...tasks.map((task) {
                IconData icon;
                Color color;
                if (task['status'] == 'completed') {
                  icon = Icons.check_circle; color = Colors.green;
                } else if (task['status'] == 'blocked') {
                  icon = Icons.warning; color = Colors.red;
                } else {
                  icon = Icons.sync; color = AppColors.primary;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['title']!, style: TextStyle(fontWeight: FontWeight.bold, color: color == Colors.red ? Colors.red.shade700 : AppColors.textDark)),
                            if (task['status'] == 'blocked')
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('Reason: ${task['reason']}', style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 4: FILES (Docs & Photos)
  // ==========================================
  Widget _buildDocumentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shared Files', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._uploadedFiles.map((doc) {
                IconData icon = doc['type'] == 'pdf' ? Icons.picture_as_pdf : (doc['type'] == 'jpg' ? Icons.image : Icons.description);
                Color iconColor = doc['type'] == 'pdf' ? Colors.red : (doc['type'] == 'jpg' ? Colors.blue : Colors.green);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(icon, color: iconColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${doc['size']} • Uploaded ${doc['date']}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 5: VEHICLES [NEW]
  // ==========================================
  Widget _buildVehiclesTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assigned Machinery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._mockVehicles.map((v) {
                Color badgeColor = v['status'] == 'Active on Site' ? Colors.green : (v['status'] == 'In Transit' ? Colors.orange : Colors.red);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.local_shipping, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Plate: ${v['plate']} • Operator: ${v['operator']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(v['status'], style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 6: MATERIALS [NEW]
  // ==========================================
  Widget _buildMaterialsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Site Inventory & Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              ..._mockMaterials.map((m) {
                Color badgeColor = m['status'] == 'Delivered' ? Colors.green : (m['status'] == 'In Transit' ? Colors.orange : Colors.blue);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.inventory, color: Colors.orange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['item'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('Quantity: ${m['qty']} • Update: ${m['date']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(m['status'], style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 7: WORKFORCE [NEW]
  // ==========================================
  Widget _buildWorkforceTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today\'s Attendance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: Text('Total: ${_mockWorkforce['total']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...(_mockWorkforce['breakdown'] as List).map((w) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: w['color'], shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Expanded(child: Text(w['role'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                      Text('${w['count']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// CUSTOM PAINTERS
// ==========================================
class DonutChartPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  DonutChartPainter({required this.percentage, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
