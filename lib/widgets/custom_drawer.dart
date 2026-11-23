import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isPermanent;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isPermanent = false,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.dashboard_outlined, 'activeIcon': Icons.dashboard, 'title': 'Dashboard'},
      {'icon': Icons.restaurant_menu_outlined, 'activeIcon': Icons.restaurant_menu, 'title': 'Menu Management'},
      {'icon': Icons.point_of_sale_outlined, 'activeIcon': Icons.point_of_sale, 'title': 'POS Orders'},
      {'icon': Icons.table_restaurant_outlined, 'activeIcon': Icons.table_restaurant, 'title': 'Table Booking'},
      {'icon': Icons.kitchen_outlined, 'activeIcon': Icons.kitchen, 'title': 'Kitchen Display'},
      {'icon': Icons.inventory_2_outlined, 'activeIcon': Icons.inventory_2, 'title': 'Inventory / Stock'},
      {'icon': Icons.insights_outlined, 'activeIcon': Icons.insights, 'title': 'Reports & Analytics'},
      {'icon': Icons.people_outline, 'activeIcon': Icons.people, 'title': 'Staff Payouts'},
    ];

    Widget content = Container(
      width: 250,
      color: AppColors.surface,
      child: Column(
        children: [
          // Branding Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
                  ),
                  child: const Icon(Icons.ramen_dining_rounded, color: AppColors.primaryGold, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saffron & Slate',
                        style: TextStyle(
                          color: AppColors.primaryGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Executive Suite',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              itemCount: navItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;

                return InkWell(
                  onTap: () {
                    onItemSelected(index);
                    if (!isPermanent) {
                      Navigator.of(context).pop();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGold.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGold.withValues(alpha: 0.4) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? (item['activeIcon'] as IconData) : (item['icon'] as IconData),
                          color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Slogan & Accent Box (Figure 1 sidebar footer)
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cardSurface,
                  AppColors.primaryGold.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(Icons.local_dining_rounded, color: AppColors.primaryGold, size: 22),
                SizedBox(height: 6),
                Text(
                  'Good Food\nBetter Moments',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.lightGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isPermanent) {
      return content;
    }

    return Drawer(child: content);
  }
}
