import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/user_role.dart';
import '../providers/app_state_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final bool isTablet;

  const CustomAppBar({
    super.key,
    this.onMenuPressed,
    this.isTablet = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: !isTablet && onMenuPressed != null
          ? IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryGold),
              onPressed: onMenuPressed,
            )
          : null,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.primaryGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saffron & Slate',
                style: TextStyle(
                  fontSize: isTablet ? 17 : 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.primaryGold,
                ),
              ),
              const Text(
                'MODERN DINING · MANAGEMENT',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Date Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primaryGold),
              SizedBox(width: 6),
              Text(
                'Today (14 Oct 2026)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Branch Switcher Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: appState.selectedBranchId,
              dropdownColor: AppColors.cardSurface,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryGold, size: 20),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
              onChanged: (val) {
                if (val != null) appState.setSelectedBranch(val);
              },
              items: [
                const DropdownMenuItem(
                  value: 'all',
                  child: Row(
                    children: [
                      Icon(Icons.storefront_rounded, size: 14, color: AppColors.primaryGold),
                      SizedBox(width: 6),
                      Text('All Branches'),
                    ],
                  ),
                ),
                ...appState.branches.map(
                  (b) => DropdownMenuItem(
                    value: b.id,
                    child: Text(b.name),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Role Switcher (For Evaluation & Role testing)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserRole>(
              value: appState.currentRole,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.badge_outlined, color: AppColors.primaryGold, size: 18),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGold),
              onChanged: (role) {
                if (role != null) appState.setRole(role);
              },
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.displayName),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

