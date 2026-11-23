import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class PnlStatementPanel extends StatelessWidget {
  final VoidCallback? onExportCsv;

  const PnlStatementPanel({super.key, this.onExportCsv});

  @override
  Widget build(BuildContext context) {
    const totalIncome = 3480000.0;
    const directExpenses = 1760000.0;
    const grossProfit = totalIncome - directExpenses; // 1,720,000
    const otherExpenses = 640000.0;
    const netProfit = grossProfit - otherExpenses; // 1,080,000

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
                        child: const Text('9', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Profit & Loss',
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
                const Text('This Month', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),

          // P&L Line Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPnlRow('Total Income', totalIncome, isPositive: true, isHeader: true),
                const Divider(color: AppColors.border, height: 18),
                _buildPnlRow('Total Expenses', directExpenses, subtitle: 'Employee wages, Raw materials, etc.', isNegative: true),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _buildPnlRow('Gross Profit', grossProfit, isHighlight: true),
                ),
                const SizedBox(height: 8),
                _buildPnlRow('Other Expenses', otherExpenses, subtitle: 'Utilities, Rent, Transport', isNegative: true),
                const Divider(color: AppColors.border, height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.emeraldGreen.withValues(alpha: 0.15),
                        AppColors.cardSurface,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.emeraldGreen.withValues(alpha: 0.4)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 4,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Net Profit', style: TextStyle(color: AppColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Post-tax deductions', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                        ],
                      ),
                      Text(
                        CurrencyFormatter.format(netProfit),
                        style: const TextStyle(
                          color: AppColors.emeraldGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPnlRow(
    String title,
    double amount, {
    String? subtitle,
    bool isPositive = false,
    bool isNegative = false,
    bool isHighlight = false,
    bool isHeader = false,
  }) {
    Color amountColor = AppColors.textPrimary;
    if (isPositive) amountColor = AppColors.primaryGold;
    if (isNegative) amountColor = AppColors.alertRed;
    if (isHighlight) amountColor = AppColors.lightGold;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isHeader ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isHeader || isHighlight ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isNegative ? '-${CurrencyFormatter.format(amount)}' : CurrencyFormatter.format(amount),
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.w700,
            fontSize: isHeader ? 13 : 12,
          ),
        ),
      ],
    );
  }
}
