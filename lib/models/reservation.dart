enum ReservationStatus {
  confirmed,
  pending,
  cancelled;

  String get label {
    switch (this) {
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class ReservationModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String tableNumber;
  final int guestCount;
  final String reservationTime; // e.g. "12:30 PM"
  final DateTime date;
  final ReservationStatus status;

  const ReservationModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.tableNumber,
    required this.guestCount,
    required this.reservationTime,
    required this.date,
    required this.status,
  });

  ReservationModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? tableNumber,
    int? guestCount,
    String? reservationTime,
    DateTime? date,
    ReservationStatus? status,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      tableNumber: tableNumber ?? this.tableNumber,
      guestCount: guestCount ?? this.guestCount,
      reservationTime: reservationTime ?? this.reservationTime,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}

