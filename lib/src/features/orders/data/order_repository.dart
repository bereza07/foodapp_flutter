
import 'package:foodapp/src/features/cart/domain/cart_item.dart';
import 'package:foodapp/src/features/orders/domain/order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final _client = Supabase.instance.client;

  Future<void> createOrder(List<CartItem> items, double total) async {
    final user = _client.auth.currentUser;
    if (user == null){
      throw Exception('Пользователь не авторизован');
    }

    await _client.from('orders').insert({
      'items': items.map((e) => e.toMap()).toList(),
      'user_id': user.id,
      'total_price': total,
      'status': 'pending',
    });
  }

  Future<List<Order>> getUserOrders(String userId) async{
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    print(response);
    return (response as List)
        .map((e) => Order.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}