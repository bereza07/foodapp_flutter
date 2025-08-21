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

  Map<String, dynamic> toMap() {
    return {
      'item': {
        'id': item.id,
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'image_url': item.imageUrl,
        'category': item.category,
      },
      'quantity': quantity,
    };
  }

factory CartItem.fromMap(Map<String, dynamic> map) {
  final itemMap = map['item'] as Map<String, dynamic>;
  return CartItem(
    item: MenuItem(
      id: itemMap['id'] as String ?? '',
      name: itemMap['name'] as String ?? '',
      description: itemMap['description'] as String ?? '',
      price: (itemMap['price'] as num).toDouble(),
      imageUrl: itemMap['image_url'] as String ?? '',
      category: itemMap['category'] as String ?? '',
    ),
    quantity: map['quantity'] as int,
  );
}

  double get totalPrice{
    return item.price * quantity;
  }

  @override
  String toString() {
    return 'CartItem(menuItem: ${item.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}