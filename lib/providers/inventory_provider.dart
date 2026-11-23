import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_item.dart';

class InventoryProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<InventoryItem> _items = [
    const InventoryItem(
      id: 'inv-1',
      branchId: 'b1',
      name: 'Chicken',
      currentStock: 12.0,
      unit: 'Kg',
      reorderLevel: 20.0,
      status: StockStatus.low,
    ),
    const InventoryItem(
      id: 'inv-2',
      branchId: 'b1',
      name: 'Beef',
      currentStock: 8.0,
      unit: 'Kg',
      reorderLevel: 15.0,
      status: StockStatus.low,
    ),
    const InventoryItem(
      id: 'inv-3',
      branchId: 'b1',
      name: 'Rice',
      currentStock: 25.0,
      unit: 'Kg',
      reorderLevel: 15.0,
      status: StockStatus.good,
    ),
    const InventoryItem(
      id: 'inv-4',
      branchId: 'b1',
      name: 'Tomatoes',
      currentStock: 18.0,
      unit: 'Kg',
      reorderLevel: 10.0,
      status: StockStatus.good,
    ),
    const InventoryItem(
      id: 'inv-5',
      branchId: 'b1',
      name: 'Spices',
      currentStock: 10.0,
      unit: 'Kg',
      reorderLevel: 5.0,
      status: StockStatus.good,
    ),
    const InventoryItem(
      id: 'inv-6',
      branchId: 'b1',
      name: 'Cooking Oil',
      currentStock: 5.0,
      unit: 'L',
      reorderLevel: 15.0,
      status: StockStatus.low,
    ),
    const InventoryItem(
      id: 'inv-7',
      branchId: 'b1',
      name: 'Flour (Atta)',
      currentStock: 40.0,
      unit: 'Kg',
      reorderLevel: 20.0,
      status: StockStatus.good,
    ),
    const InventoryItem(
      id: 'inv-8',
      branchId: 'b1',
      name: 'Dairy & Cheese',
      currentStock: 6.5,
      unit: 'Kg',
      reorderLevel: 10.0,
      status: StockStatus.low,
    ),
  ];

  List<InventoryItem> get items => List.unmodifiable(_items);

  List<InventoryItem> get lowStockItems =>
      _items.where((i) => i.status == StockStatus.low).toList();

  final List<StockMovement> _movements = [
    StockMovement(
      id: 'mov-1',
      ingredientName: 'Chicken',
      type: 'Used',
      quantity: 8.0,
      unit: 'Kg',
      reason: 'Lunch rush orders',
      actorName: 'Ali Raza',
      timestamp: DateTime(2026, 10, 14, 11, 45),
    ),
    StockMovement(
      id: 'mov-2',
      ingredientName: 'Rice',
      type: 'Received',
      quantity: 50.0,
      unit: 'Kg',
      reason: 'Weekly vendor delivery',
      actorName: 'Hassan Shah',
      timestamp: DateTime(2026, 10, 14, 09, 15),
    ),
    StockMovement(
      id: 'mov-3',
      ingredientName: 'Cooking Oil',
      type: 'Used',
      quantity: 5.0,
      unit: 'L',
      reason: 'Deep fryers refill',
      actorName: 'Zaid Khan',
      timestamp: DateTime(2026, 10, 14, 10, 30),
    ),
  ];

  List<StockMovement> get movements => List.unmodifiable(_movements);

  void updateStock(String id, double adjustmentAmount, String reason, String actorName, String type) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      final current = _items[idx];
      final newStock = (current.currentStock + adjustmentAmount).clamp(0.0, double.infinity);
      final newStatus = newStock <= current.reorderLevel ? StockStatus.low : StockStatus.good;

      _items[idx] = current.copyWith(
        currentStock: newStock,
        status: newStatus,
      );

      _movements.insert(
        0,
        StockMovement(
          id: _uuid.v4(),
          ingredientName: current.name,
          type: type,
          quantity: adjustmentAmount.abs(),
          unit: current.unit,
          reason: reason,
          actorName: actorName,
          timestamp: DateTime.now(),
        ),
      );

      notifyListeners();
    }
  }

  void deductIngredientsForOrder(List<dynamic> items, String orderNumber) {
    for (final item in items) {
      final name = item.name.toString().toLowerCase();
      final qty = (item.quantity as int? ?? 1).toDouble();

      if (name.contains('karahi')) {
        _deductIngredientByName('Chicken', 1.0 * qty, 'Order $orderNumber preparation');
        _deductIngredientByName('Tomatoes', 0.5 * qty, 'Order $orderNumber preparation');
        _deductIngredientByName('Cooking Oil', 0.2 * qty, 'Order $orderNumber preparation');
      } else if (name.contains('biryani')) {
        _deductIngredientByName('Rice', 0.5 * qty, 'Order $orderNumber preparation');
        _deductIngredientByName('Chicken', 0.5 * qty, 'Order $orderNumber preparation');
      } else if (name.contains('bbq') || name.contains('boti') || name.contains('tikka')) {
        _deductIngredientByName('Chicken', 0.8 * qty, 'Order $orderNumber preparation');
        _deductIngredientByName('Spices', 0.1 * qty, 'Order $orderNumber preparation');
      } else if (name.contains('pizza')) {
        _deductIngredientByName('Flour (Atta)', 0.4 * qty, 'Order $orderNumber preparation');
        _deductIngredientByName('Dairy & Cheese', 0.3 * qty, 'Order $orderNumber preparation');
      } else if (name.contains('pasta')) {
        _deductIngredientByName('Dairy & Cheese', 0.2 * qty, 'Order $orderNumber preparation');
      }
    }
    notifyListeners();
  }

  void _deductIngredientByName(String ingredientName, double amount, String reason) {
    final idx = _items.indexWhere((i) => i.name.toLowerCase() == ingredientName.toLowerCase());
    if (idx != -1) {
      final current = _items[idx];
      final newStock = (current.currentStock - amount).clamp(0.0, double.infinity);
      final newStatus = newStock <= current.reorderLevel ? StockStatus.low : StockStatus.good;

      _items[idx] = current.copyWith(
        currentStock: newStock,
        status: newStatus,
      );

      _movements.insert(
        0,
        StockMovement(
          id: _uuid.v4(),
          ingredientName: current.name,
          type: 'Used',
          quantity: amount,
          unit: current.unit,
          reason: reason,
          actorName: 'Kitchen Automation',
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  void addIngredient(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }
}

