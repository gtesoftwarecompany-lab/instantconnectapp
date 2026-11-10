import 'package:flutter/material.dart';
import '../models.dart';
import '../utils.dart';

class TransactionTile extends StatelessWidget {
  final Transaction txn;
  const TransactionTile({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    final d = txn.date;
    final dateLabel = '${d.day}/${d.month}/${d.year}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (txn.isCredit ? Colors.green : Colors.orange)
                  .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(txn.isCredit ? Icons.south_west : Icons.north_east,
                color: txn.isCredit ? Colors.green : Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(dateLabel,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text('${txn.isCredit ? '+' : '-'}${formatNaira(txn.amount)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: txn.isCredit ? Colors.green : Colors.black87)),
        ],
      ),
    );
  }
}
