import 'package:flutter/material.dart';
import 'home_screen.dart';

// DIQQAT: bu ikki oyna hozircha SOXTA. Parol tekshirilmaydi, tugma bosilsa
// keyingi oynaga o'tadi, xolos. Bu "oynadan oynaga o'tish" namunasi.
// Qiyin vazifalardan biri: haqiqiy kirishni ulash (TASKS.md, 17-vazifa).

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(20), children: [
          Text('Qarz daftari', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Parol', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          FilledButton(
            // pushReplacement: orqaga qaytganda kirish oynasi qayta ochilmaydi
            onPressed: () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen())),
            child: const Text('Kirish'),
          ),
          TextButton(
            // push: yangi oyna ustiga ochiladi, orqaga (←) bilan qaytsa bo'ladi
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
            child: const Text('Ro’yxatdan o’tish'),
          ),
        ]),
      ),
    ),
  );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ro’yxatdan o’tish')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(20), children: [
          const TextField(decoration: InputDecoration(labelText: 'Ismingiz', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Parol', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          FilledButton(
            // pushAndRemoveUntil: avvalgi barcha oynalarni yopib, yangisini ochadi
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false),
            child: const Text('Ro’yxatdan o’tish'),
          ),
        ]),
      ),
    ),
  );
}

