import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class SalesReportChart extends StatelessWidget {
  const SalesReportChart({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Daily income and expense in 100k Rs.
    final incomeData = [3.2, 2.8, 3.5, 3.9, 4.8, 5.2, 4.5];
    final expenseData = [1.5, 1.2, 1.6, 1.8, 2.2, 2.4, 2.1];

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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGold,
                        shape: BoxShape.circle,
                      ),
                      child: const Text('7', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sales Report',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('This Week', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ),
              ],
            ),
          ),

          // Chart
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  maxY: 6.0,
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 26,
                        interval: 2,
                        getTitlesWidget: (val, _) {
                          if (val == 0) return const SizedBox.shrink();
                          return Text('${val.toInt() * 100}k', style: const TextStyle(color: AppColors.textMuted, fontSize: 9));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (val, _) {
                          final idx = val.toInt();
                          if (idx >= 0 && idx < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(days[idx], style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (val) => const FlLine(color: AppColors.border, strokeWidth: 0.8, dashArray: [4, 4]),
                  ),
                  barGroups: List.generate(days.length, (idx) {
                    return BarChartGroupData(
                      x: idx,
                      barsSpace: 3,
                      barRods: [
                        BarChartRodData(
                          toY: incomeData[idx],
                          color: AppColors.primaryGold,
                          width: 10,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                        BarChartRodData(
                          toY: expenseData[idx],
                          color: AppColors.alertRed,
                          width: 10,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),

          // Summary Strip (Figure 1 Panel 7 footer)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Income', CurrencyFormatter.format(2480000), AppColors.primaryGold),
                  const SizedBox(width: 14),
                  Container(width: 1, height: 26, color: AppColors.border),
                  const SizedBox(width: 14),
                  _buildStatItem('Total Expense', CurrencyFormatter.format(1120000), AppColors.alertRed),
                  const SizedBox(width: 14),
                  Container(width: 1, height: 26, color: AppColors.border),
                  const SizedBox(width: 14),
                  _buildStatItem('Net Profit', CurrencyFormatter.format(1360000), AppColors.emeraldGreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
