class StaffPayout {
  final String id;
  final String staffName;
  final String role;
  final int daysWorked;
  final double dailyRate;
  final double totalAmount;
  final DateTime payoutDate;
  final bool isDisbursed;

  const StaffPayout({
    required this.id,
    required this.staffName,
    required this.role,
    required this.daysWorked,
    required this.dailyRate,
    required this.totalAmount,
    required this.payoutDate,
    this.isDisbursed = false,
  });

  StaffPayout copyWith({
    String? id,
    String? staffName,
    String? role,
    int? daysWorked,
    double? dailyRate,
    double? totalAmount,
    DateTime? payoutDate,
    bool? isDisbursed,
  }) {
    return StaffPayout(
      id: id ?? this.id,
      staffName: staffName ?? this.staffName,
      role: role ?? this.role,
      daysWorked: daysWorked ?? this.daysWorked,
      dailyRate: dailyRate ?? this.dailyRate,
      totalAmount: totalAmount ?? this.totalAmount,
      payoutDate: payoutDate ?? this.payoutDate,
      isDisbursed: isDisbursed ?? this.isDisbursed,
    );
  }
}

