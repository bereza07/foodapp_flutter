

class MenuItem{
  final String id, name , description, imageUrl, category;
  final double price;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map){
    return MenuItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] as String? ?? '',
      category: map['category'] as String? ?? '',
    );
  }
}