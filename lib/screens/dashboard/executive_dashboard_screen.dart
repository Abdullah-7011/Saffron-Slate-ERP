import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/app_state_provider.dart';
import 'widgets/kpi_metric_card.dart';
import 'widgets/branch_overview_table.dart';
import 'widgets/income_expense_chart.dart';
import 'widgets/daily_orders_table.dart';
import 'widgets/staff_payout_table.dart';
import 'widgets/table_bookings_panel.dart';
import 'widgets/inventory_status_panel.dart';
import 'widgets/sales_report_chart.dart';
import 'widgets/kitchen_display_panel.dart';
import 'widgets/pnl_statement_panel.dart';

class ExecutiveDashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const ExecutiveDashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 950;
        final isMedium = constraints.maxWidth >= 650 && constraints.maxWidth < 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Welcome back, ${appState.currentRole.displayName}! Here\'s what\'s happening today.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // KPI Metric Cards (Top 4 Cards from Figure 1)
              _buildKpiRow(isWide, isMedium, appState),
              const SizedBox(height: 16),

              // Row 1: Panel 1 (Branch Overview) + Panel 2 (Income vs Expense Chart)
              if (isWide)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: BranchOverviewTable()),
                    SizedBox(width: 16),
                    Expanded(flex: 2, child: IncomeExpenseChart()),
                  ],
                )
              else ...[
                const BranchOverviewTable(),
                const SizedBox(height: 16),
                const IncomeExpenseChart(),
              ],
              const SizedBox(height: 16),

              // Row 2: Panel 3 (Daily Orders) + Panel 4 (Payout Sheet)
              if (isWide)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: DailyOrdersTable()),
                    SizedBox(width: 16),
                    Expanded(flex: 2, child: StaffPayoutTable()),
                  ],
                )
              else ...[
                const DailyOrdersTable(),
                const SizedBox(height: 16),
                const StaffPayoutTable(),
              ],
              const SizedBox(height: 16),

              // Row 3: Panel 5 (Table Bookings) + Panel 6 (Inventory)
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: TableBookingsPanel()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InventoryStatusPanel(
                        onViewFullInventory: () => onNavigateTab?.call(5),
                      ),
                    ),
                  ],
                )
              else ...[
                const TableBookingsPanel(),
                const SizedBox(height: 16),
                InventoryStatusPanel(
                  onViewFullInventory: () => onNavigateTab?.call(5),
                ),
              ],
              const SizedBox(height: 16),

              // Row 4: Panel 7 (Sales Report) + Panel 8 (KDS)
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 3, child: SalesReportChart()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: KitchenDisplayPanel(
                        onOpenKds: () => onNavigateTab?.call(4),
                      ),
                    ),
                  ],
                )
              else ...[
                const SalesReportChart(),
                const SizedBox(height: 16),
                KitchenDisplayPanel(
                  onOpenKds: () => onNavigateTab?.call(4),
                ),
              ],
              const SizedBox(height: 16),

              // Row 5: Panel 9 (Profit & Loss Statement)
              const PnlStatementPanel(),
              const SizedBox(height: 20),

              // Bottom Feature Summary Footer (Figure 1 Footer)
              _buildRequirementsSummaryFooter(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKpiRow(bool isWide, bool isMedium, AppStateProvider appState) {
    final cards = [
      KpiMetricCard(
        title: 'Total Orders',
        value: '${appState.totalOrdersCount}',
        subtitle: 'Active Orders: ${appState.activeOrdersCount}',
        badgeText: '+12%',
        isPositive: true,
        icon: Icons.receipt_long_rounded,
        iconColor: AppColors.infoBlue,
      ),
      KpiMetricCard(
        title: 'Total Income',
        value: CurrencyFormatter.format(appState.todayIncome),
        subtitle: 'Today\'s Sales',
        badgeText: '+18%',
        isPositive: true,
        icon: Icons.account_balance_wallet_rounded,
        iconColor: AppColors.primaryGold,
      ),
      KpiMetricCard(
        title: 'Total Expenses',
        value: CurrencyFormatter.format(appState.monthlyExpenses),
        subtitle: 'This Month',
        badgeText: '-5%',
        isPositive: false,
        icon: Icons.trending_down_rounded,
        iconColor: AppColors.alertRed,
      ),
      KpiMetricCard(
        title: 'Net Profit',
        value: CurrencyFormatter.format(appState.netProfit),
        subtitle: 'This Month',
        badgeText: '+22%',
        isPositive: true,
        icon: Icons.savings_rounded,
        iconColor: AppColors.emeraldGreen,
      ),
    ];

    if (isWide) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: c,
                  ),
                ))
            .toList(),
      );
    } else if (isMedium) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 12),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: c,
                ))
            .toList(),
      );
    }
  }

  Widget _buildRequirementsSummaryFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.verified_outlined, color: AppColors.primaryGold, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Features / Requirements Summary Verified',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Multi-branch • Orders & Tables • Billing & Receipts • Inventory • KDS • Staff Wage • P&L',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.4)),
            ),
            child: const Text(
              'Saffron & Slate ERP',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
