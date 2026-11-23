class MenuItemModel {
  final String id;
  final String category;
  final String name;
  final double price;
  final String description;
  final bool isAvailable;
  final int preparationTimeMinutes;
  final String iconEmoji;

  const MenuItemModel({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.description,
    this.isAvailable = true,
    this.preparationTimeMinutes = 15,
    this.iconEmoji = '🍲',
  });

  MenuItemModel copyWith({
    String? id,
    String? category,
    String? name,
    double? price,
    String? description,
    bool? isAvailable,
    int? preparationTimeMinutes,
    String? iconEmoji,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      iconEmoji: iconEmoji ?? this.iconEmoji,
    );
  }
}

