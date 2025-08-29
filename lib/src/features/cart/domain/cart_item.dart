import 'package:foodapp/src/features/menu/domain/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;
  final List<OptionItem> selectedOptions; // выбранные опции

  CartItem({
    required this.item,
    required this.quantity,
    this.selectedOptions = const [],
  });

  // копия с изменением количества
  CartItem copyWith({int? quantity, List<OptionItem>? selectedOptions}) {
    return CartItem(
      item: item,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  // преобразование в Map для отправки в базу
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
      'selected_options': selectedOptions.map((o) => {
            'id': o.id,
            'name': o.name,
            'additional_price': o.additionalPrice,
          }).toList(),
    };
  }

  // восстановление из Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    final itemMap = map['item'] as Map<String, dynamic>;
    final optionsMap = map['selected_options'] as List<dynamic>? ?? [];

    return CartItem(
      item: MenuItem(
        id: itemMap['id']?.toString() ?? '',
        name: itemMap['name']?.toString() ?? '',
        description: itemMap['description']?.toString() ?? '',
        price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: itemMap['image_url']?.toString() ?? '',
        category: itemMap['category']?.toString() ?? '',
        optionGroups: [], // реальные группы опций можно загружать отдельно
      ),
      quantity: (map['quantity'] as int?) ?? 1,
      selectedOptions: optionsMap.map((o) => OptionItem.fromMap(o)).toList(),
    );
  }

  // сумма с учётом количества, без опций
  double get totalPrice {
    final optionsPrice = selectedOptions.fold<double>(
        0, (sum, option) => sum + option.additionalPrice);
    return (item.price + optionsPrice) * quantity;
  }

  @override
  String toString() {
    return 'CartItem(menuItem: ${item.name}, quantity: $quantity, totalPrice: $totalPrice, selectedOptions: $selectedOptions)';
  }
}
