import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/order_provider.dart';
import '../../../widgets/status_badge.dart';

class DailyOrdersTable extends StatelessWidget {
  const DailyOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders.take(6).toList();

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
                        child: const Text('3', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Daily Orders & Reservations',
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
                const SizedBox(width: 8),
                const Text(
                  '14 Oct 2026',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),

          // Orders Data Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 38,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 46,
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
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Table')),
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Items')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Total (Rs.)')),
              ],
              rows: orders.map((o) {
                final timeStr = DateFormat('hh:mm a').format(o.createdAt);
                final itemsSummary = o.items.map((i) => '${i.quantity}x ${i.name.split(' ').first}').join(', ');

                return DataRow(
                  cells: [
                    DataCell(Text(timeStr)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.elevatedSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(o.tableNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataCell(Text(o.customerName)),
                    DataCell(
                      Text(
                        itemsSummary,
                        style: const TextStyle(color: AppColors.lightGold),
                      ),
                    ),
                    DataCell(StatusBadge(label: o.status.label)),
                    DataCell(
                      Text(
                        CurrencyFormatter.format(o.totalAmount),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
