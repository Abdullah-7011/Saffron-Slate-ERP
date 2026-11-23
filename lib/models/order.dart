enum OrderStatus {
  pending,
  preparing,
  ready,
  served,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum OrderType {
  dineIn,
  takeaway,
  delivery;

  String get label {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine-In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double unitPrice;
  final String notes;

  const OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.notes = '',
  });

  double get lineTotal => quantity * unitPrice;

  OrderItem copyWith({
    String? menuItemId,
    String? name,
    int? quantity,
    double? unitPrice,
    String? notes,
  }) {
    return OrderItem(
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      notes: notes ?? this.notes,
    );
  }
}

class OrderModel {
  final String orderId;
  final String orderNumber;
  final String branchId;
  final String tableNumber;
  final String customerName;
  final OrderType orderType;
  final OrderStatus status;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double totalAmount;
  final DateTime createdAt;
  final String paymentMethod; // 'Cash', 'Card', 'Online'
  final bool isPaid;

  const OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.branchId,
    required this.tableNumber,
    required this.customerName,
    required this.orderType,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.totalAmount,
    required this.createdAt,
    this.paymentMethod = 'Cash',
    this.isPaid = false,
  });

  OrderModel copyWith({
    String? orderId,
    String? orderNumber,
    String? branchId,
    String? tableNumber,
    String? customerName,
    OrderType? orderType,
    OrderStatus? status,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? totalAmount,
    DateTime? createdAt,
    String? paymentMethod,
    bool? isPaid,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      branchId: branchId ?? this.branchId,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}

