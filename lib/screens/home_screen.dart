import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/transaction_tile.dart';
import 'airtime_screen.dart';
import 'data_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WalletService.instance.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = WalletService.instance;

    return AnimatedBuilder(
      animation: wallet,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: wallet.refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primary,
                          child: Text('I',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Text('Instant Connect',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WalletScreen())),
                        icon: const Icon(Icons.account_balance_wallet_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _BalanceCard(balance: wallet.balance),
                  const SizedBox(height: 26),
                  const Text('Services',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _ServicesGrid(),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent transactions',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const WalletScreen())),
                          child: const Text('See all')),
                    ],
                  ),
                  if (wallet.transactions.isEmpty)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                            child: Text('No transactions yet',
                                style: TextStyle(color: Colors.grey.shade600))))
                  else
                    ...wallet.transactions
                        .take(4)
                        .map((t) => TransactionTile(txn: t)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Wallet balance',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text(formatNaira(balance),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const WalletScreen())),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Fund wallet'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> _items = const [
    {'label': 'Airtime', 'icon': Icons.phone_android, 'screen': 'airtime'},
    {'label': 'Data', 'icon': Icons.wifi, 'screen': 'data'},
    {'label': 'Electricity', 'icon': Icons.bolt, 'screen': null},
    {'label': 'Cable TV', 'icon': Icons.tv, 'screen': null},
    {'label': 'Betting', 'icon': Icons.sports_soccer, 'screen': null},
    {'label': 'Education', 'icon': Icons.school, 'screen': null},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: _items.map((item) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (item['screen'] == 'airtime') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AirtimeScreen()));
            } else if (item['screen'] == 'data') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DataScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['label']} coming soon')));
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData,
                    color: AppTheme.primary, size: 28),
                const SizedBox(height: 10),
                Text(item['label'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
