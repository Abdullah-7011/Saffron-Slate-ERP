import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/menu_item.dart';
import '../../providers/menu_provider.dart';

class MenuManagementScreen extends StatelessWidget {
  const MenuManagementScreen({super.key});

  void _showAddDishDialog(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedCategory = menuProvider.categories.firstWhere((c) => c != 'All', orElse: () => 'Karahi & Handi');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
            title: const Text('Add New Dish', style: TextStyle(color: Colors.white, fontSize: 16)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Dish Name')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    dropdownColor: AppColors.surface,
                    items: menuProvider.categories.where((c) => c != 'All').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price in PKR (Rs.)')),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Ingredients / Description')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
              ElevatedButton(
                onPressed: () {
                  final price = double.tryParse(priceCtrl.text) ?? 0.0;
                  if (nameCtrl.text.trim().isEmpty || price <= 0) return;

                  final newItem = MenuItemModel(
                    id: const Uuid().v4(),
                    category: selectedCategory,
                    name: nameCtrl.text.trim(),
                    price: price,
                    description: descCtrl.text.trim().isEmpty ? 'Chef special recipe' : descCtrl.text.trim(),
                    isAvailable: true,
                    iconEmoji: '🍲',
                  );

                  menuProvider.addMenuItem(newItem);
                  Navigator.pop(ctx);
                },
                child: const Text('Save Dish'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menu & Dish Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Configure menu categories, pricing and real-time kitchen availability', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddDishDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Dish'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search & Category Chips
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: menuProvider.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Filter dish catalog...',
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryGold, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: menuProvider.categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = menuProvider.categories[index];
                  final isSelected = menuProvider.selectedCategory == cat;

                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGold,
                    backgroundColor: AppColors.cardSurface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 11,
                    ),
                    onSelected: (_) => menuProvider.setCategory(cat),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Items List
            Expanded(
              child: ListView.separated(
                itemCount: menuProvider.filteredItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = menuProvider.filteredItems[index];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.elevatedSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text(item.iconEmoji, style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.elevatedSurface, borderRadius: BorderRadius.circular(4)),
                                    child: Text(item.category, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          CurrencyFormatter.format(item.price),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGold, fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        // Real-time Availability Switch
                        Row(
                          children: [
                            Text(
                              item.isAvailable ? 'In Stock' : 'Sold Out',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: item.isAvailable ? AppColors.emeraldGreen : AppColors.alertRed,
                              ),
                            ),
                            Switch(
                              value: item.isAvailable,
                              activeThumbColor: AppColors.emeraldGreen,
                              inactiveTrackColor: AppColors.alertRed.withValues(alpha: 0.3),
                              onChanged: (_) => menuProvider.toggleAvailability(item.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
