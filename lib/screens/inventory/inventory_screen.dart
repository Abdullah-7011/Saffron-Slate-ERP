import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/inventory_item.dart';
import '../../providers/inventory_provider.dart';
import '../../widgets/status_badge.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  void _showAdjustStockDialog(BuildContext context, InventoryItem item) {
    final invProvider = Provider.of<InventoryProvider>(context, listen: false);
    final amountCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    String selectedType = 'Received';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
            title: Text('Adjust Stock: ${item.name}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current Balance: ${item.currentStock} ${item.unit}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(labelText: 'Movement Type'),
                    dropdownColor: AppColors.surface,
                    items: ['Received', 'Used', 'Waste', 'Adjustment'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Quantity (${item.unit})',
                      hintText: 'e.g. 10.0',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Reason / Note',
                      hintText: 'e.g. Vendor delivery invoice #881',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
              ElevatedButton(
                onPressed: () {
                  final qty = double.tryParse(amountCtrl.text) ?? 0.0;
                  if (qty <= 0) return;

                  final multiplier = (selectedType == 'Received' || selectedType == 'Adjustment') ? 1.0 : -1.0;
                  invProvider.updateStock(
                    item.id,
                    qty * multiplier,
                    reasonCtrl.text.trim().isEmpty ? 'Manual Adjustment' : reasonCtrl.text.trim(),
                    'Manager',
                    selectedType,
                  );

                  Navigator.pop(ctx);
                },
                child: const Text('Save Movement'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invProvider = Provider.of<InventoryProvider>(context);

    var boxDecoration = BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              );
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Inventory & Stock Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(
                      '${invProvider.lowStockItems.length} items flagged with Low-Stock Warnings',
                      style: const TextStyle(color: AppColors.alertRed, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Low Stock Alert Banner (if any)
            if (invProvider.lowStockItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.alertRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.alertRed, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Attention: Reorder required for: ${invProvider.lowStockItems.map((i) => "${i.name} (${i.currentStock}${i.unit})").join(", ")}',
                        style: const TextStyle(color: AppColors.alertRed, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            // Stock Table
            Container(
              decoration: boxDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.cardHeader,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                    ),
                    child: const Text('Stock Balances & Reorder Thresholds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Ingredient')),
                        DataColumn(label: Text('Current Balance')),
                        DataColumn(label: Text('Unit')),
                        DataColumn(label: Text('Reorder Level')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: invProvider.items.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(
                              Text(
                                '${item.currentStock}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.status == StockStatus.low ? AppColors.alertRed : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            DataCell(Text(item.unit)),
                            DataCell(Text('${item.reorderLevel} ${item.unit}')),
                            DataCell(StatusBadge(label: item.status.label)),
                            DataCell(
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.elevatedSurface,
                                  foregroundColor: AppColors.primaryGold,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                                onPressed: () => _showAdjustStockDialog(context, item),
                                child: const Text('Adjust', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recent Movement Audit Log
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.cardHeader,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                    ),
                    child: const Text('Recent Stock Movement Audit Trail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: invProvider.movements.length,
                    separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 1),
                    itemBuilder: (context, idx) {
                      final m = invProvider.movements[idx];
                      final timeStr = DateFormat('dd MMM, hh:mm a').format(m.timestamp);

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: m.type == 'Received' ? AppColors.emeraldGreenGlow : AppColors.alertRedGlow,
                          child: Icon(
                            m.type == 'Received' ? Icons.south_west : Icons.north_east,
                            size: 16,
                            color: m.type == 'Received' ? AppColors.emeraldGreen : AppColors.alertRed,
                          ),
                        ),
                        title: Text('${m.type}: ${m.quantity} ${m.unit} of ${m.ingredientName}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        subtitle: Text('${m.reason} • Actor: ${m.actorName}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        trailing: Text(timeStr, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
