import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (_phone.text.isEmpty || _password.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance
          .login(phone: _phone.text, password: _password.text);
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We added SingleChildScrollView to fix the overflow
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Push it down a bit
              const Icon(Icons.bolt, size: 80, color: AppTheme.primary),
              const Text('Instant Connect',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _phone,
                decoration: const InputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11)
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: _password,
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
