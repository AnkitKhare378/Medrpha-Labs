// file: lib/data/providers/cart_provider.dart (or where your CartProvider is located)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../data/repositories/cart_service/cart_service.dart'; // Adjust path if necessary
import '../../../../models/CartM/get_cart_model.dart';

const String _kCartIdKey = 'cart_id';

class CartItem {
  final String name;
  final int qty;
  final String originalPrice;
  final String discountedPrice;
  final int productId;
  final int categoryId;

  CartItem({
    required this.name,
    required this.qty,
    required this.originalPrice,
    required this.discountedPrice,
    required this.productId,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'qty': qty,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'productId': productId,
    'categoryId': categoryId, // Ensure categoryId is also saved locally
  };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    categoryId: map['categoryId'] as int? ?? 0,
    name: map['name'],
    qty: map['qty'],
    originalPrice: map['originalPrice'],
    discountedPrice: map['discountedPrice'],
    productId: map['productId'] as int? ?? 0,
  );
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final Set<int> _loadingProductIds = {};
  int? _apiCartId;
  int? _loadingProductId;
  int? get loadingProductId => _loadingProductId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isProductLoading(int productId) =>
      _loadingProductIds.contains(productId);

  void _setLoading(int productId, bool isLoading) {
    if (isLoading) {
      _loadingProductIds.add(productId);
    } else {
      _loadingProductIds.remove(productId);
    }
    notifyListeners();
  }

  final CartService _cartService = CartService();

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  // 🎯 Getter for the stored cart ID
  int get apiCartId => _apiCartId ?? 0;

  // ----------------------------------------------------
  // ✅ NEW METHOD: Set Cart Data from API response
  // ----------------------------------------------------

  /// Synchronizes the local CartProvider state with the data fetched from the API.
  Future<void> setCartDataFromApi(CartData apiCartData) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear existing items ONLY from local storage
    // Use the existing keys in the map to identify and remove only cart items.
    for (final key in _items.keys) {
      await prefs.remove(key);
    }
    _items.clear(); // Clear the in-memory map

    // 2. Set the Cart ID from the API response
    await _setCartId(apiCartData.cartId);

    // 3. Process and persist new items from the API
    for (final CartItemJson apiItem in apiCartData.items) {
      final String itemName =
          apiItem.itemName ?? 'Product ${apiItem.productId}';

      final double originalPriceValue = apiItem.price + apiItem.discount;

      final item = CartItem(
        categoryId: apiItem.categoryId,
        name: itemName,
        qty: apiItem.totalQuantity.toInt(),
        originalPrice: originalPriceValue.toStringAsFixed(2),
        discountedPrice: apiItem.price.toStringAsFixed(2),
        productId: apiItem.productId,
      );

      // Persist and update the in-memory map
      if (item.qty > 0) {
        await _persist(item);
      }
      print('Synchronized item: $itemName, Qty: ${item.qty}');
    }

    // Ensure listeners are notified even if cart was empty but ID was set
    notifyListeners();
  }

  // 🚀 Public method to clear cart and cart ID after a successful order
  Future<void> clearCartAfterOrder() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear all items from local storage
    for (final itemKey in _items.keys) {
      await prefs.remove(itemKey);
    }
    _items.clear(); // Clear the in-memory map

    // 2. Clear the API-provided Cart ID
    await _clearCartId(); // Call the private helper

    notifyListeners(); // Notify listeners (UI will update to show empty cart)
  }

  Future<void> add({
    required int userId,
    required int productId,
    required String name,
    required int categoryId,
    required String originalPrice,
    required String discountedPrice,
  }) async {
    _setLoading(productId, true);

    String cleanOriginal = originalPrice.replaceAll(RegExp(r'[^\d.]'), '');
    String cleanDiscounted = discountedPrice.replaceAll(RegExp(r'[^\d.]'), '');

    final double originalPriceValue = double.tryParse(cleanOriginal) ?? 0.0;
    final double discountedPriceValue = double.tryParse(cleanDiscounted) ?? 0.0;
    final double discountAmount = originalPriceValue - discountedPriceValue;

    final existing = _items[name];
    final int newQuantityForAPI = 1;

    try {
      final response = await _cartService.addToCart(
        userId: userId,
        productId: productId,
        categoryId: categoryId,
        quantity: newQuantityForAPI,
        price: discountedPriceValue,
        discount: discountAmount,
      );

      if (!response.succeeded) {
        throw Exception(response.message);
      }

      // 🎯 Save the cart ID if provided in the response data
      if (response.dataId != null && response.dataId! > 0) {
        await _setCartId(response.dataId!);
      }

      final newQty = (existing?.qty ?? 0) + 1;

      final item = CartItem(
        categoryId: categoryId,
        name: name,
        qty: newQty,
        originalPrice: cleanOriginal,
        discountedPrice: cleanDiscounted,
        productId: productId,
      );

      await _persist(item);

      print('Item added successfully: ${response.message}');
    } catch (e) {
      print("Failed to add to cart via API: $e");
      rethrow;
    } finally {
      _setLoading(productId, false);
    }
  }

  Future<void> remove({
    required int userId,
    required int productId,
    required String name,
    required int categoryId,
  }) async {
    final existing = _items[name];
    if (existing == null || existing.qty <= 0) return;

    _setLoading(productId, true);

    final double originalPriceValue =
        double.tryParse(existing.originalPrice) ?? 0.0;
    final double discountedPriceValue =
        double.tryParse(existing.discountedPrice) ?? 0.0;
    final double discountAmount = originalPriceValue - discountedPriceValue;

    final int newQuantityForAPI = -1;

    try {
      final response = await _cartService.addToCart(
        userId: userId,
        categoryId: categoryId,
        productId: productId,
        quantity: newQuantityForAPI,
        price: discountedPriceValue,
        discount: discountAmount,
      );

      if (!response.succeeded) {
        throw Exception(response.message);
      }

      final newQty = existing.qty - 1;

      final updated = CartItem(
        categoryId: categoryId,
        name: name,
        qty: newQty,
        originalPrice: existing.originalPrice,
        discountedPrice: existing.discountedPrice,
        productId: existing.productId,
      );

      await _persist(updated);

      // Clear cart ID if this was the last item
      if (newQty <= 0 && totalCount <= 1) {
        await _clearCartId();
      }

      print("Item removed successfully: ${response.message}");
    } catch (e) {
      print("Failed to remove from cart via API: $e");
      rethrow;
    } finally {
      _setLoading(productId, false);
    }
  }

  // --- Cart ID Persistence Helpers ---

  Future<void> _setCartId(int cartId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kCartIdKey, cartId);
    _apiCartId = cartId;
  }

  Future<void> _clearCartId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCartIdKey);
    _apiCartId = null;
  }

  // ---------------------------------

  void add1(
    String name,
    String originalPrice,
    String discountedPrice,
    int categoryId,
  ) {
    String cleanOriginal = originalPrice.replaceAll(RegExp(r'[^\d.]'), '');
    String cleanDiscounted = discountedPrice.replaceAll(RegExp(r'[^\d.]'), '');

    final existing = _items[name];
    final newQty = (existing?.qty ?? 0) + 1;

    final item = CartItem(
      categoryId: categoryId,
      name: name,
      qty: newQty,
      originalPrice: cleanOriginal,
      discountedPrice: cleanDiscounted,
      productId: 2,
    );

    _persist(item);
  }

  void remove1(String name) {
    final existing = _items[name];
    if (existing == null) return;

    final newQty = existing.qty - 1;
    final updated = CartItem(
      categoryId: 1,
      name: name,
      qty: newQty,
      originalPrice: existing.originalPrice,
      discountedPrice: existing.discountedPrice,
      productId: 2,
    );

    _persist(updated);
  }

  int get totalCount => _items.values.isEmpty
      ? 0
      : _items.values.map((e) => e.qty).reduce((a, b) => a + b);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _items.clear();

    // Load persisted items
    for (final key in prefs.getKeys()) {
      if (key == _kCartIdKey) {
        continue; // Skip the cart ID key
      }
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final map = jsonDecode(jsonString);
        _items[key] = CartItem.fromMap(map);
      }
    }

    // Load cart ID
    _apiCartId = prefs.getInt(_kCartIdKey);

    notifyListeners();
  }

  Future<void> _persist(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();

    if (item.qty <= 0) {
      await prefs.remove(item.name);
      _items.remove(item.name);
    } else {
      await prefs.setString(item.name, jsonEncode(item.toMap()));
      _items[item.name] = item;
    }
    notifyListeners();
  }

  double get totalPayable {
    double mrpTotal = 0;
    double discountedTotal = 0;

    for (final item in _items.values) {
      final original = double.tryParse(item.originalPrice) ?? 0;
      final discounted = double.tryParse(item.discountedPrice) ?? 0;
      mrpTotal += original * item.qty;
      discountedTotal += discounted * item.qty;
    }

    const deliveryFee = 40.0;
    const platformFee = 10.0;

    return discountedTotal + deliveryFee + platformFee;
  }

  int qty(String name) => _items[name]?.qty ?? 0;
}
