import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final List<String> categories = [
    'All',
    'Karahi & Handi',
    'BBQ Specialties',
    'Biryani & Rice',
    'Fast Food',
    'Beverages',
    'Desserts',
  ];

  final List<MenuItemModel> _menuItems = [
    const MenuItemModel(
      id: 'm1',
      category: 'Karahi & Handi',
      name: 'Chicken Karahi (Full)',
      price: 2600.0,
      description: 'Traditional Desi chicken cooked in fresh tomatoes, green chilies, ginger & aromatic spices.',
      preparationTimeMinutes: 25,
      iconEmoji: '🍗',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm2',
      category: 'Karahi & Handi',
      name: 'Mutton White Handi',
      price: 3400.0,
      description: 'Tender mutton simmered in creamy yogurt, black pepper and mild aromatic white gravy.',
      preparationTimeMinutes: 30,
      iconEmoji: '🍲',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm3',
      category: 'BBQ Specialties',
      name: 'Chicken Malai Boti',
      price: 1250.0,
      description: 'Boneless tender chicken skewers marinated in fresh clotted cream, green herbs, and mild spices.',
      preparationTimeMinutes: 20,
      iconEmoji: '🍢',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm4',
      category: 'BBQ Specialties',
      name: 'Special BBQ Platter',
      price: 3600.0,
      description: 'Assortment of Seekh Kabab, Malai Boti, Reshmi Kabab & Chicken Tikka served with mint raita.',
      preparationTimeMinutes: 25,
      iconEmoji: '🔥',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm5',
      category: 'Biryani & Rice',
      name: 'Special Dum Biryani',
      price: 950.0,
      description: 'Fragrant basmati rice layered with spiced chicken, caramelized onions and saffron milk.',
      preparationTimeMinutes: 15,
      iconEmoji: '🍚',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm6',
      category: 'Fast Food',
      name: 'Saffron Supreme Pizza (L)',
      price: 2100.0,
      description: 'Hand-tossed crust with spicy tikka chunks, jalapenos, mushrooms, capsicum and mozzarella.',
      preparationTimeMinutes: 20,
      iconEmoji: '🍕',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm7',
      category: 'Fast Food',
      name: 'Creamy Alfredo Pasta',
      price: 1350.0,
      description: 'Fettuccine pasta tossed in rich parmesan garlic cream sauce with grilled chicken breast.',
      preparationTimeMinutes: 18,
      iconEmoji: '🍝',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm8',
      category: 'Fast Food',
      name: 'Hot & Sour Soup',
      price: 430.0,
      description: 'Classic tangy broth loaded with shredded chicken, eggs and seasonal vegetables.',
      preparationTimeMinutes: 12,
      iconEmoji: '🥣',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm9',
      category: 'Beverages',
      name: 'Mint Margarita',
      price: 380.0,
      description: 'Fresh mint leaves crushed with lemon juice, black salt and chilled soda.',
      preparationTimeMinutes: 5,
      iconEmoji: '🍹',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm10',
      category: 'Beverages',
      name: 'Soft Drink (Can 330ml)',
      price: 150.0,
      description: 'Chilled Coke, Sprite, or Fanta can.',
      preparationTimeMinutes: 2,
      iconEmoji: '🥤',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm11',
      category: 'Desserts',
      name: 'Saffron Shahi Kheer',
      price: 450.0,
      description: 'Slow-cooked milk pudding infused with saffron strands, pistachios and silver leaf.',
      preparationTimeMinutes: 5,
      iconEmoji: '🍨',
      isAvailable: true,
    ),
    const MenuItemModel(
      id: 'm12',
      category: 'Desserts',
      name: 'Hot Gulab Jamun (2 pcs)',
      price: 320.0,
      description: 'Warm cottage cheese dumplings soaked in rose-flavored cardamom sugar syrup.',
      preparationTimeMinutes: 5,
      iconEmoji: '🍯',
      isAvailable: true,
    ),
  ];

  List<MenuItemModel> get allItems => List.unmodifiable(_menuItems);

  List<MenuItemModel> get filteredItems {
    return _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleAvailability(String id) {
    final index = _menuItems.indexWhere((m) => m.id == id);
    if (index != -1) {
      final current = _menuItems[index];
      _menuItems[index] = current.copyWith(isAvailable: !current.isAvailable);
      notifyListeners();
    }
  }

  void addMenuItem(MenuItemModel item) {
    _menuItems.add(item);
    notifyListeners();
  }

  void updateMenuItem(MenuItemModel updatedItem) {
    final index = _menuItems.indexWhere((m) => m.id == updatedItem.id);
    if (index != -1) {
      _menuItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteMenuItem(String id) {
    _menuItems.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}

