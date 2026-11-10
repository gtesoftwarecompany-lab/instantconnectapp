import 'package:flutter/material.dart';
import '../utils.dart';

void showSuccessSheet(BuildContext context, String message, double amount) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFE3F7EE),
              child: Icon(Icons.check_rounded, size: 40, color: Colors.green)),
          const SizedBox(height: 16),
          const Text('Transaction Successful',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 6),
          Text(formatNaira(amount),
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done')),
        ],
      ),
    ),
  );
}
