import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/material_indent/data/models/material_indent_model.dart';
import 'package:intl/intl.dart';

class IndentDetailsSheet extends StatelessWidget {
  final MaterialIndent indent;
  final Function(IndentStatus) onStatusChanged;

  const IndentDetailsSheet({
    Key? key, 
    required this.indent,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Indent Details',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(),
          const SizedBox(height: 24),
          const Text(
            'Requested Materials',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMaterialsTable(),
          const SizedBox(height: 24),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  onStatusChanged(IndentStatus.rejected);
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDC2626)), // Red border
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Reject', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onStatusChanged(IndentStatus.approved);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), // Emerald green
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                indent.id,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildStatusPill(indent.status),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Site', indent.siteName),
          const SizedBox(height: 6),
          _buildInfoRow('Requested By', indent.assignedTo),
          const SizedBox(height: 6),
          _buildInfoRow('Required Date', DateFormat('MMM dd, yyyy').format(indent.endDate)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatusPill(IndentStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case IndentStatus.pending:
        bgColor = const Color(0xFFFEF3C7); // Amber 100
        textColor = const Color(0xFFD97706); // Amber 600
        text = 'PENDING';
        break;
      case IndentStatus.approved:
        bgColor = const Color(0xFFD1FAE5); // Emerald 100
        textColor = const Color(0xFF059669); // Emerald 600
        text = 'APPROVED';
        break;
      case IndentStatus.rejected:
        bgColor = const Color(0xFFFEE2E2); // Red 100
        textColor = const Color(0xFFDC2626); // Red 600
        text = 'REJECTED';
        break;
    }

    // In dark mode, we might want slightly darker backgrounds, but the screenshot shows very light pills on the card.
    // Wait, the detail sheet screenshot shows a dark pill with green text for APPROVED? 
    // Let's use an opaque background with matching colors.
    if (status == IndentStatus.approved) {
      bgColor = const Color(0xFF059669).withOpacity(0.2);
      textColor = const Color(0xFF10B981);
    } else if (status == IndentStatus.pending) {
      bgColor = const Color(0xFFD97706).withOpacity(0.2);
      textColor = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMaterialsTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Material', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                Text('Qty', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(color: Color(0xFF334155), height: 1),
          // Rows
          ...indent.materials.asMap().entries.map((entry) {
            final int idx = entry.key;
            final MaterialItem item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        item.quantity,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                if (idx < indent.materials.length - 1)
                  const Divider(color: Color(0xFF334155), height: 1),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
