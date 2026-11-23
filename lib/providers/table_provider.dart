import 'package:flutter/material.dart';
import '../models/dining_table.dart';
import '../models/reservation.dart';

class TableProvider extends ChangeNotifier {
  final List<DiningTable> _tables = [
    const DiningTable(id: 't1', tableNumber: 'T1', capacity: 4, status: TableStatus.occupied, currentGuestName: 'Ali Raza'),
    const DiningTable(id: 't2', tableNumber: 'T2', capacity: 2, status: TableStatus.occupied, currentGuestName: 'Usman Ali'),
    const DiningTable(id: 't3', tableNumber: 'T3', capacity: 6, status: TableStatus.occupied, currentGuestName: 'Hassan Shah'),
    const DiningTable(id: 't4', tableNumber: 'T4', capacity: 4, status: TableStatus.occupied, currentGuestName: 'Saqib Khan'),
    const DiningTable(id: 't5', tableNumber: 'T5', capacity: 2, status: TableStatus.occupied, currentGuestName: 'Ayesha Malik'),
    const DiningTable(id: 't6', tableNumber: 'T6', capacity: 8, status: TableStatus.available),
    const DiningTable(id: 't7', tableNumber: 'T7', capacity: 4, status: TableStatus.reserved, currentGuestName: 'Hamza Butt'),
    const DiningTable(id: 't8', tableNumber: 'T8', capacity: 4, status: TableStatus.available),
    const DiningTable(id: 't9', tableNumber: 'T9', capacity: 6, status: TableStatus.available),
    const DiningTable(id: 't10', tableNumber: 'T10', capacity: 2, status: TableStatus.available),
  ];

  List<DiningTable> get tables => List.unmodifiable(_tables);

  final List<ReservationModel> _reservations = [
    ReservationModel(
      id: 'res-1',
      customerName: 'Zain Ahmed',
      customerPhone: '+92 300 1234567',
      tableNumber: 'T1',
      guestCount: 4,
      reservationTime: '12:30 PM',
      date: DateTime(2026, 10, 14),
      status: ReservationStatus.confirmed,
    ),
    ReservationModel(
      id: 'res-2',
      customerName: 'Bilawal Tarar',
      customerPhone: '+92 321 7654321',
      tableNumber: 'T2',
      guestCount: 2,
      reservationTime: '01:00 PM',
      date: DateTime(2026, 10, 14),
      status: ReservationStatus.confirmed,
    ),
    ReservationModel(
      id: 'res-3',
      customerName: 'Bilal Shah',
      customerPhone: '+92 333 9876543',
      tableNumber: 'T5',
      guestCount: 2,
      reservationTime: '01:15 PM',
      date: DateTime(2026, 10, 14),
      status: ReservationStatus.pending,
    ),
    ReservationModel(
      id: 'res-4',
      customerName: 'Hamza Butt',
      customerPhone: '+92 302 4567890',
      tableNumber: 'T7',
      guestCount: 4,
      reservationTime: '01:30 PM',
      date: DateTime(2026, 10, 14),
      status: ReservationStatus.confirmed,
    ),
    ReservationModel(
      id: 'res-5',
      customerName: 'Haris Butt',
      customerPhone: '+92 345 1122334',
      tableNumber: 'T3',
      guestCount: 6,
      reservationTime: '01:45 PM',
      date: DateTime(2026, 10, 14),
      status: ReservationStatus.confirmed,
    ),
  ];

  List<ReservationModel> get reservations => List.unmodifiable(_reservations);

  bool isTableAvailable(String tableNumber, String time) {
    // Check if there is an existing confirmed reservation for this table and time
    return !_reservations.any((r) =>
        r.tableNumber == tableNumber &&
        r.reservationTime == time &&
        r.status != ReservationStatus.cancelled);
  }

  void addReservation(ReservationModel reservation) {
    _reservations.insert(0, reservation);
    // Update table status if appropriate
    final tableIndex = _tables.indexWhere((t) => t.tableNumber == reservation.tableNumber);
    if (tableIndex != -1 && _tables[tableIndex].status == TableStatus.available) {
      _tables[tableIndex] = _tables[tableIndex].copyWith(
        status: TableStatus.reserved,
        currentGuestName: reservation.customerName,
      );
    }
    notifyListeners();
  }

  void updateReservationStatus(String id, ReservationStatus status) {
    final idx = _reservations.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _reservations[idx] = _reservations[idx].copyWith(status: status);
      notifyListeners();
    }
  }

  void setTableStatus(String tableNumber, TableStatus status, {String guestName = ''}) {
    final idx = _tables.indexWhere((t) => t.tableNumber == tableNumber);
    if (idx != -1) {
      _tables[idx] = _tables[idx].copyWith(
        status: status,
        currentGuestName: guestName,
      );
      notifyListeners();
    }
  }
}
