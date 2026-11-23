import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor = color ?? AppColors.primaryGold;
    Color bgColor = backgroundColor ?? badgeColor.withValues(alpha: 0.15);

    final normalized = label.toLowerCase().trim();

    if (normalized == 'good' || normalized == 'served' || normalized == 'confirmed' || normalized == 'available' || normalized == 'completed') {
      badgeColor = AppColors.emeraldGreen;
      bgColor = AppColors.emeraldGreenGlow;
    } else if (normalized == 'low' || normalized == 'cancelled' || normalized == 'occupied') {
      badgeColor = AppColors.alertRed;
      bgColor = AppColors.alertRedGlow;
    } else if (normalized == 'preparing' || normalized == 'in progress' || normalized == 'reserved') {
      badgeColor = AppColors.warningAmber;
      bgColor = AppColors.warningAmberGlow;
    } else if (normalized == 'pending' || normalized == 'planning') {
      badgeColor = AppColors.infoBlue;
      bgColor = AppColors.infoBlueGlow;
    } else if (normalized == 'ready') {
      badgeColor = AppColors.purpleAccent;
      bgColor = AppColors.purpleAccent.withValues(alpha: 0.2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
