import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class NetworkSelector extends StatelessWidget {
  final Network selected;
  final ValueChanged<Network> onChanged;
  const NetworkSelector(
      {super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: networks.map((n) {
        final isActive = n.name == selected.name;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(n),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color:
                    isActive ? n.color.withValues(alpha: 0.12) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isActive ? AppTheme.primary : Colors.transparent,
                    width: 1.5),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: n.color,
                    child: Text(n.initial,
                        style: TextStyle(
                            color: n.onColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  const SizedBox(height: 6),
                  Text(n.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
