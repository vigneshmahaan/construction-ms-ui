import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/widgets/worker_drawer.dart';
import 'package:construction_ms_ui/features/worker_management/presentation/pages/worker_project_details_page.dart';
import 'package:construction_ms_ui/shared/services/auth_service.dart';
import 'package:construction_ms_ui/shared/services/worker_service.dart';

class SupervisorHomePage extends StatelessWidget {
  const SupervisorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWorkerId = AuthService.currentWorkerId;
    final worker = WorkerService().workers.firstWhere(
      (w) => w.id == currentWorkerId,
      orElse: () => WorkerService().workers.first,
    );

    // Master list of mock projects to match IDs against
    final allProjects = [
      {'id': 'home1', 'name': 'Home 1', 'status': 'In Progress', 'location': 'Chennai'},
      {'id': 'home2', 'name': 'Home 2', 'status': 'Planning', 'location': 'Bangalore'},
    ];

    // Filter to only the assigned projects for this worker
    final assignedProjects = allProjects
        .where((p) => worker.assignedProjectIds.contains(p['id']))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'My Assigned Projects',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const WorkerDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${worker.name}',
                style: const TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a project to update tasks or request materials.',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ...assignedProjects.map((p) => _buildProjectCard(context, p)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, String> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerProjectDetailsPage(
                projectId: project['id']!,
                projectName: project['name']!,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project['name']!,
                      style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project['status']!,
                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black54, size: 14),
                  const SizedBox(width: 4),
                  Text(project['location']!, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('Tap to manage project', style: TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF10B981), size: 12),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
