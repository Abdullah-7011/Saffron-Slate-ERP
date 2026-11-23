import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../models/dining_table.dart';
import '../../models/reservation.dart';
import '../../providers/table_provider.dart';
import '../../widgets/status_badge.dart';

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddReservationModal(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    int guestCount = 4;
    String selectedTable = 'T6';
    String selectedTime = '08:00 PM';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            title: const Text('New Table Reservation', style: TextStyle(color: Colors.white, fontSize: 16)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Customer Full Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Contact Phone Number'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedTable,
                          decoration: const InputDecoration(labelText: 'Table'),
                          dropdownColor: AppColors.surface,
                          items: tableProvider.tables.map((t) => DropdownMenuItem(value: t.tableNumber, child: Text('${t.tableNumber} (${t.capacity}p)'))).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => selectedTable = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: guestCount,
                          decoration: const InputDecoration(labelText: 'Guests'),
                          dropdownColor: AppColors.surface,
                          items: [1, 2, 4, 6, 8, 10].map((c) => DropdownMenuItem(value: c, child: Text('$c Persons'))).toList(),
                          onChanged: (val) {
                            if (val != null) setModalState(() => guestCount = val);
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
                    items: ['12:30 PM', '01:00 PM', '01:30 PM', '02:00 PM', '07:30 PM', '08:00 PM', '08:30 PM', '09:00 PM']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedTime = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  final newRes = ReservationModel(
                    id: const Uuid().v4(),
                    customerName: nameCtrl.text.trim(),
                    customerPhone: phoneCtrl.text.trim().isEmpty ? '+92 300 0000000' : phoneCtrl.text.trim(),
                    tableNumber: selectedTable,
                    guestCount: guestCount,
                    reservationTime: selectedTime,
                    date: DateTime.now(),
                    status: ReservationStatus.confirmed,
                  );
                  tableProvider.addReservation(newRes);
                  Navigator.pop(ctx);
                },
                child: const Text('Save Reservation'),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table Booking & Floor Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Manage live dining occupancy and advance guest reservations', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddReservationModal(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Book Table'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryGold,
                labelColor: AppColors.primaryGold,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(icon: Icon(Icons.grid_view_rounded, size: 18), text: 'Floor Layout & Occupancy'),
                  Tab(icon: Icon(Icons.calendar_month_rounded, size: 18), text: 'Reservation Roster'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Floor Plan Grid
                  _buildFloorPlan(tableProvider),

                  // Tab 2: Reservations List
                  _buildReservationList(tableProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorPlan(TableProvider tableProvider) {
    final tables = tableProvider.tables;

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossCount = 4;
        if (constraints.maxWidth < 600) {
          crossCount = 2;
        } else if (constraints.maxWidth < 900) {
          crossCount = 3;
        }

        return GridView.builder(
          itemCount: tables.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final table = tables[index];
            Color statusColor = AppColors.emeraldGreen;
            if (table.status == TableStatus.occupied) statusColor = AppColors.alertRed;
            if (table.status == TableStatus.reserved) statusColor = AppColors.warningAmber;

            return InkWell(
              onTap: () => _showTableActionSheet(context, table, tableProvider),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.6), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          table.tableNumber,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        StatusBadge(label: table.status.label),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text('${table.capacity} Seats', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    if (table.currentGuestName.isNotEmpty)
                      Text(
                        'Guest: ${table.currentGuestName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: AppColors.lightGold, fontWeight: FontWeight.w500),
                      )
                    else
                      const Text(
                        'Ready for seating',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTableActionSheet(BuildContext context, DiningTable table, TableProvider tableProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Table ${table.tableNumber} Actions (${table.status.label})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: AppColors.emeraldGreen),
              title: const Text('Mark as Available (Vacant)'),
              onTap: () {
                tableProvider.setTableStatus(table.tableNumber, TableStatus.available);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant, color: AppColors.alertRed),
              title: const Text('Mark as Occupied (Dining)'),
              onTap: () {
                tableProvider.setTableStatus(table.tableNumber, TableStatus.occupied, guestName: 'Dine-In Guest');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: AppColors.warningAmber),
              title: const Text('Mark as Reserved'),
              onTap: () {
                tableProvider.setTableStatus(table.tableNumber, TableStatus.reserved, guestName: 'Reserved');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(TableProvider tableProvider) {
    final list = tableProvider.reservations;

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final res = list[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  res.tableNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryGold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(res.customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(
                      '${res.customerPhone} • ${res.guestCount} Guests • Time: ${res.reservationTime}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              StatusBadge(label: res.status.label),
            ],
          ),
        );
      },
    );
  }
}
