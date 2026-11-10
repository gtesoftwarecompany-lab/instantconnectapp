import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../services/wallet_service.dart';
import '../utils.dart';
import '../widgets/network_selector.dart';
import '../widgets/success_sheet.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});
  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _amount = TextEditingController();
  Network _network = networks.first;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _buy() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amount.text);
    setState(() => _loading = true);

    // WE NOW USE _network.id
    final ok = await WalletService.instance
        .buyAirtime(networkId: _network.id, phone: _phone.text, amount: amount);

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      final phone = _phone.text;
      _phone.clear();
      _amount.clear();
      showSuccessSheet(
          context, '${_network.name} airtime delivered to $phone', amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(WalletService.instance.error ?? 'Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Airtime')),
      body: Form(
        key: _formKey,
        child: ListView(
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
              validator: (v) => (v == null || v.length != 11)
                  ? 'Enter valid 11-digit number'
                  : null,
            ),
            const SizedBox(height: 22),
            const Text('Amount', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  const InputDecoration(hintText: '0', prefixText: '₦ '),
              validator: (v) =>
                  (double.tryParse(v ?? '') == null || double.parse(v!) < 50)
                      ? 'Minimum is ₦50'
                      : null,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _loading ? null : _buy,
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white))
                  : const Text('Buy Now'),
            ),
            const SizedBox(height: 12),
            Center(
                child: Text(
                    'Balance: ${formatNaira(WalletService.instance.balance)}',
                    style: TextStyle(color: Colors.grey.shade600))),
          ],
        ),
      ),
    );
  }
}
