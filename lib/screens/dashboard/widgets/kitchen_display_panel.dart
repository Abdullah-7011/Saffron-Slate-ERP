import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/status_badge.dart';

class KitchenDisplayPanel extends StatelessWidget {
  final VoidCallback? onOpenKds;

  const KitchenDisplayPanel({super.key, this.onOpenKds});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final kdsList = orderProvider.kdsOrders.take(5).toList();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('8', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Kitchen Display',
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
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.warningAmber, shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text('${kdsList.length} Active', style: const TextStyle(color: AppColors.warningAmber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
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
              columnSpacing: 18,
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
                DataColumn(label: Text('Order ID')),
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Table')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Status')),
              ],
              rows: kdsList.map((o) {
                final timeStr = DateFormat('hh:mm a').format(o.createdAt);
                final itemTitle = o.items.isNotEmpty ? o.items.first.name : 'Custom Dish';

                return DataRow(
                  cells: [
                    DataCell(Text(o.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGold))),
                    DataCell(Text(itemTitle, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.elevatedSurface, borderRadius: BorderRadius.circular(4)),
                        child: Text(o.tableNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataCell(Text(timeStr)),
                    DataCell(StatusBadge(label: o.status.label)),
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
                onPressed: onOpenKds,
                icon: const Icon(Icons.microwave_outlined, size: 14, color: AppColors.primaryGold),
                label: const Text(
                  'Open Kitchen Display (KDS)',
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
