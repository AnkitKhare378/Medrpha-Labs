import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../data/repositories/cart_service/cart_service.dart';
import '../../../../data/repositories/delete_service/delete_service_dart.dart';
import '../../../../models/CartM/get_cart_model.dart';

const String _kCartIdKey = 'cart_id';
const String _kActiveLabIdKey = 'active_lab_id';

class CartItem {
  final String name;
  final String? image;
  final int labId;
  final int qty;
  final double originalPrice;
  final double discountedPrice;
  final int productId;
  final int categoryId;

  CartItem({
    required this.name,
    required this.qty,
    this.image,
    required this.labId,
    required this.originalPrice,
    required this.discountedPrice,
    required this.productId,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'qty': qty,
    'image': image,
    'labId': labId,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'productId': productId,
    'categoryId': categoryId,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    name: map['name'],
    qty: map['qty'],
    image: map['image'],
    labId: map['labId'] as int? ?? 0,
    originalPrice: map['originalPrice'],
    discountedPrice: map['discountedPrice'],
    productId: map['productId'] as int? ?? 0,
    categoryId: map['categoryId'] as int? ?? 0,
  );
}

class CartProvider extends ChangeNotifier {
  int? _activeLabId;
  int? get activeLabId => _activeLabId;

  final Map<String, CartItem> _items = {};
  final Set<int> _loadingProductIds = {};
  int? _apiCartId;

  final CartService _cartService = CartService();
  final DeleteCartService _deleteCartService = DeleteCartService();

  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get apiCartId => _apiCartId ?? 0;



  // ----------------------------------------------------
  // 🛠️ LOADING STATE HELPERS
  // ----------------------------------------------------

  int? get loadingProductId => _loadingProductIds.isNotEmpty ? _loadingProductIds.first : null;

  bool isProductLoading(int productId) => _loadingProductIds.contains(productId);

  void _setLoading(int productId, bool isLoading) {
    if (isLoading) {
      _loadingProductIds.add(productId);
    } else {
      _loadingProductIds.remove(productId);
    }
    notifyListeners();
  }

  Future<void> syncWithApiData(CartData apiCartData) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear OLD user data from local memory and SharedPreferences
    for (final key in _items.keys) {
      await prefs.remove(key);
    }
    _items.clear();

    // 2. Load NEW user data using your existing method
    await setCartDataFromApi(apiCartData);

    // 3. Notify UI to update the bottom bar
    notifyListeners();
  }

  // ----------------------------------------------------
  // ✅ API SYNC: Set Cart Data from API response
  // ----------------------------------------------------
  Future<void> setCartDataFromApi(CartData apiCartData) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear existing local data
    for (final key in _items.keys) {
      await prefs.remove(key);
    }
    _items.clear();
    await _clearActiveLabId();

    // 2. Sync Cart ID
    await _setCartId(apiCartData.cartId);

    // 3. Process items and set policy lock
    if (apiCartData.items.isNotEmpty) {
      final int firstItemLabId = apiCartData.items.first.storeId ?? 0;
      if (firstItemLabId != 0) {
        await _setActiveLabId(firstItemLabId);
      }

      for (final CartItemJson apiItem in apiCartData.items) {
        final int labId = apiItem.storeId ?? 0;
        final String itemName = apiItem.itemName ?? 'Product ${apiItem.productId}';
        final double originalPriceValue = apiItem.price + apiItem.discount;

        int displayQty = apiItem.totalQuantity.toInt();
        if (displayQty <= 0) displayQty = 1;

        final item = CartItem(
          categoryId: apiItem.categoryId,
          name: itemName,
          qty: displayQty,
          labId: labId,
          image: apiItem.image,
          originalPrice: originalPriceValue,
          discountedPrice: apiItem.price,
          productId: apiItem.productId,
        );

        await _persist(item);
      }
    }
    notifyListeners();
  }

  // ----------------------------------------------------
  // ✅ ACTIONS: Add & Remove
  // ----------------------------------------------------
  Future<void> add({
    required int userId,
    required int productId,
    required String name,
    required int categoryId,
    required double originalPrice,
    required double discountedPrice,
    required int labId,
  }) async {
    // Single Lab Policy Check
    if (_items.isNotEmpty && _activeLabId != null && _activeLabId != labId) {
      throw 'LAB_MISMATCH';
    }

    _setLoading(productId, true);

    // String cleanOriginal = originalPrice.replaceAll(RegExp(r'[^\d.]'), '');
    double cleanDiscounted = discountedPrice;

    final double discountedPriceValue = cleanDiscounted ?? 0.0;
    final double originalPriceValue = originalPrice?? 0.0;
    final double discountAmount = originalPriceValue - discountedPriceValue;

    try {
      final response = await _cartService.addToCart(
        userId: userId,
        productId: productId,
        categoryId: categoryId,
        quantity: 1,
        price: discountedPriceValue,
        discount: 0,
      );

      if (response.succeeded) {
        if (response.dataId != null) await _setCartId(response.dataId!);
        if (_items.isEmpty) await _setActiveLabId(labId);

        final existing = _items[name];
        final item = CartItem(
          categoryId: categoryId,
          name: name,
          labId: labId,
          qty: (existing?.qty ?? 0) + 1,
          image: existing?.image,
          originalPrice: originalPrice,
          discountedPrice: discountAmount,
          productId: productId,
        );
        await _persist(item);
      }
    } catch (e) {
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
    required int labId,
  }) async {
    final existing = _items[name];
    if (existing == null || existing.qty <= 0) return;

    _setLoading(productId, true);
    final double discountedPriceValue = existing.discountedPrice ?? 0.0;
    final double originalPriceValue = existing.originalPrice ?? 0.0;

    try {
      final response = await _cartService.addToCart(
        userId: userId,
        categoryId: categoryId,
        productId: productId,
        quantity: -1,
        price: discountedPriceValue,
        // discount: originalPriceValue - discountedPriceValue,
        discount: 0,
      );

      if (response.succeeded) {
        final item = CartItem(
          categoryId: categoryId,
          name: name,
          labId: labId,
          qty: existing.qty - 1,
          image: existing.image,
          originalPrice: existing.originalPrice,
          discountedPrice: existing.discountedPrice,
          productId: existing.productId,
        );
        await _persist(item);
        if (item.qty <= 0 && totalCount <= 0) {
          await clearCartAfterOrder(); // Trigger full deletion if last item removed
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(productId, false);
    }
  }

  // ----------------------------------------------------
  // ✅ PERSISTENCE & POLICY HELPERS
  // ----------------------------------------------------
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

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _items.clear();
    for (final key in prefs.getKeys()) {
      if (key == _kCartIdKey || key == _kActiveLabIdKey) continue;
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        try {
          _items[key] = CartItem.fromMap(jsonDecode(jsonString));
        } catch (e) {
          await prefs.remove(key);
        }
      }
    }
    _apiCartId = prefs.getInt(_kCartIdKey);
    _activeLabId = prefs.getInt(_kActiveLabIdKey);
    notifyListeners();
  }

  Future<void> _setActiveLabId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kActiveLabIdKey, id);
    _activeLabId = id;
  }

  Future<void> _clearActiveLabId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kActiveLabIdKey);
    _activeLabId = null;
  }

  Future<void> clearAndAdd({
    required int userId,
    required int productId,
    required String name,
    required int categoryId,
    required double originalPrice,
    required double discountedPrice,
    required int labId,
  }) async {
    await clearCartAfterOrder();
    return add(
      userId: userId,
      productId: productId,
      name: name,
      categoryId: categoryId,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      labId: labId,
    );
  }

  // 🔥 UPDATED: Now calls the DeleteCartService API
  Future<void> clearCartAfterOrder() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. API CALL: Delete from server if ID exists
    if (_apiCartId != null && _apiCartId! > 0) {
      try {
        await _deleteCartService.deleteCart(_apiCartId!);
        debugPrint("📡 Server: Cart cleared successfully.");
      } catch (e) {
        debugPrint("❌ Server: Failed to clear cart: $e");
      }
    }

    // 2. LOCAL CLEAR: Memory & Prefs
    for (final key in _items.keys) {
      await prefs.remove(key);
    }
    _items.clear();

    await _clearCartId();
    await _clearActiveLabId();

    notifyListeners();
  }

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

  void add1(
      String name,
      int labId,
      double originalPrice,
      double discountedPrice,
      int categoryId,
      ) {
    // String cleanOriginal = originalPrice.replaceAll(RegExp(r'[^\d.]'), '');
    final existing = _items[name];
    final newQty = (existing?.qty ?? 0) + 1;
    final item = CartItem(
      categoryId: categoryId,
      name: name,
      labId: labId,
      qty: newQty,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      productId: 2,
    );
    _persist(item);
  }

  Future<void> clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Clear items from SharedPreferences
    // We iterate through current items and remove them by name
    for (final key in _items.keys) {
      await prefs.remove(key);
    }

    // 2. Clear known metadata keys
    await prefs.remove(_kCartIdKey);
    await prefs.remove(_kActiveLabIdKey);

    // 3. Clear local memory variables
    _items.clear();
    _apiCartId = null;
    _activeLabId = null;
    _loadingProductIds.clear();

    // 4. Update UI
    notifyListeners();
    debugPrint("🧹 CartProvider: Local data cleared for logout.");
  }

  void remove1(String name, int labId) {
    final existing = _items[name];
    if (existing == null) return;
    final newQty = existing.qty - 1;
    final updated = CartItem(
      categoryId: 1,
      name: name,
      labId: labId,
      qty: newQty,
      originalPrice: existing.originalPrice,
      discountedPrice: existing.discountedPrice,
      productId: 2,
    );
    _persist(updated);
  }

  // ----------------------------------------------------
  // ✅ UI GETTERS
  // ----------------------------------------------------
  int get totalCount => _items.values.fold(0, (sum, item) => sum + item.qty);

  // The sum of all item's discounted prices
  double get totalAmount => _items.values.fold(0.0, (sum, item) =>
  sum + (item.discountedPrice ?? 0.0) * item.qty);

  // The sum of all item's original (MRTP) prices
  double get totalOriginalPrice => _items.values.fold(0.0, (sum, item) =>
  sum + (item.originalPrice ?? 0.0) * item.qty);

  // The total saving from item discounts
  double get totalDiscount => _items.values.fold(0.0, (sum, item) {
    final original = item.originalPrice ?? 0.0;
    final discounted = item.discountedPrice ?? 0.0;
    return sum + (original - discounted) * item.qty;
  });

  // Total payable including fixed taxes/charges
  // Note: Coupon deduction is handled in the UI Layer (MyCartPage)
  double get totalPayable => totalAmount + 40.0 + 10.0;

  int qty(String name) => _items[name]?.qty ?? 0;
}