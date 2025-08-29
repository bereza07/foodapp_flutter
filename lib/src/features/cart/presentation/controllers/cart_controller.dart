import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/domain/cart_item.dart';
import 'package:foodapp/src/features/menu/domain/menu_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // добавление товара с выбранными опциями
  void addToCart(MenuItem item, {List<OptionItem> selectedOptions = const []}) {
    // ищем товар с такими же опциями
    final index = state.indexWhere((e) =>
        e.item.id == item.id &&
        _compareOptions(e.selectedOptions, selectedOptions));

    if (index == -1) {
      state = [...state, CartItem(item: item, quantity: 1, selectedOptions: selectedOptions)];
    } else {
      final updatedItem = state[index].copyWith(quantity: state[index].quantity + 1);
      state = [
        for (int i = 0; i < state.length; i++)
          index == i ? updatedItem : state[i],
      ];
    }
  }

  void removeItem(CartItem cartItem) {
    final index = state.indexWhere((e) =>
        e.item.id == cartItem.item.id &&
        _compareOptions(e.selectedOptions, cartItem.selectedOptions));

    if (index != -1) {
      final current = state[index];
      if (current.quantity > 1) {
        final updatedItem = current.copyWith(quantity: current.quantity - 1);
        state = [
          for (int i = 0; i < state.length; i++)
            index == i ? updatedItem : state[i],
        ];
      } else {
        state = state.where((e) =>
            e.item.id != cartItem.item.id ||
            !_compareOptions(e.selectedOptions, cartItem.selectedOptions)).toList();
      }
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0, (sum, cartItem) => sum + cartItem.totalPrice);
  }

  // приватный метод для сравнения выбранных опций
  bool _compareOptions(List<OptionItem> a, List<OptionItem> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
