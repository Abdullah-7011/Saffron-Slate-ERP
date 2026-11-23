import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/staff_payout.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/status_badge.dart';

class StaffPayoutsScreen extends StatelessWidget {
  const StaffPayoutsScreen({super.key});

  void _showAddStaffDialog(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController(text: 'Waitstaff');
    final daysCtrl = TextEditingController(text: '26');
    final rateCtrl = TextEditingController(text: '1000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        title: const Text('Add Staff Wage Record', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Staff Name')),
              const SizedBox(height: 12),
              TextField(controller: roleCtrl, decoration: const InputDecoration(labelText: 'Role / Designation')),
              const SizedBox(height: 12),
              TextField(controller: daysCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Days Worked')),
              const SizedBox(height: 12),
              TextField(controller: rateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Daily Wage Rate (Rs.)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            onPressed: () {
              final days = int.tryParse(daysCtrl.text) ?? 26;
              final rate = double.tryParse(rateCtrl.text) ?? 1000;
              final total = days * rate;

              final newPayout = StaffPayout(
                id: '${appState.staffPayouts.length + 1}',
                staffName: nameCtrl.text.trim().isEmpty ? 'Employee' : nameCtrl.text.trim(),
                role: roleCtrl.text.trim(),
                daysWorked: days,
                dailyRate: rate,
                totalAmount: total,
                payoutDate: DateTime.now(),
              );

              appState.addStaffPayout(newPayout);
              Navigator.pop(ctx);
            },
            child: const Text('Save Payout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final payouts = appState.staffPayouts;

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
                    Text('Staff Wage & Attendance Payout Sheet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Monthly operational payroll and wage calculations in Pakistani Rupees', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddStaffDialog(context),
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 16),
                  label: const Text('Add Staff Record'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem('Total Employees', '${payouts.length} Active', AppColors.infoBlue),
                  Container(width: 1, height: 35, color: AppColors.border),
                  _buildSummaryItem('Payroll Date', DateFormat('dd MMM yyyy').format(DateTime(2026, 10, 14)), AppColors.textPrimary),
                  Container(width: 1, height: 35, color: AppColors.border),
                  _buildSummaryItem('Total Monthly Disbursement', CurrencyFormatter.format(appState.totalStaffPayout), AppColors.primaryGold),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Data Table Card
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
                    child: const Text('Staff Attendance & Daily Wage Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Staff Member')),
                        DataColumn(label: Text('Designation')),
                        DataColumn(label: Text('Days Worked')),
                        DataColumn(label: Text('Daily Wage')),
                        DataColumn(label: Text('Payable Total')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: payouts.map((p) {
                        return DataRow(
                          cells: [
                            DataCell(Text(p.id)),
                            DataCell(Text(p.staffName, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(p.role, style: const TextStyle(color: AppColors.textSecondary))),
                            DataCell(Text('${p.daysWorked}')),
                            DataCell(Text(CurrencyFormatter.format(p.dailyRate))),
                            DataCell(
                              Text(
                                CurrencyFormatter.format(p.totalAmount),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGold),
                              ),
                            ),
                            DataCell(StatusBadge(label: p.isDisbursed ? 'Paid' : 'Pending')),
                            DataCell(
                              p.isDisbursed
                                  ? const Icon(Icons.check_circle, color: AppColors.emeraldGreen, size: 20)
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.emeraldGreen,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      ),
                                      onPressed: () {
                                        appState.markPayoutDisbursed(p.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Disbursed ${CurrencyFormatter.format(p.totalAmount)} to ${p.staffName}'),
                                            backgroundColor: AppColors.emeraldGreen,
                                          ),
                                        );
                                      },
                                      child: const Text('Pay Wage', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
