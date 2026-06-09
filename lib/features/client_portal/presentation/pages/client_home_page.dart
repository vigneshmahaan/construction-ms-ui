import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../../data/models/project_models.dart';
import '../../data/services/client_project_service.dart';
import '../widgets/client_drawer.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ClientProjectService _projectService = ClientProjectService();

  @override
  void initState() {
    super.initState();
    _projectService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _projectService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pendingInvites = _projectService.pendingInvites;
    final activeProjects = _projectService.activeProjects;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
        title: const Text(
          'AATZY BUILD',
          style: TextStyle(
            color: Color(0xFF06B6D4),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const ClientDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Client User',
                style: TextStyle(color: AppColors.textDark, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              if (pendingInvites.isNotEmpty) ...[
                _buildInvitesSection(pendingInvites),
                const SizedBox(height: 32),
              ],

              const Text(
                'Active Projects',
                style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              if (activeProjects.isEmpty)
                _buildEmptyState()
              else
                ...activeProjects.map((p) => _buildProjectCard(p)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvitesSection(List<ProjectInvite> invites) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pending Invitations',
          style: TextStyle(color: Color(0xFF06B6D4), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...invites.map((invite) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.maps_home_work_rounded, color: Color(0xFF06B6D4)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invite.projectName,
                          style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invited by ${invite.adminName}',
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _projectService.declineInvite(invite.id),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Decline', style: TextStyle(color: Colors.red.shade400)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _projectService.acceptInvite(invite.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.architecture_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No Active Projects',
            style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'When a contractor invites you to a project, it will appear here after you accept the invitation.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ClientProject project) {
    return Container(
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
          
          // Progress Bar
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
          const SizedBox(height: 24),

          // Financial Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Amount Paid', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '₹${(project.amountPaid / 100000).toStringAsFixed(1)}L',
                        style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Next Payment', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          project.nextPaymentDate,
                          style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Recent Update
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Latest Update', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(project.recentUpdate, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
