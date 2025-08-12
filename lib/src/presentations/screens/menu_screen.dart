import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/presentations/menu_controller.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Меню ресторана')),
      body: menuAsync.when(
        data: (menu) => ListView.builder(
          itemCount: menu.length,
          itemBuilder: (context, index) {
            final item = menu[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: Text('${item.price.toStringAsFixed(2)} ₽'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
