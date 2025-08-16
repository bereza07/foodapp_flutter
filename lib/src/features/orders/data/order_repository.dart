
import 'package:foodapp/src/features/cart/domain/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final _client = Supabase.instance.client;

  Future<void> createOrder(List<CartItem> items, double total) async {
    await _client.from('orders').insert({
      'items': items.map((e) => e.toMap()).toList(),
      'total_price': total,
      'status': 'pending',
    });
  }
}