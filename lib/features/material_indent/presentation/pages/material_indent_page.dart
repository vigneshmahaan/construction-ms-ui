import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/material_indent/data/models/material_indent_model.dart';
import 'package:construction_ms_ui/features/material_indent/presentation/widgets/new_indent_sheet.dart';
import 'package:construction_ms_ui/features/material_indent/presentation/widgets/indent_details_sheet.dart';
import 'package:intl/intl.dart';

class MaterialIndentPage extends StatefulWidget {
  final bool openNewIndentOnInit;

  const MaterialIndentPage({super.key, this.openNewIndentOnInit = false});

  @override
  State<MaterialIndentPage> createState() => _MaterialIndentPageState();
}

class _MaterialIndentPageState extends State<MaterialIndentPage> {
  List<MaterialIndent> indents = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    indents = List.from(mockIndents);
    
    if (widget.openNewIndentOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNewIndentSheet();
      });
    }
  }

  void _showNewIndentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => NewIndentSheet(
        onSave: (newIndent) {
          setState(() {
            indents.insert(0, newIndent);
          });
        },
      ),
    );
  }

  void _showIndentDetails(MaterialIndent indent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => IndentDetailsSheet(
        indent: indent,
        onStatusChanged: (newStatus) {
          setState(() {
            indent.status = newStatus;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndents = indents
        .where((i) => i.id.toLowerCase().contains(searchQuery.toLowerCase()) || 
                      i.siteName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Material Indent',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white54),
            onPressed: _showNewIndentSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search indents...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredIndents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildIndentCard(filteredIndents[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewIndentSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildIndentCard(MaterialIndent indent) {
    return InkWell(
      onTap: () => _showIndentDetails(indent),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  indent.id,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildTopRightPill(indent),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.arrow_right_alt, color: Color(0xFF64748B), size: 16),
                const SizedBox(width: 4),
                Text(
                  indent.siteName,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              indent.summaryText,
              style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due: ${DateFormat('MMM dd').format(indent.endDate)} · ${indent.assignedTo}',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                _buildBottomRightPill(indent.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRightPill(MaterialIndent indent) {
    Color bgColor;
    Color textColor;
    String text;

    if (indent.priority == IndentPriority.high) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      text = 'HIGH';
    } else {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      text = 'LOW';
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

  Widget _buildBottomRightPill(IndentStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    if (status == IndentStatus.pending) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      text = 'PENDING';
    } else if (status == IndentStatus.approved) {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      text = 'APPROVED';
    } else {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      text = 'REJECTED';
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
}
