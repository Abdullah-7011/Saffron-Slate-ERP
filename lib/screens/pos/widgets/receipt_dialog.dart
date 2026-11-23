import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/order.dart';

class ReceiptDialog extends StatelessWidget {
  final OrderModel order;
  final ValueChanged<String>? onPaymentSettled;

  const ReceiptDialog({
    super.key,
    required this.order,
    this.onPaymentSettled,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Receipt Header
              const Text(
                'SAFFRON & SLATE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'Modern Dining & Restaurant Management',
                style: TextStyle(color: Colors.black54, fontSize: 10),
              ),
              const Text(
                'Lahore, Pakistan • Tel: +92 42 35789001',
                style: TextStyle(color: Colors.black54, fontSize: 10),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.black26, thickness: 1),

              // Order Meta
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order: ${order.orderNumber}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(order.orderType.label, style: const TextStyle(color: Colors.black87, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Table: ${order.tableNumber}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                  Text(
                    DateFormat('dd-MMM-yyyy hh:mm a').format(order.createdAt),
                    style: const TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Customer: ${order.customerName}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                  Text('Status: ${order.status.label}', style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.black26, thickness: 1),

              // Items
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('${item.quantity}x ', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(item.lineTotal),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(color: Colors.black26, thickness: 1),

              // Totals
              _buildReceiptRow('Subtotal', CurrencyFormatter.format(order.subtotal)),
              if (order.tax > 0)
                _buildReceiptRow('Sales Tax / GST (16%)', CurrencyFormatter.format(order.tax)),
              if (order.discount > 0)
                _buildReceiptRow('Discount', '-${CurrencyFormatter.format(order.discount)}'),
              const SizedBox(height: 4),
              const Divider(color: Colors.black87, thickness: 1.5),
              _buildReceiptRow(
                'GRAND TOTAL',
                CurrencyFormatter.format(order.totalAmount),
                isBold: true,
                fontSize: 16,
              ),
              const Divider(color: Colors.black87, thickness: 1.5),
              const SizedBox(height: 8),

              // Thank You
              const Text(
                'Thank you for dining with Saffron & Slate!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic, fontSize: 11),
              ),
              const Text(
                'Software: Saffron & Slate ERP',
                style: TextStyle(color: Colors.black38, fontSize: 9),
              ),
              const SizedBox(height: 16),

              // Payment Action Buttons
              if (!order.isPaid) ...[
                const Text('Select Payment Method to Settle Bill:', style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        onPressed: () {
                          onPaymentSettled?.call('Cash');
                          Navigator.pop(context);
                        },
                        child: const Text('Cash', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold, foregroundColor: Colors.black),
                        onPressed: () {
                          onPaymentSettled?.call('Card');
                          Navigator.pop(context);
                        },
                        child: const Text('Card', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Text('Paid via ${order.paymentMethod}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black54)),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Close Receipt'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String title, String val, {bool isBold = false, double fontSize = 12}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

