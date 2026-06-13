import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/features/projects/presentation/widgets/custom_form_field.dart';
import 'package:construction_ms_ui/features/purchase_orders/data/models/purchase_order_model.dart';

class POFormGroup {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    qtyController.dispose();
  }

  int get total {
    // Try to parse price and qty to calculate total for dynamic UI
    // Extracting just numbers from strings like "350" or "60/kg" or "2T"
    final priceStr = priceController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final qtyStr = qtyController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    
    final price = double.tryParse(priceStr) ?? 0.0;
    final qty = double.tryParse(qtyStr) ?? 0.0;
    
    // Quick handle of 'k' multiplier for price
    double multiplier = 1.0;
    if (priceController.text.toLowerCase().contains('k')) {
      multiplier = 1000.0;
    }
    
    return (price * multiplier * qty).round();
  }
}

class NewPOSheet extends StatefulWidget {
  final Function(PurchaseOrder) onSave;

  const NewPOSheet({super.key, required this.onSave});

  @override
  State<NewPOSheet> createState() => _NewPOSheetState();
}

class _NewPOSheetState extends State<NewPOSheet> {
  String? selectedVendor;
  String? selectedIndent;
  
  final List<POFormGroup> _formGroups = [POFormGroup()];
  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to calculate total automatically
    for (var group in _formGroups) {
      group.nameController.addListener(_updateTotal);
      group.priceController.addListener(_updateTotal);
      group.qtyController.addListener(_updateTotal);
    }
  }

  void _validateForm() {
    bool hasValidItem = _formGroups.any((g) => 
        g.nameController.text.trim().isNotEmpty && 
        g.priceController.text.trim().isNotEmpty && 
        g.qtyController.text.trim().isNotEmpty);
    
    final isValid = selectedVendor != null && hasValidItem;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  void _updateTotal() {
    _validateForm();
  }

  @override
  void dispose() {
    for (var group in _formGroups) {
      group.priceController.removeListener(_updateTotal);
      group.qtyController.removeListener(_updateTotal);
      group.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      final newGroup = POFormGroup();
      newGroup.nameController.addListener(_updateTotal);
      newGroup.priceController.addListener(_updateTotal);
      newGroup.qtyController.addListener(_updateTotal);
      _formGroups.add(newGroup);
      _validateForm();
    });
  }

  int get _grandTotal {
    return _formGroups.fold(0, (sum, group) => sum + group.total);
  }

  void _createPO() async {
    if (!_isFormValid) return;

    List<PurchaseOrderItem> items = [];
    for (var group in _formGroups) {
      if (group.nameController.text.isNotEmpty && group.priceController.text.isNotEmpty && group.qtyController.text.isNotEmpty) {
        // Format price
        String priceExpr = group.priceController.text;
        if (!priceExpr.startsWith('₹')) {
          priceExpr = '₹$priceExpr';
        }
        
        items.add(PurchaseOrderItem(
          name: group.nameController.text,
          priceExpression: priceExpr,
          quantityExpression: group.qtyController.text,
          totalValue: group.total,
        ));
      }
    }

    final newPO = PurchaseOrder(
      id: '#PO-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      vendorName: selectedVendor!,
      vendorContact: '+91 99999 00000', // Mock
      deliverySite: 'Metro Towers Site', // Mock derived from indent theoretically
      status: POStatus.pending,
      date: DateTime.now(),
      items: items,
    );

    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API
      widget.onSave(newPO);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PO Created Successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create PO: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: SingleChildScrollView(
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
                  'Create Purchase Order',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'SELECT VENDOR',
              isRequired: true,
              hint: 'Select Vendor',
              isDropdown: true,
              isDark: true,
              dropdownValue: selectedVendor,
              dropdownItems: const ['RK Steel Industries', 'KM Cement Works', 'National Hardware'],
              onDropdownChanged: (val) {
                setState(() => selectedVendor = val);
                _validateForm();
              },
            ),
            CustomFormField(
              label: 'SELECT INDENT',
              hint: 'Select Indent',
              isDropdown: true,
              isDark: true,
              dropdownValue: selectedIndent,
              dropdownItems: const ['#IND-2025-041 – Metro Towers', '#IND-2025-039 – Sunrise Villa'],
              onDropdownChanged: (val) => setState(() => selectedIndent = val),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _addItem,
                  child: const Text('+ Add Item', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            
            ..._formGroups.map((group) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomFormField(
                        label: '',
                        hint: 'Item name',
                        controller: group.nameController,
                        isDark: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: CustomFormField(
                        label: '',
                        hint: 'Price',
                        controller: group.priceController,
                        isDark: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: CustomFormField(
                        label: '',
                        hint: 'Qty',
                        controller: group.qtyController,
                        isDark: true,
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  const Text('Total Amount', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(_grandTotal),
                    style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isFormValid && !_isLoading) ? _createPO : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        'Create PO', 
                        style: TextStyle(
                          color: _isFormValid ? Colors.white : Colors.white54, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
