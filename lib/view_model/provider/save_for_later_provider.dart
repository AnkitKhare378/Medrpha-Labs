import 'package:flutter/material.dart';

import '../../views/bottom_tabs/CartScreen/store/cart_notifier.dart';

class SaveForLaterProvider extends ChangeNotifier {
  // FIX 1: Change Map key type from String to int (the product ID)
  final Map<int, SavedItem> _items = {};

  final CartProvider _cartProvider;

  SaveForLaterProvider(this._cartProvider);

  List<SavedItem> get savedItems => _items.values.toList();

  bool isSaved(int id) {
    return _items.containsKey(id);
  }

  void addItem({
    required int id,
    required String name,
    required double originalPrice,
    required double discountedPrice,
    String? imageUrl,
  }) {
    // FIX 2: Check map for existence using the int id
    if (_items.containsKey(id)) return;

    // String cleanOriginal = originalPrice.replaceAll(RegExp(r'[^\d.]'), '');

    final newItem = SavedItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
    );

    // FIX 3: Use the int 'id' as the key
    _items[id] = newItem;
    notifyListeners();
  }

  /// Removes an item by ID.
  void removeItem(int id) {
    // FIX 4: Correctly remove item using the int id
    _items.remove(id);
    notifyListeners();
  }

  /// Removes item from "Saved" list, typically before adding to Cart.
  void moveToCart(String name) {
    // Find the item first since the Map is keyed by ID, not name.
    final item = _items.values.firstWhere(
          (i) => i.name == name,
      orElse: () => throw Exception('Item not found for move to cart'), // Handle case where item might not be found
    );

    if (item != null) {
      // FIX 5: Remove the item using its ID
      _items.remove(item.id);
      _cartProvider.add1(item.name, 1, item.originalPrice, item.discountedPrice, 1);
      notifyListeners();
    }
  }

  /// Clears the entire list.
  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}

class SavedItem {
  final int id;
  final String name;
  final String? imageUrl;
  final double originalPrice;
  final double discountedPrice;

  SavedItem({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'imageUrl': imageUrl,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
  };

  factory SavedItem.fromMap(Map<String, dynamic> map) => SavedItem(
    id: map['id'],
    name: map['name'],
    imageUrl: map['imageUrl'],
    originalPrice: map['originalPrice'],
    discountedPrice: map['discountedPrice'],
  );
}