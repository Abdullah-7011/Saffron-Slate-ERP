import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/reservation.dart';
import '../../../providers/table_provider.dart';
import '../../../widgets/status_badge.dart';

class TableBookingsPanel extends StatelessWidget {
  const TableBookingsPanel({super.key});

  void _showAddBookingDialog(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    int guestCount = 4;
    String selectedTable = 'T1';
    String selectedTime = '02:00 PM';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            title: const Row(
              children: [
                Icon(Icons.bookmark_add_outlined, color: AppColors.primaryGold),
                SizedBox(width: 8),
                Text('Add Table Booking', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Customer Name', hintText: 'e.g. Asad Umar'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone Number', hintText: '0300-1234567'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedTable,
                          decoration: const InputDecoration(labelText: 'Table'),
                          dropdownColor: AppColors.surface,
                          items: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => selectedTable = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: guestCount,
                          decoration: const InputDecoration(labelText: 'Guests'),
                          dropdownColor: AppColors.surface,
                          items: [1, 2, 3, 4, 6, 8, 10]
                              .map((c) => DropdownMenuItem(value: c, child: Text('$c Persons')))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => guestCount = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTime,
                    decoration: const InputDecoration(labelText: 'Time Slot'),
                    dropdownColor: AppColors.surface,
                    items: ['12:30 PM', '01:00 PM', '01:30 PM', '02:00 PM', '07:30 PM', '08:30 PM', '09:30 PM']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedTime = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;

                  final newReservation = ReservationModel(
                    id: const Uuid().v4(),
                    customerName: nameCtrl.text.trim(),
                    customerPhone: phoneCtrl.text.trim().isEmpty ? '+92 300 0000000' : phoneCtrl.text.trim(),
                    tableNumber: selectedTable,
                    guestCount: guestCount,
                    reservationTime: selectedTime,
                    date: DateTime.now(),
                    status: ReservationStatus.confirmed,
                  );

                  tableProvider.addReservation(newReservation);
                  Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation confirmed for ${newReservation.customerName} on ${newReservation.tableNumber}'),
                      backgroundColor: AppColors.emeraldGreen,
                    ),
                  );
                },
                child: const Text('Confirm Booking'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);
    final bookings = tableProvider.reservations.take(6).toList();

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        child: const Text('5', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Table Bookings',
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
                InkWell(
                  onTap: () => _showAddBookingDialog(context),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          'Add Booking',
                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
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
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Table')),
                DataColumn(label: Text('People')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Status')),
              ],
              rows: bookings.map((b) {
                return DataRow(
                  cells: [
                    DataCell(Text(b.customerName, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.elevatedSurface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(b.tableNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataCell(Text('${b.guestCount}')),
                    DataCell(Text(b.reservationTime)),
                    DataCell(StatusBadge(label: b.status.label)),
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
