import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/inventory_provider.dart';
import 'receipt_dialog.dart';

class CartSidebar extends StatelessWidget {
  const CartSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final cart = orderProvider.cart;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cart Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.cardHeader,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryGold, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Active Order Cart',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(color: AppColors.primaryGold, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (cart.isNotEmpty)
                  InkWell(
                    onTap: orderProvider.clearCart,
                    child: const Text('Clear', style: TextStyle(color: AppColors.alertRed, fontSize: 11)),
                  ),
              ],
            ),
          ),

          // Order Options (Type & Table)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Dine-In / Takeaway / Delivery Switcher
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: OrderType.values.map((type) {
                      final isSelected = orderProvider.currentOrderType == type;
                      return Expanded(
                        child: InkWell(
                          onTap: () => orderProvider.setOrderType(type),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryGold : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                type.label,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),

                // Table & Customer Name Row
                Row(
                  children: [
                    if (orderProvider.currentOrderType == OrderType.dineIn) ...[
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: orderProvider.selectedTable,
                          isDense: true,
                          decoration: const InputDecoration(
                            labelText: 'Table',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          dropdownColor: AppColors.surface,
                          items: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) orderProvider.setSelectedTable(val);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: orderProvider.customerName,
                        decoration: const InputDecoration(
                          labelText: 'Customer Name',
                          hintText: 'Walk-in Customer',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 12),
                        onChanged: (val) => orderProvider.setCustomerName(val),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Cart Items List
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 40, color: AppColors.textMuted),
                        SizedBox(height: 8),
                        Text('Your cart is empty', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        SizedBox(height: 4),
                        Text('Click items on the left to add', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    itemCount: cart.length,
                    separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 12),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${CurrencyFormatter.format(item.unitPrice)} each',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          // Quantity buttons
                          Row(
                            children: [
                              InkWell(
                                onTap: () => orderProvider.updateCartQuantity(item.menuItemId, item.quantity - 1),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.remove, size: 14, color: AppColors.primaryGold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              InkWell(
                                onTap: () => orderProvider.updateCartQuantity(item.menuItemId, item.quantity + 1),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.add, size: 14, color: AppColors.primaryGold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // Line total
                          Text(
                            CurrencyFormatter.format(item.lineTotal),
                            style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Calculations & Action Buttons
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(11)),
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                _buildCostRow('Subtotal', CurrencyFormatter.format(orderProvider.cartSubtotal)),
                const SizedBox(height: 4),
                _buildCostRow('Sales Tax / GST (16%)', CurrencyFormatter.format(orderProvider.cartTax)),
                if (orderProvider.cartDiscount > 0) ...[
                  const SizedBox(height: 4),
                  _buildCostRow('Discount (${orderProvider.discountPercent.toInt()}%)', '-${CurrencyFormatter.format(orderProvider.cartDiscount)}', isDiscount: true),
                ],
                const Divider(color: AppColors.border, height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      CurrencyFormatter.format(orderProvider.cartGrandTotal),
                      style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Order Action Buttons
                Row(
                  children: [
                    // Fire to KDS
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.elevatedSurface,
                          foregroundColor: AppColors.primaryGold,
                          side: const BorderSide(color: AppColors.primaryGold),
                        ),
                        onPressed: cart.isEmpty
                            ? null
                            : () {
                                final newOrder = orderProvider.createOrderFromCart(
                                  branchId: appState.selectedBranchId,
                                );
                                if (newOrder != null) {
                                  Provider.of<InventoryProvider>(context, listen: false)
                                      .deductIngredientsForOrder(newOrder.items, newOrder.orderNumber);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Order ${newOrder.orderNumber} sent to KDS! Ingredients deducted from stock.'),
                                      backgroundColor: AppColors.emeraldGreen,
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.microwave_outlined, size: 16),
                        label: const Text('Fire KDS', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Settle & Print Bill
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: cart.isEmpty
                            ? null
                            : () {
                                final newOrder = orderProvider.createOrderFromCart(
                                  branchId: appState.selectedBranchId,
                                );
                                if (newOrder != null) {
                                  Provider.of<InventoryProvider>(context, listen: false)
                                      .deductIngredientsForOrder(newOrder.items, newOrder.orderNumber);
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => ReceiptDialog(
                                      order: newOrder,
                                      onPaymentSettled: (method) {
                                        orderProvider.markOrderPaid(newOrder.orderId, method);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Order ${newOrder.orderNumber} paid via $method!'),
                                            backgroundColor: AppColors.emeraldGreen,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.print_outlined, size: 16),
                        label: const Text('Pay & Bill', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String title, String val, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(
          val,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.emeraldGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
