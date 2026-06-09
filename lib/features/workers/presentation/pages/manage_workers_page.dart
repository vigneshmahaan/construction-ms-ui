import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/home/presentation/widgets/custom_drawer.dart';
import 'package:construction_ms_ui/shared/models/worker.dart';
import 'package:construction_ms_ui/shared/services/worker_service.dart';
import 'package:construction_ms_ui/features/workers/presentation/widgets/add_worker_sheet.dart';

class ManageWorkersPage extends StatefulWidget {
  const ManageWorkersPage({super.key});

  @override
  State<ManageWorkersPage> createState() => _ManageWorkersPageState();
}

class _ManageWorkersPageState extends State<ManageWorkersPage> {
  final WorkerService _workerService = WorkerService();

  @override
  void initState() {
    super.initState();
    _workerService.addListener(_onWorkersChanged);
  }

  @override
  void dispose() {
    _workerService.removeListener(_onWorkersChanged);
    super.dispose();
  }

  void _onWorkersChanged() {
    setState(() {});
  }

  void _showAddWorkerSheet({Worker? workerToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddWorkerSheet(workerToEdit: workerToEdit),
    );
  }

  void _showWorkerDetails(Worker worker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Worker Details',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundImage: worker.profileImageUrl != null
                  ? NetworkImage(worker.profileImageUrl!)
                  : null,
              child: worker.profileImageUrl == null
                  ? const Icon(Icons.person, color: AppColors.primary, size: 40)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              worker.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              worker.role,
              style: const TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(Icons.phone, 'Phone', '+91 ${worker.phone}'),
            const SizedBox(height: 12),
            _buildDetailRow(
                Icons.currency_rupee, '${worker.payType} Wage', '₹${worker.wageAmount}'),
            const SizedBox(height: 12),
            _buildDetailRow(
                Icons.badge, 'ID Proof', '${worker.idProofType} (${worker.idProofNumber})'),
            const SizedBox(height: 12),
            if (worker.city.isNotEmpty || worker.state.isNotEmpty) ...[
              _buildDetailRow(Icons.location_city, 'Location',
                  [worker.city, worker.state].where((e) => e.isNotEmpty).join(', ')),
              const SizedBox(height: 32),
            ] else
              const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAddWorkerSheet(workerToEdit: worker);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _workerService.deleteWorker(worker.id);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  ),
);
}

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final workers = _workerService.workers;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Manage Workers',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: workers.isEmpty
          ? const Center(
              child: Text(
                'No workers added yet.\nClick + to add a new worker.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final worker = workers[index];
                return InkWell(
                  onTap: () => _showWorkerDetails(worker),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: worker.profileImageUrl != null
                              ? NetworkImage(worker.profileImageUrl!)
                              : null,
                          child: worker.profileImageUrl == null
                              ? const Icon(Icons.person,
                                  color: AppColors.primary)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                worker.name,
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${worker.role} · +91 ${worker.phone}',
                                style: const TextStyle(
                                    color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkerSheet(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
