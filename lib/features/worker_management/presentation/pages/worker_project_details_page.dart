import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/shared/presentation/widgets/chat_interface.dart';

class WorkerProjectDetailsPage extends StatefulWidget {
  final String projectId;
  final String projectName;

  const WorkerProjectDetailsPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<WorkerProjectDetailsPage> createState() => _WorkerProjectDetailsPageState();
}

class _WorkerProjectDetailsPageState extends State<WorkerProjectDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock permissions for this worker. In a real app, these are fetched from the Worker model.
  final Map<String, bool> _permissions = {
    'canUpdateTasks': true,
    'canUploadPhotos': true,
    'canRequestMaterials': false, // Let's set to false to test hiding
  };

  late List<String> _availableTabs;

  @override
  void initState() {
    super.initState();
    _availableTabs = [];
    if (_permissions['canUpdateTasks'] == true) _availableTabs.add('Tasks');
    if (_permissions['canUploadPhotos'] == true) _availableTabs.add('Photos');
    if (_permissions['canRequestMaterials'] == true) _availableTabs.add('Materials');
    _availableTabs.add('Chat');

    // If all are false, at least show an Overview or empty state.
    if (_availableTabs.isEmpty) _availableTabs.add('Overview');

    _tabController = TabController(length: _availableTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          widget.projectName,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProjectHeader(),
            if (_availableTabs.isNotEmpty) _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _availableTabs.map((tab) {
                  if (tab == 'Tasks') return _buildTasksTab();
                  if (tab == 'Photos') return _buildPhotosTab();
                  if (tab == 'Materials') return _buildMaterialsTab();
                  if (tab == 'Chat') return _buildChatTab();
                  return const Center(child: Text('No Permissions Assigned', style: TextStyle(color: Colors.grey)));
                }).toList(),
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
            children: [
              const Text(
                'Today\'s View',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('11-06-2026', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
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
        isScrollable: _availableTabs.length > 3,
        labelColor: const Color(0xFF10B981),
        unselectedLabelColor: Colors.black54,
        indicatorColor: const Color(0xFF10B981),
        indicatorWeight: 3,
        tabs: _availableTabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  // ==========================================
  // TAB: TASKS
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Assigned Tasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text('Add Task', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ...tasks.map((task) {
                IconData icon;
                Color color;
                if (task['status'] == 'completed') {
                  icon = Icons.check_circle; color = Colors.green;
                } else if (task['status'] == 'blocked') {
                  icon = Icons.warning; color = Colors.red;
                } else {
                  icon = Icons.sync; color = const Color(0xFF10B981);
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
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: Colors.black54),
                        onPressed: () {}, // Action to update status
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
  // TAB: PHOTOS
  // ==========================================
  Widget _buildPhotosTab() {
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
                  const Text('Site Photos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    label: const Text('Upload', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  )
                ],
              ),
              const SizedBox(height: 32),
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No photos uploaded today.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB: MATERIALS
  // ==========================================
  Widget _buildMaterialsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildMaterialCard('Cement (Ramco)', '200 Bags', 'Delivered', Colors.green),
        _buildMaterialCard('Steel (12mm)', '1.5 Tons', 'Pending', Colors.orange),
        _buildMaterialCard('Bricks', '5000 Nos', 'Requested', Colors.blue),
        const SizedBox(height: 24),
        if (_permissions['canRequestMaterials'] == true)
          ElevatedButton.icon(
            onPressed: () {
              // Open request bottom sheet
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Request New Material', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Read-Only Mode. You cannot request new materials.',
                    style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMaterialCard(String name, String qty, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(qty, style: const TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return ChatInterface(
      title: '${widget.projectName} Group',
      subtitle: 'Admin, You, Dinesh, Sruthi',
      initialMessages: [
        ChatMessage(
          senderId: 'admin',
          senderName: 'Admin',
          text: 'Hi team, please ensure the first floor concreting is done by tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 60)),
          isMe: false,
        ),
        ChatMessage(
          senderId: 'w2',
          senderName: 'Dinesh',
          text: 'Yes sir, we have received the cement. Will start in the morning.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
          isMe: false,
        ),
        ChatMessage(
          senderId: 'me',
          senderName: 'You',
          text: 'I will coordinate the mixer trucks.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isMe: true,
        ),
      ],
    );
  }
}
