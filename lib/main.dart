import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';
import 'services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasToken = await ApiClient.instance.hasToken();
  runApp(InstantConnectApp(isLoggedIn: hasToken));
}

class InstantConnectApp extends StatelessWidget {
  final bool isLoggedIn;
  const InstantConnectApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instant Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
