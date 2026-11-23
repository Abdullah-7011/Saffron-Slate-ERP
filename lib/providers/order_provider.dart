import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  // Active Cart for POS order entry
  final List<OrderItem> _cart = [];
  List<OrderItem> get cart => List.unmodifiable(_cart);

  OrderType _currentOrderType = OrderType.dineIn;
  OrderType get currentOrderType => _currentOrderType;

  String _selectedTable = 'T1';
  String get selectedTable => _selectedTable;

  String _customerName = 'Walk-in Customer';
  String get customerName => _customerName;

  double _discountPercent = 0.0;
  double get discountPercent => _discountPercent;

  static const double taxRate = 0.16; // 16% GST

  void setOrderType(OrderType type) {
    _currentOrderType = type;
    notifyListeners();
  }

  void setSelectedTable(String table) {
    _selectedTable = table;
    notifyListeners();
  }

  void setCustomerName(String name) {
    _customerName = name.trim().isEmpty ? 'Walk-in Customer' : name;
    notifyListeners();
  }

  void setDiscountPercent(double discount) {
    _discountPercent = discount.clamp(0.0, 100.0);
    notifyListeners();
  }

  void addToCart(String itemId, String name, double unitPrice, {String notes = ''}) {
    final existingIndex = _cart.indexWhere((i) => i.menuItemId == itemId && i.notes == notes);
    if (existingIndex != -1) {
      final existing = _cart[existingIndex];
      _cart[existingIndex] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _cart.add(OrderItem(
        menuItemId: itemId,
        name: name,
        quantity: 1,
        unitPrice: unitPrice,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  void updateCartQuantity(String itemId, int quantity) {
    final index = _cart.indexWhere((i) => i.menuItemId == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _cart.removeWhere((i) => i.menuItemId == itemId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _discountPercent = 0.0;
    _customerName = 'Walk-in Customer';
    notifyListeners();
  }

  double get cartSubtotal => _cart.fold(0.0, (acc, item) => acc + item.lineTotal);
  double get cartTax => cartSubtotal * taxRate;
  double get cartDiscount => (cartSubtotal * _discountPercent) / 100.0;
  double get cartGrandTotal => (cartSubtotal + cartTax - cartDiscount).clamp(0.0, double.infinity);

  // Orders repository
  final List<OrderModel> _orders = [
    OrderModel(
      orderId: 'ord-1021',
      orderNumber: '#1021',
      branchId: 'b1',
      tableNumber: 'T1',
      customerName: 'Ali Raza',
      orderType: OrderType.dineIn,
      status: OrderStatus.served,
      items: const [
        OrderItem(menuItemId: 'm1', name: 'Chicken Karahi (Full)', quantity: 2, unitPrice: 2600),
      ],
      subtotal: 5200,
      tax: 832,
      discount: 0,
      totalAmount: 5200,
      createdAt: DateTime(2026, 10, 14, 10, 20),
      isPaid: true,
      paymentMethod: 'Cash',
    ),
    OrderModel(
      orderId: 'ord-1022',
      orderNumber: '#1022',
      branchId: 'b1',
      tableNumber: 'T4',
      customerName: 'Saqib Khan',
      orderType: OrderType.dineIn,
      status: OrderStatus.preparing,
      items: const [
        OrderItem(menuItemId: 'm5', name: 'Special Dum Biryani', quantity: 2, unitPrice: 950),
        OrderItem(menuItemId: 'm10', name: 'Soft Drink (Can)', quantity: 2, unitPrice: 150),
      ],
      subtotal: 2200,
      tax: 250,
      discount: 0,
      totalAmount: 2450,
      createdAt: DateTime(2026, 10, 14, 11, 15),
      isPaid: false,
    ),
    OrderModel(
      orderId: 'ord-1023',
      orderNumber: '#1023',
      branchId: 'b1',
      tableNumber: 'T2',
      customerName: 'Usman Ali',
      orderType: OrderType.dineIn,
      status: OrderStatus.preparing,
      items: const [
        OrderItem(menuItemId: 'm7', name: 'Creamy Alfredo Pasta', quantity: 1, unitPrice: 1350),
        OrderItem(menuItemId: 'm8', name: 'Hot & Sour Soup', quantity: 1, unitPrice: 430),
      ],
      subtotal: 1780,
      tax: 0,
      discount: 0,
      totalAmount: 1780,
      createdAt: DateTime(2026, 10, 14, 11, 30),
      isPaid: false,
    ),
    OrderModel(
      orderId: 'ord-1024',
      orderNumber: '#1024',
      branchId: 'b1',
      tableNumber: 'T5',
      customerName: 'Ayesha Malik',
      orderType: OrderType.dineIn,
      status: OrderStatus.pending,
      items: const [
        OrderItem(menuItemId: 'm6', name: 'Saffron Supreme Pizza (L)', quantity: 2, unitPrice: 2100),
      ],
      subtotal: 4200,
      tax: 0,
      discount: 0,
      totalAmount: 4200,
      createdAt: DateTime(2026, 10, 14, 12, 15),
      isPaid: false,
    ),
    OrderModel(
      orderId: 'ord-1025',
      orderNumber: '#1025',
      branchId: 'b1',
      tableNumber: 'T3',
      customerName: 'Hassan Shah',
      orderType: OrderType.dineIn,
      status: OrderStatus.served,
      items: const [
        OrderItem(menuItemId: 'm4', name: 'Special BBQ Platter', quantity: 1, unitPrice: 3600),
      ],
      subtotal: 3600,
      tax: 0,
      discount: 0,
      totalAmount: 3600,
      createdAt: DateTime(2026, 10, 14, 12, 45),
      isPaid: true,
      paymentMethod: 'Card',
    ),
  ];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get kdsOrders => _orders
      .where((o) =>
          o.status == OrderStatus.pending ||
          o.status == OrderStatus.preparing ||
          o.status == OrderStatus.ready)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final idx = _orders.indexWhere((o) => o.orderId == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void markOrderPaid(String orderId, String paymentMethod) {
    final idx = _orders.indexWhere((o) => o.orderId == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(
        isPaid: true,
        paymentMethod: paymentMethod,
        status: OrderStatus.completed,
      );
      notifyListeners();
    }
  }

  OrderModel? createOrderFromCart({required String branchId}) {
    if (_cart.isEmpty) return null;

    final nextNumber = '#${1026 + _orders.length}';
    final newOrder = OrderModel(
      orderId: _uuid.v4(),
      orderNumber: nextNumber,
      branchId: branchId,
      tableNumber: _currentOrderType == OrderType.dineIn ? _selectedTable : '-',
      customerName: _customerName,
      orderType: _currentOrderType,
      status: OrderStatus.pending,
      items: List.from(_cart),
      subtotal: cartSubtotal,
      tax: cartTax,
      discount: cartDiscount,
      totalAmount: cartGrandTotal,
      createdAt: DateTime.now(),
      isPaid: false,
    );

    _orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }
}

