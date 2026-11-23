import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/inventory_provider.dart';
import '../../../widgets/status_badge.dart';

class InventoryStatusPanel extends StatelessWidget {
  final VoidCallback? onViewFullInventory;

  const InventoryStatusPanel({super.key, this.onViewFullInventory});

  @override
  Widget build(BuildContext context) {
    final invProvider = Provider.of<InventoryProvider>(context);
    final items = invProvider.items.take(6).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.cardHeader,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('6', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Inventory / Stock',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Data Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 38,
              dataRowMinHeight: 38,
              dataRowMaxHeight: 44,
              columnSpacing: 20,
              headingTextStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              dataTextStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
              columns: const [
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Current Stock')),
                DataColumn(label: Text('Unit')),
                DataColumn(label: Text('Status')),
              ],
              rows: items.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(
                      Text(
                        item.currentStock.toStringAsFixed(item.currentStock % 1 == 0 ? 0 : 1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: item.status.label == 'Low' ? AppColors.alertRed : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    DataCell(Text(item.unit)),
                    DataCell(StatusBadge(label: item.status.label)),
                  ],
                );
              }).toList(),
            ),
          ),

          // Footer link
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
            ),
            child: Center(
              child: TextButton.icon(
                onPressed: onViewFullInventory,
                icon: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryGold),
                label: const Text(
                  'View Full Inventory',
                  style: TextStyle(fontSize: 11, color: AppColors.primaryGold, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
