import 'package:flutter/material.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';
import 'package:construction_ms_ui/features/projects/presentation/pages/new_project_page.dart';
import 'package:construction_ms_ui/features/projects/presentation/pages/project_details_page.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'All';
  bool _isLoading = true;
  List<Map<String, dynamic>> _projects = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      final response = await _apiService.get('/projects');
      if (response != null && response is List) {
        setState(() {
          _projects = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching projects: $e');
      setState(() => _isLoading = false);
    }
  }

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
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)))
                : _projects.isEmpty 
                  ? const Center(child: Text('No projects found', style: TextStyle(color: Colors.grey)))
                  : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  ..._projects.where((p) {
                    if (_selectedFilter == 'All') return true;
                    if (_selectedFilter == 'Commercial' && (p['projectType']?.toString().toUpperCase() == 'COMMERCIAL')) return true;
                    if (_selectedFilter == 'Residential' && (p['projectType']?.toString().toUpperCase() == 'RESIDENTIAL')) return true;
                    return false;
                  }).map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildProjectCard(p),
                  )),
                  const SizedBox(height: 80), // Fab space
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewProjectPage()),
          );
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _projects.insert(0, result);
            });
          }
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

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final type = project['projectType']?.toString().toUpperCase() ?? 'UNKNOWN';
    final title = project['name'] ?? 'Unnamed Project';
    
    String subtitle = project['address'] ?? '';
    if (project['numFloors'] != null) {
      subtitle = '${project['numFloors']} Floors · $subtitle';
    }

    final progress = 0.0; // Future: Calculate from DB
    final progressText = '0%';
    
    String dateRange = 'Not Set';
    if (project['startDate'] != null && project['endDate'] != null) {
      final start = DateTime.tryParse(project['startDate']);
      final end = DateTime.tryParse(project['endDate']);
      if (start != null && end != null) {
        dateRange = '${DateFormat('MMM yyyy').format(start)} - ${DateFormat('MMM yyyy').format(end)}';
      }
    }

    final statusColor = Colors.teal;
    
    List<String> avatars = [];
    if (project['assignments'] != null && project['assignments'] is List) {
      for (var a in project['assignments']) {
        if (a['user'] != null && a['user']['fullName'] != null) {
          final nameParts = a['user']['fullName'].toString().split(' ');
          if (nameParts.length >= 2) {
            avatars.add('${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase());
          } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
            avatars.add('${nameParts[0][0]}'.toUpperCase());
          }
        }
      }
    }
    if (avatars.isEmpty) avatars = ['?'];
    final isCommercial = type == 'COMMERCIAL';
    final badgeColor = isCommercial ? const Color(0xFFDBEAFE) : const Color(0xFFD1FAE5);
    final badgeTextColor = isCommercial ? const Color(0xFF2563EB) : const Color(0xFF059669);
    final progressBarColor = isCommercial ? const Color(0xFF06B6D4) : const Color(0xFF10B981);

    return GestureDetector(
      onTap: () {
        if (project['id'] == null) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(
              projectId: project['id'],
            ),
          ),
        ).then((_) => _fetchProjects());
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
