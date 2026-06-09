import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../../../home/presentation/widgets/custom_drawer.dart';
import '../../../crm_settings/presentation/pages/crm_settings_page.dart';
import '../widgets/add_lead_bottom_sheet.dart';
import '../widgets/lead_details_bottom_sheet.dart';

class Lead {
  final String id;
  final String initials;
  final Color avatarColor;
  final String name;
  final String phone;
  final String city;
  final String source;
  final String pipeline;
  final String requirements;
  final String status;

  Lead({
    required this.id,
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.phone,
    required this.city,
    required this.source,
    required this.pipeline,
    required this.requirements,
    required this.status,
  });
}

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  final List<Lead> _leads = [
    Lead(
      id: '1',
      initials: 'AK',
      avatarColor: const Color(0xFF3B82F6), // Blue
      name: 'Arun Kumar',
      phone: '+91 98451 77720',
      city: 'Salem',
      source: 'JustDial',
      pipeline: 'Sales Pipeline',
      requirements: 'Requirements: 3BHK, Budget ~₹80L',
      status: 'Site Visit',
    ),
    Lead(
      id: '2',
      initials: 'PM',
      avatarColor: const Color(0xFF06B6D4), // Cyan
      name: 'Prabhakaran M',
      phone: '+91 77771 44420',
      city: 'Chennai',
      source: 'Facebook',
      pipeline: 'Sales Pipeline',
      requirements: 'Requirements: Commercial space, ~2000 sqft',
      status: 'Initial Call',
    ),
    Lead(
      id: '3',
      initials: 'KV',
      avatarColor: const Color(0xFF10B981), // Green
      name: 'Kavitha Vasan',
      phone: '+91 63631 88810',
      city: 'Coimbatore',
      source: 'Referral',
      pipeline: 'Sales Pipeline',
      requirements: 'Requirements: Villa, 4BHK, Budget ₹1.2Cr',
      status: 'Advance Paid',
    ),
  ];

  void _showAddLeadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddLeadBottomSheet(),
      ),
    );
  }

  void _showLeadDetailsSheet(BuildContext context, Lead lead) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeadDetailsBottomSheet(
        leadName: lead.name,
        initials: lead.initials,
        status: lead.status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: const Text(
          'CRM Leads',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrmSettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.black54),
                  hintText: 'Search leads...',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          // Leads List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _leads.length,
              itemBuilder: (context, index) {
                final lead = _leads[index];
                return _buildLeadCard(lead);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLeadSheet(context),
        backgroundColor: const Color(0xFF06B6D4), // Cyan theme
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    Color statusBgColor;
    Color statusTextColor;

    if (lead.status == 'Site Visit') {
      statusBgColor = const Color(0xFF3B82F6).withValues(alpha: 0.15);
      statusTextColor = const Color(0xFF3B82F6);
    } else if (lead.status == 'Initial Call') {
      statusBgColor = const Color(0xFF8B5CF6).withValues(alpha: 0.15);
      statusTextColor = const Color(0xFF8B5CF6);
    } else {
      statusBgColor = const Color(0xFF10B981).withValues(alpha: 0.15);
      statusTextColor = const Color(0xFF10B981);
    }

    return GestureDetector(
      onTap: () => _showLeadDetailsSheet(context, lead),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: lead.avatarColor,
                  radius: 20,
                  child: Text(
                    lead.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.name,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lead.phone} · ${lead.city}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lead.status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    lead.source,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  lead.pipeline,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lead.requirements,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
