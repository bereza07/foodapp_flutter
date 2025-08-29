import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/menu/domain/menu_item.dart';
import 'package:foodapp/src/features/menu/presentation/widgets/item_details.dart';

class MenuItemTile extends ConsumerWidget {
  final MenuItem item;
  const MenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      //leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(item.name),
      subtitle: Text(item.description),
      onTap: () {
        log(item.optionGroups.first.items.length.toString());
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(0)),
          isScrollControlled: true,
          builder: (context) => ItemDetails(item: item)
        );
      },
      trailing: IconButton(
        onPressed: () {
          ref.read(cartProvider.notifier).addToCart(item);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
