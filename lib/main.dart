import 'package:flutter/material.dart';
import 'package:praktika/screens/auth_screens.dart';
import 'screens/auth_screens.dart' hide LoginScreen;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Praktika: Qarz daftari',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF0E6F6E)),
    darkTheme: ThemeData(
        useMaterial3: true, colorSchemeSeed: const Color(0xFF0E6F6E), brightness: Brightness.dark),
    home: const LoginScreen(),
  );
}

