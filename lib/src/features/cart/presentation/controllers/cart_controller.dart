

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/domain/cart_item.dart';
import 'package:foodapp/src/features/menu/domain/menu_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>>{
  CartNotifier() : super([]);

  void addToCart(MenuItem item) {
  final index = state.indexWhere((e) => e.item.id == item.id);

  if (index == -1) {
    state = [...state, CartItem(item: item, quantity: 1)];
  } else {
    final updatedItem =
        state[index].copyWith(state[index].quantity + 1);

    state = [
      for (int i = 0; i < state.length; i++)
        index == i ? updatedItem : state[i],
    ];
  }
}



  void removeItem(MenuItem item){
    final index = state.indexWhere((e) => e.item.id == item.id);
    if (index != -1){
      final current = state[index];
      if (current.quantity >1){
        final updatedItem = current.copyWith(current.quantity -1);
        state = [
          for (int i = 0; i < state.length; i++)
            index == i ? updatedItem : state[i], 
        ];
      }
      else{
        state = state.where((e) => e.item.id != item.id).toList();
      }
    }
  }

  void clearCart(){
    state = [];
  }

  double get totalPrice{
    return state.fold(0, (sum, cartitem) => sum + cartitem.totalPrice);
  }


}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);