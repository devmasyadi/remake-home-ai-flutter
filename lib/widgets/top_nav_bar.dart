import 'dart:ui';

import 'package:ai_home_design/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.chair_alt_outlined, label: 'Room'),
      _NavItem(icon: Icons.style_outlined, label: 'Style'),
      _NavItem(icon: Icons.reviews_outlined, label: 'Review'),
      _NavItem(icon: Icons.workspace_premium_outlined, label: 'Result'),
      _NavItem(icon: Icons.list_alt_outlined, label: 'Price List'),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool isSelected = index == selectedIndex;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => onItemSelected(index),
                      splashColor: Colors.white.withValues(alpha: 0.06),
                      highlightColor: Colors.white.withValues(alpha: 0.04),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.6,
                                  ),
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isSelected
                                  ? AppColors.accent
                                  : Colors.white70,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? AppColors.accent
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
