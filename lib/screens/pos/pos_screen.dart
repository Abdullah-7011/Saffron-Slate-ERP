import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import 'widgets/item_card.dart';
import 'widgets/cart_sidebar.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Area: Category filters, Search, Menu Grid
                Expanded(
                  flex: isWide ? 5 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search & Quick Category Filters
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: menuProvider.setSearchQuery,
                              decoration: InputDecoration(
                                hintText: 'Search dishes, BBQ, karahi, drinks...',
                                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold, size: 20),
                                suffixIcon: menuProvider.searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () => menuProvider.setSearchQuery(''),
                                      )
                                    : null,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                            ),
                          ),
                          if (!isWide) ...[
                            const SizedBox(width: 8),
                            // Mobile Floating Cart Button
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primaryGold,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (ctx) => Container(
                                    height: MediaQuery.of(context).size.height * 0.85,
                                    margin: const EdgeInsets.all(12),
                                    child: const CartSidebar(),
                                  ),
                                );
                              },
                              icon: Badge(
                                label: Text('${orderProvider.cart.length}'),
                                child: const Icon(Icons.shopping_cart),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Category Horizontal List
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: menuProvider.categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = menuProvider.categories[index];
                            final isSelected = menuProvider.selectedCategory == cat;

                            return InkWell(
                              onTap: () => menuProvider.setCategory(cat),
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryGold : AppColors.cardSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primaryGold : AppColors.border,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : AppColors.textSecondary,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Menu Grid
                      Expanded(
                        child: menuProvider.filteredItems.isEmpty
                            ? const Center(
                                child: Text('No dishes match your search.', style: TextStyle(color: AppColors.textMuted)),
                              )
                            : GridView.builder(
                                itemCount: menuProvider.filteredItems.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWide ? 3 : 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.15,
                                ),
                                itemBuilder: (context, index) {
                                  final item = menuProvider.filteredItems[index];
                                  return ItemCard(
                                    item: item,
                                    onAddToCart: () {
                                      orderProvider.addToCart(item.id, item.name, item.price);
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Added "${item.name}" to cart'),
                                          duration: const Duration(milliseconds: 700),
                                          backgroundColor: AppColors.cardSurface,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),

                // Right Area: Split Screen Cart Sidebar for Tablet
                if (isWide) ...[
                  const SizedBox(width: 16),
                  const Expanded(
                    flex: 3,
                    child: CartSidebar(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
