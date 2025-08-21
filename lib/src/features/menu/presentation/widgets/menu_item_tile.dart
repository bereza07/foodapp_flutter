import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/menu/domain/menu_item.dart';

class MenuItemTile extends ConsumerWidget {
  final MenuItem item;
  const MenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      //leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(item.name),
      subtitle: Text(item.description),
      trailing: IconButton(
        onPressed: () {
          ref.read(cartProvider.notifier).addToCart(item);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}