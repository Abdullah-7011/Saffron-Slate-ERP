enum StockStatus {
  good,
  low;

  String get label => this == StockStatus.good ? 'Good' : 'Low';
}

class InventoryItem {
  final String id;
  final String branchId;
  final String name;
  final double currentStock;
  final String unit; // 'Kg', 'L', 'Pcs'
  final double reorderLevel;
  final StockStatus status;

  const InventoryItem({
    required this.id,
    required this.branchId,
    required this.name,
    required this.currentStock,
    required this.unit,
    required this.reorderLevel,
    required this.status,
  });

  InventoryItem copyWith({
    String? id,
    String? branchId,
    String? name,
    double? currentStock,
    String? unit,
    double? reorderLevel,
    StockStatus? status,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      currentStock: currentStock ?? this.currentStock,
      unit: unit ?? this.unit,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      status: status ?? this.status,
    );
  }
}

class StockMovement {
  final String id;
  final String ingredientName;
  final String type; // 'Received', 'Used', 'Waste', 'Adjustment'
  final double quantity;
  final String unit;
  final String reason;
  final String actorName;
  final DateTime timestamp;

  const StockMovement({
    required this.id,
    required this.ingredientName,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.reason,
    required this.actorName,
    required this.timestamp,
  });
}

