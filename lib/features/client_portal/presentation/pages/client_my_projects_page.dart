import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../../data/models/project_models.dart';
import '../../data/services/client_project_service.dart';
import 'client_project_details_page.dart';

class ClientMyProjectsPage extends StatefulWidget {
  const ClientMyProjectsPage({super.key});

  @override
  State<ClientMyProjectsPage> createState() => _ClientMyProjectsPageState();
}

class _ClientMyProjectsPageState extends State<ClientMyProjectsPage> {
  final ClientProjectService _projectService = ClientProjectService();

  @override
  void initState() {
    super.initState();
    _projectService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _projectService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final activeProjects = _projectService.activeProjects;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Projects',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: activeProjects.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: activeProjects.map((p) => _buildProjectCard(p)).toList(),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'My Projects',
            style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'A complete history of your active and past projects will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ClientProject project) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientProjectDetailsPage(project: project)),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project.name,
                style: const TextStyle(color: AppColors.textDark, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.status,
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Contractor: ${project.contractorName}',
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overall Progress', style: TextStyle(color: Colors.black54, fontSize: 14)),
              Text('${project.completionPercentage}%', style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: project.completionPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(project.recentUpdate, style: const TextStyle(color: AppColors.textDark, fontSize: 13))),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
