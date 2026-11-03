enum ItemCategory { top, bottom, weapon, pet, background }

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.asset,
  });

  final String id;
  final String name;
  final ItemCategory category;
  final int price;
  final String asset;

  factory Item.fromJson(Map<String, Object?> json) {
    return Item(
      id: json['id']! as String,
      name: json['name']! as String,
      category: ItemCategory.values.byName(json['category']! as String),
      price: (json['price']! as num).toInt(),
      asset: json['asset']! as String,
    );
  }
}
