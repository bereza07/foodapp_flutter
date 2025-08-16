import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/orders/presentation/screens/order_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Подписываемся на список корзины — при изменении список перерисуется
    final cart = ref.watch(cartProvider);

    // 2) Получаем нотифаер для вызова методов (не для подписки)
    final cartNotifier = ref.read(cartProvider.notifier);

    // 3) Считаем итого на основе самого cart (реактивно)
    final total = cart.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: cart.isEmpty
          ? Center(child: Text('Ваша корзина пуста'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final ci = cart[index];
                      return ListTile(
                        // 4) ValueKey помогает Flutter корректно обновлять конкретный элемент
                        key: ValueKey(ci.item.id),
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(ci.item.imageUrl, fit: BoxFit.cover),
                        ),
                        title: Text(ci.item.name),
                        subtitle: Text('${ci.item.price.toStringAsFixed(2)} ₽ • Итого ${ci.totalPrice.toStringAsFixed(2)} ₽'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => cartNotifier.removeItem(ci.item),
                            ),
                            Text('${ci.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cartNotifier.addToCart(ci.item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Итого: ${total.toStringAsFixed(2)} ₽',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderScreen()),
                          );
                        },
                        child: const Text('Оформить'),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}