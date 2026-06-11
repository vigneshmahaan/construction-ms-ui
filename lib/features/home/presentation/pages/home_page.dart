import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';
import 'package:construction_ms_ui/features/projects/presentation/pages/new_project_page.dart';
import 'package:construction_ms_ui/features/projects/presentation/pages/project_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 12,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 16,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Projects',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilters(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  if (_selectedFilter == 'All' || _selectedFilter == 'Commercial') ...[
                    _buildProjectCard(
                      type: 'COMMERCIAL',
                      title: 'Metro Towers Phase 2',
                      subtitle: '12 Floors · Duplex · Chennai, TN',
                      progress: 0.72,
                      progressText: '72%',
                      dateRange: 'Jan 2025 - Dec 2025',
                      statusColor: Colors.teal,
                      avatars: ['RK', 'SK', 'PM'],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedFilter == 'All' || _selectedFilter == 'Residential') ...[
                    _buildProjectCard(
                      type: 'RESIDENTIAL',
                      title: 'Sunrise Villa',
                      subtitle: '3 Floors · Simplex · Coimbatore, TN',
                      progress: 0.45,
                      progressText: '45%',
                      dateRange: 'Mar 2025 - Nov 2025',
                      statusColor: Colors.green,
                      avatars: ['MK', 'VR'],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedFilter == 'All' || _selectedFilter == 'Commercial') ...[
                    _buildProjectCard(
                      type: 'COMMERCIAL',
                      title: 'Green Valley Complex',
                      subtitle: '8 Floors · Duplex · Madurai, TN',
                      progress: 0.91,
                      progressText: '91%',
                      dateRange: 'Sep 2024 - Jun 2025',
                      statusColor: Colors.amber,
                      avatars: ['AK'],
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 80), // Fab space
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewProjectPage()),
          );
        },
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 12),
          _buildFilterChip('Commercial'),
          const SizedBox(width: 12),
          _buildFilterChip('Residential'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF3C7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFD97706) : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required String type,
    required String title,
    required String subtitle,
    required double progress,
    required String progressText,
    required String dateRange,
    required Color statusColor,
    required List<String> avatars,
  }) {
    final isCommercial = type == 'COMMERCIAL';
    final badgeColor = isCommercial ? const Color(0xFFDBEAFE) : const Color(0xFFD1FAE5);
    final badgeTextColor = isCommercial ? const Color(0xFF2563EB) : const Color(0xFF059669);
    final progressBarColor = isCommercial ? const Color(0xFF06B6D4) : const Color(0xFF10B981);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(
              title: title,
              type: type,
              subtitle: subtitle,
              progress: progress,
              dateRange: dateRange,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                progressText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    dateRange,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              Row(
                children: _buildAvatars(avatars),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildAvatars(List<String> initialsList) {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF06B6D4),
      const Color(0xFF10B981),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];

    List<Widget> widgets = [];
    for (int i = 0; i < initialsList.length; i++) {
      widgets.add(
        Align(
          widthFactor: 0.7,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: colors[i % colors.length],
              child: Text(
                initialsList[i],
                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
