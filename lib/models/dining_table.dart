enum TableStatus {
  available,
  occupied,
  reserved;

  String get label {
    switch (this) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
    }
  }
}

class DiningTable {
  final String id;
  final String tableNumber; // e.g. 'T1', 'T2'
  final int capacity;
  final TableStatus status;
  final String currentOrderId;
  final String currentGuestName;

  const DiningTable({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    this.currentOrderId = '',
    this.currentGuestName = '',
  });

  DiningTable copyWith({
    String? id,
    String? tableNumber,
    int? capacity,
    TableStatus? status,
    String? currentOrderId,
    String? currentGuestName,
  }) {
    return DiningTable(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      currentGuestName: currentGuestName ?? this.currentGuestName,
    );
  }
}

