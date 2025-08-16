

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/auth/presentation/controllers/auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true; // true = вход, false = регистрация

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Вход' : 'Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон (+7...)',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Пароль',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            if (authState.error != null)
              Text(
                authState.error!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 12),

            authState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final phone = phoneController.text.trim();
                      final pass = passwordController.text.trim();

                      if (isLogin) {
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithPhone(phone, pass);
                      } else {
                        ref
                            .read(authControllerProvider.notifier)
                            .signUpWithPhone(phone, pass);
                      }
                    },
                    child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                  ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin
                  ? 'Нет аккаунта? Зарегистрироваться'
                  : 'Есть аккаунт? Войти'),
            )
          ],
        ),
      ),
    );
  }
}