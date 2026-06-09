import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class LeaveRequest {
  final String id;
  final String initials;
  final Color avatarColor;
  final String name;
  final String role;
  final String type;
  final String dateRange;
  final String reason;
  String status;

  LeaveRequest({
    required this.id,
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.role,
    required this.type,
    required this.dateRange,
    required this.reason,
    required this.status,
  });
}

class LeaveManagementPage extends StatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  State<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage> {
  final List<LeaveRequest> _leaves = [
    LeaveRequest(
      id: '1',
      initials: 'RK',
      avatarColor: const Color(0xFF06B6D4), // Cyan theme
      name: 'Raj Kumar',
      role: 'Supervisor',
      type: 'Sick Leave',
      dateRange: 'Jun 5, 2025 - Jun 7, 2025 (3 days)',
      reason: '"Not feeling well, fever."',
      status: 'pending',
    ),
    LeaveRequest(
      id: '2',
      initials: 'MK',
      avatarColor: const Color(0xFF8B5CF6), // Purple
      name: 'Muthu Kumar',
      role: 'Labour',
      type: 'Annual Leave',
      dateRange: 'Jun 14, 2025 - Jun 15, 2025 (2 days)',
      reason: '"Family function at hometown."',
      status: 'pending',
    ),
    LeaveRequest(
      id: '3',
      initials: 'PS',
      avatarColor: const Color(0xFF10B981), // Green
      name: 'Priya Suresh',
      role: 'Site Engineer',
      type: 'Casual Leave',
      dateRange: 'Jun 10, 2025 - Jun 11, 2025 (2 days)',
      reason: '"Personal work."',
      status: 'approved',
    ),
    LeaveRequest(
      id: '4',
      initials: 'AV',
      avatarColor: const Color(0xFFEF4444), // Red
      name: 'Anand Vel',
      role: 'Labour',
      type: 'Emergency Leave',
      dateRange: 'Jun 1, 2025 (1 day)',
      reason: '"Family emergency."',
      status: 'rejected',
    ),
  ];

  void _updateLeaveStatus(String id, String newStatus) {
    setState(() {
      final index = _leaves.indexWhere((l) => l.id == id);
      if (index != -1) {
        _leaves[index].status = newStatus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: const Text(
            'Leave Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color(0xFF06B6D4), // Primary Cyan
            labelColor: Color(0xFF06B6D4),
            unselectedLabelColor: Colors.white54,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLeaveList('pending'),
            _buildLeaveList('approved'),
            _buildLeaveList('rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveList(String status) {
    final filteredLeaves = _leaves.where((l) => l.status == status).toList();

    if (filteredLeaves.isEmpty) {
      return const Center(
        child: Text(
          'No leaves found in this category.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredLeaves.length,
      itemBuilder: (context, index) {
        final leave = filteredLeaves[index];
        return _buildLeaveCard(leave);
      },
    );
  }

  Widget _buildLeaveCard(LeaveRequest leave) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: leave.avatarColor,
                child: Text(
                  leave.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        leave.name,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${leave.role})',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    leave.type,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            leave.dateRange,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (leave.status == 'pending') ...[
            const SizedBox(height: 4),
            Text(
              leave.reason,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateLeaveStatus(leave.id, 'rejected'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2), // Light red
                      foregroundColor: const Color(0xFFEF4444), // Red text
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateLeaveStatus(leave.id, 'approved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1FAE5), // Light green
                      foregroundColor: const Color(0xFF10B981), // Green text
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: leave.status == 'approved' ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                leave.status.toUpperCase(),
                style: TextStyle(
                  color: leave.status == 'approved' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
