class Branch {
  final String id;
  final String name;
  final String city;
  final String address;
  final String phone;
  final String startDate;
  final String endDate;
  final double totalIncome;
  final double totalExpense;
  final double profitLoss;
  final String status; // 'In Progress', 'Planning', 'Operational'

  const Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.profitLoss,
    required this.status,
  });
}

