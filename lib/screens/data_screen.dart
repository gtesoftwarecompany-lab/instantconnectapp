import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../services/wallet_service.dart';
import '../utils.dart';
import '../widgets/network_selector.dart';
import '../widgets/success_sheet.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _phone = TextEditingController();
  Network _network = networks.first;
  DataPlan _plan = dataPlans[0];
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _buy() async {
    if (_phone.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid 11-digit number')));
      return;
    }
    setState(() => _loading = true);

    // WE NOW USE _network.id
    final ok = await WalletService.instance
        .buyData(networkId: _network.id, phone: _phone.text, planId: _plan.id);

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      showSuccessSheet(
          context,
          '${_plan.size} (${_plan.validity}) sent to ${_phone.text}',
          _plan.price);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(WalletService.instance.error ?? 'Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Data')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Text('Select network',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          NetworkSelector(
              selected: _network,
              onChanged: (n) => setState(() => _network = n)),
          const SizedBox(height: 22),
          const Text('Phone number',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11)
            ],
            decoration: const InputDecoration(hintText: '08012345678'),
          ),
          const SizedBox(height: 22),
          const Text('Choose a plan',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...dataPlans.map((p) {
            final active = p == _plan;
            return GestureDetector(
              onTap: () => setState(() => _plan = p),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: active
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 1.5),
                ),
                child: Row(
                  children: [
                    Radio<DataPlan>(
                      value: p,
                      groupValue: _plan,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) => setState(() => _plan = v!),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.size,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(p.validity,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Text(formatNaira(p.price),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _loading ? null : _buy,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white))
                : Text('Buy ${_plan.size} for ${formatNaira(_plan.price)}'),
          ),
        ],
      ),
    );
  }
}
