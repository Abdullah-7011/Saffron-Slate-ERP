import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/status_badge.dart';

class KitchenDisplayScreen extends StatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  State<KitchenDisplayScreen> createState() => _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends State<KitchenDisplayScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final activeOrders = orderProvider.kdsOrders.where((o) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Pending') return o.status == OrderStatus.pending;
      if (_selectedFilter == 'Preparing') return o.status == OrderStatus.preparing;
      if (_selectedFilter == 'Ready') return o.status == OrderStatus.ready;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KDS Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.microwave_rounded, color: AppColors.warningAmber, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kitchen Display System (KDS)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${activeOrders.length} active tickets queued • Real-time Sync Active',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Filter Chips
                Row(
                  children: ['All', 'Pending', 'Preparing', 'Ready'].map((f) {
                    final isSel = _selectedFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: isSel,
                        selectedColor: AppColors.primaryGold,
                        backgroundColor: AppColors.cardSurface,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.black : AppColors.textSecondary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11,
                        ),
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tickets Grid
            Expanded(
              child: activeOrders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 50, color: AppColors.emeraldGreen),
                          SizedBox(height: 12),
                          Text(
                            'All Orders Completed!',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text('Kitchen queue is clear right now.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 1100) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 750) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 500) {
                          crossAxisCount = 2;
                        }

                        return GridView.builder(
                          itemCount: activeOrders.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            final order = activeOrders[index];
                            return _buildKitchenTicketCard(order, orderProvider);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitchenTicketCard(OrderModel order, OrderProvider orderProvider) {
    Color headerBorderColor = AppColors.infoBlue;
    if (order.status == OrderStatus.preparing) {
      headerBorderColor = AppColors.warningAmber;
    } else if (order.status == OrderStatus.ready) {
      headerBorderColor = AppColors.purpleAccent;
    }

    final elapsed = DateTime.now().difference(order.createdAt).inMinutes;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: headerBorderColor.withValues(alpha: 0.8), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ticket Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBorderColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'Table ${order.tableNumber} • ${order.orderType.label}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusBadge(label: order.status.label),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          '${elapsed.clamp(1, 120)}m ago',
                          style: TextStyle(
                            fontSize: 10,
                            color: elapsed > 20 ? AppColors.alertRed : AppColors.textMuted,
                            fontWeight: elapsed > 20 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 10),
              itemBuilder: (context, idx) {
                final item = order.items[idx];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryGold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          if (item.notes.isNotEmpty)
                            Text(
                              'Note: ${item.notes}',
                              style: const TextStyle(color: AppColors.alertRed, fontSize: 10, fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Action Progression Button
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: _buildActionButton(order, orderProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(OrderModel order, OrderProvider orderProvider) {
    if (order.status == OrderStatus.pending) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warningAmber,
          foregroundColor: Colors.black,
        ),
        onPressed: () => orderProvider.updateOrderStatus(order.orderId, OrderStatus.preparing),
        icon: const Icon(Icons.soup_kitchen_rounded, size: 16),
        label: const Text('Start Preparing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
    } else if (order.status == OrderStatus.preparing) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleAccent,
          foregroundColor: Colors.white,
        ),
        onPressed: () => orderProvider.updateOrderStatus(order.orderId, OrderStatus.ready),
        icon: const Icon(Icons.done_all, size: 16),
        label: const Text('Mark as Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
    } else if (order.status == OrderStatus.ready) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldGreen,
          foregroundColor: Colors.black,
        ),
        onPressed: () => orderProvider.updateOrderStatus(order.orderId, OrderStatus.served),
        icon: const Icon(Icons.delivery_dining_rounded, size: 16),
        label: const Text('Served & Complete', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
    }
    return const SizedBox.shrink();
  }
}
