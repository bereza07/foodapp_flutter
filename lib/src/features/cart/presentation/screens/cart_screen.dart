import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/orders/presentation/screens/order_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final total = cart.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Ваша корзина пуста'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final ci = cart[index];
                      return ListTile(
                        key: ValueKey('${ci.item.id}_${ci.selectedOptions.map((o) => o.id).join("_")}'),
                        /*leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(ci.item.imageUrl, fit: BoxFit.cover),
                        ),*/
                        title: Text(ci.item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // цена за единицу
                            Text('${ci.item.price.toStringAsFixed(2)} ₽'),
                            // список выбранных опций
                            if (ci.selectedOptions.isNotEmpty)
                              Wrap(
                                children: ci.selectedOptions.map((o) => Padding(
                                  padding: const EdgeInsets.only(right: 6.0, top: 2),
                                  child: Chip(
                                    label: Text('${o.name} +${o.additionalPrice.toStringAsFixed(2)} ₽'),
                                  ),
                                )).toList(),
                              ),
                            // общая цена для этого CartItem
                            Text('Итого: ${ci.totalPrice.toStringAsFixed(2)} ₽'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => cartNotifier.removeItem(ci),
                            ),
                            Text('${ci.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cartNotifier.addToCart(
                                  ci.item,
                                  selectedOptions: ci.selectedOptions),
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
