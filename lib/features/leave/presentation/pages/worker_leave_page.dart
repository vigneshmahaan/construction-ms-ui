import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/core/network/api_service.dart';

class WorkerLeavePage extends StatefulWidget {
  const WorkerLeavePage({super.key});

  @override
  State<WorkerLeavePage> createState() => _WorkerLeavePageState();
}

class _WorkerLeavePageState extends State<WorkerLeavePage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _fromDate != null && _toDate != null && _reasonController.text.trim().isNotEmpty;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10B981), // Green theme for worker
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          // Reset toDate if it's before fromDate
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = null;
          }
        } else {
          // ensure toDate is not before fromDate
          if (_fromDate != null && picked.isBefore(_fromDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('To Date cannot be before From Date')),
            );
          } else {
            _toDate = picked;
          }
        }
        _validateForm();
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  Future<void> _submitLeaveRequest() async {
    if (_fromDate == null || _toDate == null || _reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields to submit the request.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      await api.post('/leave-requests', {
        // Ideally from auth state
        'user': { 'connect': { 'id': 'mock-worker-id' } }, 
        'startDate': _fromDate!.toIso8601String(),
        'endDate': _toDate!.toIso8601String(),
        'reason': _reasonController.text.trim(),
        'status': 'PENDING',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leave request submitted successfully! Pending approval.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit leave: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Request Leave',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Details',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please provide the duration and reason for your leave request. It will be sent to the admin for approval.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Date Selection
            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'From Date',
                    date: _fromDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'To Date',
                    date: _toDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Reason Text Area
            const Text(
              'Reason for Leave',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 5,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g., Family emergency, medical appointment...',
                  hintStyle: TextStyle(color: Colors.black26),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isFormValid && !_isLoading) ? _submitLeaveRequest : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // Green for worker theme
                  disabledBackgroundColor: const Color(0xFF10B981).withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _isFormValid ? 2 : 0,
                ),
                child: _isLoading 
                    ? const SizedBox(
                        width: 24, 
                        height: 24, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        'Submit Request',
                        style: TextStyle(
                          color: _isFormValid ? Colors.white : Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: date == null ? Colors.black38 : const Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: date == null ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: date == null ? Colors.black38 : const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
