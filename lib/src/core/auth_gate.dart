import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:foodapp/src/features/auth/presentation/screens/auth_sreen.dart';
import 'package:foodapp/src/features/menu/presentation/screens/menu_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const MenuScreen();
        } else {
          return const AuthScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Ошибка: $err')),
      ),
    );
  }
}