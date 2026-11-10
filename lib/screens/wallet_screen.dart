import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = WalletService.instance;

    return AnimatedBuilder(
      animation: wallet,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Wallet')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available balance',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(formatNaira(wallet.balance),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text('Transaction history',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...wallet.transactions.map((t) => TransactionTile(txn: t)),
            ],
          ),
        );
      },
    );
  }
}
