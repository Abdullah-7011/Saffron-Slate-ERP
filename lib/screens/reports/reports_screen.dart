import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/app_state_provider.dart';
import '../dashboard/widgets/sales_report_chart.dart';
import '../dashboard/widgets/income_expense_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _exportCsv(BuildContext context, AppStateProvider appState) {
    final buffer = StringBuffer();
    buffer.writeln('Branch,City,Total Income (PKR),Total Expense (PKR),Net Profit (PKR),Status');
    for (final b in appState.branches) {
      buffer.writeln('${b.name},${b.city},${b.totalIncome},${b.totalExpense},${b.profitLoss},${b.status}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        title: const Row(
          children: [
            Icon(Icons.file_download_outlined, color: AppColors.primaryGold),
            SizedBox(width: 8),
            Text('CSV Report Exported', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Branch P&L and Sales data has been generated and copied to clipboard in CSV format:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
              child: Text(
                buffer.toString(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.lightGold),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Financial Reports & Executive Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Consolidated multi-branch P&L statements, trends and CSV export', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _exportCsv(context, appState),
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('Export CSV'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Charts Grid
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: IncomeExpenseChart()),
                SizedBox(width: 16),
                Expanded(child: SalesReportChart()),
              ],
            ),
            const SizedBox(height: 20),

            // Comprehensive P&L Breakdown Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consolidated Profit & Loss Statement (Fiscal Month: Oct 2026)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildPnlRow('1. Gross Sales Revenue (Dine-In, Takeaway, Online)', 3480000, AppColors.primaryGold),
                  const Divider(color: AppColors.border, height: 20),
                  _buildPnlRow('2. Direct Cost of Goods Sold (Raw materials, meat, spices)', -980000, AppColors.alertRed),
                  _buildPnlRow('3. Staff Wages & Kitchen Payroll', -780000, AppColors.alertRed),
                  const Divider(color: AppColors.border, height: 20),
                  _buildPnlRow('Gross Operating Margin', 1720000, AppColors.emeraldGreen, isBold: true),
                  const Divider(color: AppColors.border, height: 20),
                  _buildPnlRow('4. Commercial Utilities (Electricity, Gas, Generator Fuel)', -420000, AppColors.alertRed),
                  _buildPnlRow('5. Branch Rent & Maintenance Overhead', -220000, AppColors.alertRed),
                  const Divider(color: AppColors.border, height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.emeraldGreen.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NET AUDITED PROFIT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.emeraldGreen)),
                            Text('After all branch operating & salary disbursements', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                        Text(
                          CurrencyFormatter.format(1080000),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.emeraldGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPnlRow(String title, double amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: isBold ? Colors.white : AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
          Text(
            amount < 0 ? '-${CurrencyFormatter.format(amount.abs())}' : CurrencyFormatter.format(amount),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: isBold ? 15 : 13),
          ),
        ],
      ),
    );
  }
}

