import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedSite = 'Green Valley';
  DateTime _startDate = DateTime(2026, 5, 5);
  DateTime _endDate = DateTime(2026, 6, 5);

  final Map<String, Map<String, dynamic>> _siteData = {
    'Green Valley': {
      'totalProjects': '8',
      'activeSites': '5',
      'avgProgress': '68%',
      'chartData': [0.5, 0.6, 0.8, 0.5, 0.9, 0.65, 0.45],
      'poBills': '₹48.5L',
      'payments': '₹31.2L',
      'labour': '142',
      'pending': '7',
      'leaves': [
        {'initials': 'RK', 'name': 'Raj Kumar', 'details': 'Jun 5-7 · Sick Leave', 'status': 'PENDING', 'statusBg': const Color(0xFFFEF3C7), 'statusText': const Color(0xFFD97706), 'avatarBg': const Color(0xFF3B82F6)},
        {'initials': 'PS', 'name': 'Priya Suresh', 'details': 'Jun 10-11 · Casual Leave', 'status': 'APPROVED', 'statusBg': const Color(0xFFD1FAE5), 'statusText': const Color(0xFF059669), 'avatarBg': const Color(0xFF10B981)},
        {'initials': 'MK', 'name': 'Muthu Kumar', 'details': 'Jun 14-15 · Annual Leave', 'status': 'REJECTED', 'statusBg': const Color(0xFFFEE2E2), 'statusText': const Color(0xFFDC2626), 'avatarBg': const Color(0xFF06B6D4)},
      ],
    },
    'Metro Towers': {
      'totalProjects': '12',
      'activeSites': '8',
      'avgProgress': '82%',
      'chartData': [0.3, 0.4, 0.5, 0.7, 0.8, 0.85, 0.9],
      'poBills': '₹120.5L',
      'payments': '₹98.2L',
      'labour': '340',
      'pending': '12',
      'leaves': [
        {'initials': 'AS', 'name': 'Arun Sharma', 'details': 'Jun 1-3 · Casual Leave', 'status': 'APPROVED', 'statusBg': const Color(0xFFD1FAE5), 'statusText': const Color(0xFF059669), 'avatarBg': const Color(0xFF8B5CF6)},
        {'initials': 'VJ', 'name': 'Vijay Kumar', 'details': 'Jun 12-14 · Sick Leave', 'status': 'PENDING', 'statusBg': const Color(0xFFFEF3C7), 'statusText': const Color(0xFFD97706), 'avatarBg': const Color(0xFFEF4444)},
      ],
    },
    'Sunrise Villa': {
      'totalProjects': '3',
      'activeSites': '1',
      'avgProgress': '45%',
      'chartData': [0.2, 0.3, 0.25, 0.4, 0.35, 0.45, 0.5],
      'poBills': '₹12.1L',
      'payments': '₹8.5L',
      'labour': '45',
      'pending': '2',
      'leaves': [
        {'initials': 'KR', 'name': 'Karthik R', 'details': 'Jun 8-9 · Casual Leave', 'status': 'PENDING', 'statusBg': const Color(0xFFFEF3C7), 'statusText': const Color(0xFFD97706), 'avatarBg': const Color(0xFF3B82F6)},
      ],
    },
    'Site 4': {
      'totalProjects': '5',
      'activeSites': '2',
      'avgProgress': '50%',
      'chartData': [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4],
      'poBills': '₹20.0L',
      'payments': '₹10.0L',
      'labour': '60',
      'pending': '5',
      'leaves': [],
    },
    'Site 5': {
      'totalProjects': '10',
      'activeSites': '7',
      'avgProgress': '90%',
      'chartData': [0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9],
      'poBills': '₹200.0L',
      'payments': '₹150.0L',
      'labour': '500',
      'pending': '1',
      'leaves': [],
    },
  };

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06B6D4), 
              onPrimary: Colors.white, 
              onSurface: Color(0xFF0F172A), 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _siteData[_selectedSite]!;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const CustomDrawer(),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterRow(),
              const SizedBox(height: 16),
              _buildSummaryCards(currentData),
              const SizedBox(height: 16),
              _buildChartCard(currentData['chartData']),
              const SizedBox(height: 16),
              _buildQuickOverviewCard(currentData),
              const SizedBox(height: 16),
              _buildRecentLeaveRequests(currentData['leaves']),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      leading: IconButton(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 20, height: 2, decoration: BoxDecoration(color: const Color(0xFF06B6D4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 5),
            Container(width: 12, height: 2, decoration: BoxDecoration(color: const Color(0xFF06B6D4), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 5),
            Container(width: 16, height: 2, decoration: BoxDecoration(color: const Color(0xFF06B6D4), borderRadius: BorderRadius.circular(2))),
          ],
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text.rich(
        TextSpan(
          text: 'Aatzy',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'Build',
              style: TextStyle(color: Color(0xFF06B6D4)),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.sync, color: Colors.white54),
          onPressed: () {},
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: PopupMenuButton<String>(
            initialValue: _selectedSite,
            offset: const Offset(0, 40), // Drops it perfectly below the button
            constraints: const BoxConstraints(maxHeight: 180), // Approx 4 items max height
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (val) {
              setState(() {
                _selectedSite = val;
              });
            },
            itemBuilder: (context) {
              return _siteData.keys.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  height: 45, // Set item height
                  child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                );
              }).toList();
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedSite,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                child: _buildDatePicker(_startDate, true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('-', style: TextStyle(color: Colors.grey)),
              ),
              Expanded(
                child: _buildDatePicker(_endDate, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(DateTime date, bool isStart) {
    final dateStr = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    return InkWell(
      onTap: () => _selectDate(context, isStart),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateStr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(child: _buildSmallCard(Icons.home_outlined, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), data['totalProjects'], 'Total Projects', isSelected: true)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallCard(Icons.access_time, const Color(0xFF10B981), const Color(0xFFECFDF5), data['activeSites'], 'Active Sites')),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallCard(Icons.show_chart, const Color(0xFF06B6D4), const Color(0xFFFEF3C7), data['avgProgress'], 'Avg Progress')),
      ],
    );
  }

  Widget _buildSmallCard(IconData icon, Color iconColor, Color bgColor, String value, String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildChartCard(List<double> chartData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Projects Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: const Text('2025', style: TextStyle(fontSize: 11, color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Jan', chartData[0], false),
                _buildBar('Feb', chartData[1], false),
                _buildBar('Mar', chartData[2], true),
                _buildBar('Apr', chartData[3], false),
                _buildBar('May', chartData[4], true),
                _buildBar('Jun', chartData[5], false),
                _buildBar('Jul', chartData[6], false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double fillHeight, bool isOrange) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 100 * fillHeight,
          decoration: BoxDecoration(
            color: isOrange ? const Color(0xFF06B6D4) : const Color(0xFF60A5FA),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45)),
      ],
    );
  }

  Widget _buildQuickOverviewCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Overview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildOverviewItem(data['poBills'], 'Total PO Bills', const Color(0xFF06B6D4))),
              Expanded(child: _buildOverviewItem(data['payments'], 'Payments Made', const Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildOverviewItem(data['labour'], 'Labour Count', const Color(0xFF3B82F6))),
              Expanded(child: _buildOverviewItem(data['pending'], 'Pending Actions', const Color(0xFFEF4444))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String value, String label, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }

  Widget _buildRecentLeaveRequests(List<dynamic> leaves) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Leave Requests', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Text('View All', style: TextStyle(fontSize: 12, color: Color(0xFF06B6D4), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ...leaves.map((leave) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildLeaveItem(
                leave['initials'], 
                leave['name'], 
                leave['details'], 
                leave['status'], 
                leave['statusBg'], 
                leave['statusText'], 
                leave['avatarBg']
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeaveItem(String initials, String name, String details, String status, Color statusBg, Color statusText, Color avatarBg) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: avatarBg,
          child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(details, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
          child: Text(status, style: TextStyle(color: statusText, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
