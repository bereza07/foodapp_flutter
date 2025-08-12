
import 'package:foodapp/src/features/menu/domain/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;

  CartItem({
    required this.item,
    required this.quantity
  });

  CartItem copyWith(int? quantity){
    return CartItem(item: item, quantity: quantity ?? this.quantity);
  }

  double get totalPrice{
    return item.price * quantity;
  }

  @override
  String toString() {
    return 'CartItem(menuItem: ${item.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}