

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<OptionGroup> optionGroups; 

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.optionGroups,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) { // ! Мб здесь теряет информацию о option Groups
    return MenuItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      category: map['category'],
      imageUrl: map['image_url'],
      optionGroups: (map['option_groups'] as List<dynamic>?)
              ?.map((e) => OptionGroup.fromMap(e))
              .toList() ??
          [],
    );
  }
}


class OptionItem {
  final String id;
  final String name;
  final double additionalPrice;

  OptionItem({required this.id, required this.name, required this.additionalPrice});

  factory OptionItem.fromMap(Map<String, dynamic> map) {
    return OptionItem(
      id: map['id'],
      name: map['name'],
      additionalPrice: (map['additional_price'] as num).toDouble(),
    );
  }
}

class OptionGroup {
  final String id;
  final String name;
  final bool singleChoice; // true = выбрать 1 вариант, false = несколько
  final List<OptionItem> items;

  OptionGroup({
    required this.id,
    required this.name,
    required this.singleChoice,
    required this.items,
  });

  factory OptionGroup.fromMap(Map<String, dynamic> map) {
    return OptionGroup(
      id: map['id'],
      name: map['name'],
      singleChoice: map['single_choice'] as bool,
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromMap(e))
              .toList() ??
          [],
    );
  }
}