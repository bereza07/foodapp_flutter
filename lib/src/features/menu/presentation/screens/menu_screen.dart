import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:foodapp/src/features/menu/presentation/controllers/menu_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuProvider);
    final cart = ref.watch(cartProvider); // для счётчика товаров

    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню ресторана'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Supabase.instance.client.auth.signOut();
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              // Красный кружок с количеством
              if (cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: menuAsync.when(
        data: (menu) => ListView.builder(
          itemCount: menu.length,
          itemBuilder: (context, index) {
            final item = menu[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: IconButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(item);
                },
                icon: const Icon(Icons.add),
              ),
              leading: Image.network(item.imageUrl),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
