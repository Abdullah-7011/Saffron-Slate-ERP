import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/app_state_provider.dart';
import '../../../widgets/status_badge.dart';

class BranchOverviewTable extends StatelessWidget {
  const BranchOverviewTable({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final branches = appState.branches;

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
                  child: const Text('1', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Project / Site Wise Overview',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Data Table
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
                DataColumn(label: Text('Branch / Location')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Start Date')),
                DataColumn(label: Text('End Date')),
                DataColumn(label: Text('Total Income')),
                DataColumn(label: Text('Total Expense')),
                DataColumn(label: Text('Profit / Loss')),
                DataColumn(label: Text('Status')),
              ],
              rows: branches.map((b) {
                final isSelected = appState.selectedBranchId == b.id;
                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (_) => appState.setSelectedBranch(isSelected ? 'all' : b.id),
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            Icons.store_mall_directory_rounded,
                            size: 14,
                            color: isSelected ? AppColors.primaryGold : AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            b.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primaryGold : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(b.city)),
                    DataCell(Text(b.startDate)),
                    DataCell(Text(b.endDate)),
                    DataCell(Text(CurrencyFormatter.format(b.totalIncome))),
                    DataCell(Text(CurrencyFormatter.format(b.totalExpense))),
                    DataCell(
                      Text(
                        CurrencyFormatter.format(b.profitLoss),
                        style: const TextStyle(
                          color: AppColors.emeraldGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(StatusBadge(label: b.status)),
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

