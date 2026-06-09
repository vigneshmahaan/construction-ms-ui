import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import '../widgets/add_advance_bottom_sheet.dart';
import '../widgets/advance_details_bottom_sheet.dart';

class AdvancesPage extends StatelessWidget {
  const AdvancesPage({super.key});

  void _showAddAdvanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAdvanceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
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
          'Advances',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white54),
            onPressed: () => _showAddAdvanceSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAdvanceItem(
              context: context,
              fromInitials: 'AD',
              fromColor: const Color(0xFF3B82F6),
              fromName: 'Admin',
              toInitials: 'RK',
              toColor: const Color(0xFF10B981),
              toName: 'Raj Kumar',
              amount: '₹15,000',
              paymentMethod: 'Cash',
              paymentBgColor: const Color(0xFFFEF3C7),
              paymentTextColor: const Color(0xFFD97706),
              date: 'Jun 1, 2025',
              currentBalance: '₹14,500',
            ),
            const SizedBox(height: 12),
            _buildAdvanceItem(
              context: context,
              fromInitials: 'AD',
              fromColor: const Color(0xFF3B82F6),
              fromName: 'Admin',
              toInitials: 'MK',
              toColor: const Color(0xFFF59E0B),
              toName: 'Muthu Kumar',
              amount: '₹8,000',
              paymentMethod: 'UPI',
              paymentBgColor: const Color(0xFFEDE9FE),
              paymentTextColor: const Color(0xFF6D28D9),
              date: 'May 28, 2025',
              currentBalance: '₹8,000',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAdvanceSheet(context),
        backgroundColor: const Color(0xFF06B6D4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ), // Primary Cyan
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildAdvanceItem({
    required BuildContext context,
    required String fromInitials,
    required Color fromColor,
    required String fromName,
    required String toInitials,
    required Color toColor,
    required String toName,
    required String amount,
    required String paymentMethod,
    required Color paymentBgColor,
    required Color paymentTextColor,
    required String date,
    required String currentBalance,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AdvanceDetailsBottomSheet(
            amount: amount,
            date: date,
            paymentMethod: paymentMethod,
            fromInitials: fromInitials,
            fromColor: fromColor,
            fromName: fromName,
            toInitials: toInitials,
            toColor: toColor,
            toName: toName,
            currentBalance: currentBalance,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // From User
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: fromColor,
                      child: Text(
                        fromInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fromName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'FROM',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Arrow
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                // To User
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: toColor,
                      child: Text(
                        toInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          toName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'TO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981), // Green
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: paymentBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        paymentMethod,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: paymentTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
