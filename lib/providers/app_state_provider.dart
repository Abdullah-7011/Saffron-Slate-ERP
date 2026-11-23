import 'package:flutter/material.dart';
import '../models/branch.dart';
import '../models/user_role.dart';
import '../models/staff_payout.dart';

class AppStateProvider extends ChangeNotifier {
  // Current logged in role
  UserRole _currentRole = UserRole.superAdmin;
  UserRole get currentRole => _currentRole;

  void setRole(UserRole newRole) {
    _currentRole = newRole;
    notifyListeners();
  }

  // Selected branch filter: 'all' or branch.id
  String _selectedBranchId = 'all';
  String get selectedBranchId => _selectedBranchId;

  void setSelectedBranch(String branchId) {
    _selectedBranchId = branchId;
    notifyListeners();
  }

  // Selected date filter
  DateTime _selectedDate = DateTime(2026, 10, 14);
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Branches list (matching official client overview in Figure 1)
  final List<Branch> _branches = [
    const Branch(
      id: 'b1',
      name: 'Main Branch',
      city: 'Lahore',
      address: 'Mall Road, Commercial Area',
      phone: '+92 42 35789001',
      startDate: '01 Aug 2026',
      endDate: '30 Dec 2026',
      totalIncome: 2540000,
      totalExpense: 1280000,
      profitLoss: 1260000,
      status: 'In Progress',
    ),
    const Branch(
      id: 'b2',
      name: 'City Mall',
      city: 'Lahore',
      address: 'Level 3 Food Court, City Mall',
      phone: '+92 42 35789002',
      startDate: '15 Jul 2026',
      endDate: '31 Dec 2026',
      totalIncome: 2860000,
      totalExpense: 1145000,
      profitLoss: 1715000,
      status: 'In Progress',
    ),
    const Branch(
      id: 'b3',
      name: 'Defense Road',
      city: 'Lahore',
      address: 'Phase 5 DHA Commercial',
      phone: '+92 42 35789003',
      startDate: '10 Sep 2026',
      endDate: '28 Feb 2027',
      totalIncome: 2130000,
      totalExpense: 980000,
      profitLoss: 1150000,
      status: 'In Progress',
    ),
    const Branch(
      id: 'b4',
      name: 'Gulberg',
      city: 'Lahore',
      address: 'Main Boulevard, Gulberg III',
      phone: '+92 42 35789004',
      startDate: '01 Oct 2026',
      endDate: '30 Apr 2027',
      totalIncome: 1820000,
      totalExpense: 740000,
      profitLoss: 1080000,
      status: 'In Progress',
    ),
    const Branch(
      id: 'b5',
      name: 'Johar Town',
      city: 'Lahore',
      address: 'G1 Market, Johar Town',
      phone: '+92 42 35789005',
      startDate: '01 Nov 2026',
      endDate: '30 Apr 2027',
      totalIncome: 1450000,
      totalExpense: 835000,
      profitLoss: 615000,
      status: 'Planning',
    ),
  ];

  List<Branch> get branches => List.unmodifiable(_branches);

  Branch? get currentBranch {
    if (_selectedBranchId == 'all') return null;
    return _branches.firstWhere(
      (b) => b.id == _selectedBranchId,
      orElse: () => _branches.first,
    );
  }

  // Staff Payouts (Figure 1 Panel 4)
  final List<StaffPayout> _staffPayouts = [
    StaffPayout(
      id: '1',
      staffName: 'Ali Raza',
      role: 'Head Chef',
      daysWorked: 26,
      dailyRate: 1200,
      totalAmount: 31200,
      payoutDate: DateTime(2026, 10, 14),
    ),
    StaffPayout(
      id: '2',
      staffName: 'Zaid Khan',
      role: 'Sous Chef',
      daysWorked: 24,
      dailyRate: 1000,
      totalAmount: 24000,
      payoutDate: DateTime(2026, 10, 14),
    ),
    StaffPayout(
      id: '3',
      staffName: 'Usman Ali',
      role: 'Cashier / POS',
      daysWorked: 26,
      dailyRate: 1000,
      totalAmount: 26000,
      payoutDate: DateTime(2026, 10, 14),
    ),
    StaffPayout(
      id: '4',
      staffName: 'Ayesha Malik',
      role: 'Waitstaff',
      daysWorked: 25,
      dailyRate: 1000,
      totalAmount: 25000,
      payoutDate: DateTime(2026, 10, 14),
    ),
    StaffPayout(
      id: '5',
      staffName: 'Hassan Shah',
      role: 'Inventory Controller',
      daysWorked: 26,
      dailyRate: 1000,
      totalAmount: 26000,
      payoutDate: DateTime(2026, 10, 14),
    ),
  ];

  List<StaffPayout> get staffPayouts => List.unmodifiable(_staffPayouts);

  double get totalStaffPayout =>
      _staffPayouts.fold(0.0, (acc, p) => acc + p.totalAmount);

  void addStaffPayout(StaffPayout payout) {
    _staffPayouts.add(payout);
    notifyListeners();
  }

  void markPayoutDisbursed(String id) {
    final idx = _staffPayouts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _staffPayouts[idx] = _staffPayouts[idx].copyWith(isDisbursed: true);
      notifyListeners();
    }
  }

  // Key KPI Metrics
  int get totalOrdersCount => 28;
  int get activeOrdersCount => 8;
  double get todayIncome => 48750.0;
  double get monthlyExpenses => 17230.0;
  double get netProfit => 31520.0;
}

