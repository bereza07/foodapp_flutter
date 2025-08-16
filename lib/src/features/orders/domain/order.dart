import 'package:foodapp/src/features/cart/domain/cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String status; // pending, accepted, completed
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}