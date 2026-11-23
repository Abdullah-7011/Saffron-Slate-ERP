import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/user_role.dart';
import '../providers/app_state_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'dashboard/executive_dashboard_screen.dart';
import 'menu/menu_management_screen.dart';
import 'pos/pos_screen.dart';
import 'tables/table_management_screen.dart';
import 'kds/kitchen_display_screen.dart';
import 'inventory/inventory_screen.dart';
import 'reports/reports_screen.dart';
import 'payouts/staff_payouts_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserRole? _lastRole;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _syncRoleView(UserRole currentRole) {
    if (_lastRole != currentRole) {
      _lastRole = currentRole;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (currentRole) {
          case UserRole.chef:
            _onTabChanged(4); // KDS
            break;
          case UserRole.cashier:
            _onTabChanged(2); // POS
            break;
          case UserRole.waiter:
            _onTabChanged(3); // Tables
            break;
          case UserRole.branchManager:
          case UserRole.superAdmin:
            _onTabChanged(0); // Dashboard
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    _syncRoleView(appState.currentRole);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTabletOrDesktop = constraints.maxWidth >= 900;

        final screens = [
          ExecutiveDashboardScreen(onNavigateTab: _onTabChanged),
          const MenuManagementScreen(),
          const PosScreen(),
          const TableManagementScreen(),
          const KitchenDisplayScreen(),
          const InventoryScreen(),
          const ReportsScreen(),
          const StaffPayoutsScreen(),
        ];

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            isTablet: isTabletOrDesktop,
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          drawer: isTabletOrDesktop
              ? null
              : CustomDrawer(
                  selectedIndex: _currentIndex,
                  onItemSelected: _onTabChanged,
                ),
          body: Row(
            children: [
              if (isTabletOrDesktop)
                CustomDrawer(
                  selectedIndex: _currentIndex,
                  onItemSelected: _onTabChanged,
                  isPermanent: true,
                ),
              Expanded(
                child: screens[_currentIndex],
              ),
            ],
          ),
          bottomNavigationBar: isTabletOrDesktop
              ? null
              : BottomNavigationBar(
                  currentIndex: _currentIndex >= 4 ? 0 : _currentIndex,
                  onTap: (idx) => _onTabChanged(idx),
                  backgroundColor: AppColors.surface,
                  selectedItemColor: AppColors.primaryGold,
                  unselectedItemColor: AppColors.textMuted,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 11,
                  unselectedFontSize: 10,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
                    BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), activeIcon: Icon(Icons.restaurant_menu), label: 'Menu'),
                    BottomNavigationBarItem(icon: Icon(Icons.point_of_sale_outlined), activeIcon: Icon(Icons.point_of_sale), label: 'POS'),
                    BottomNavigationBarItem(icon: Icon(Icons.table_restaurant_outlined), activeIcon: Icon(Icons.table_restaurant), label: 'Tables'),
                  ],
                ),
        );
      },
    );
  }
}

