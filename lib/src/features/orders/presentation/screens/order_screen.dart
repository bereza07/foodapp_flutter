import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/orders/data/order_repository.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    final total = cart.fold(0.0, (sum, item) => sum + item.item.price * item.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cart.map((item) {
                  return ListTile(
                    title: Text(item.item.name),
                    subtitle: Text('${item.quantity} x ${item.item.price} ₽'),
                  );
                }).toList(),
              ),
            ),
            Text('Итого: $total ₽'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await OrderRepository().createOrder(cart, total);
                ref.read(cartProvider.notifier).clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заказ оформлен!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Оформить заказ'),
            )
          ],
        ),
      ),
    );
  }
}