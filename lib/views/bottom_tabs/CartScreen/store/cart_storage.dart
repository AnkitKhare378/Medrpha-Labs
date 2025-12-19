import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const _key = 'cart_items';

  /// Load current cart
  static Future<Map<String, int>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, v as int));
  }

  /// Save the whole cart map
  static Future<void> saveCart(Map<String, int> cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(cart));
  }

  /// Increment a product by 1
  static Future<void> addItem(String name) async {
    final cart = await loadCart();
    cart[name] = (cart[name] ?? 0) + 1;
    await saveCart(cart);
  }

  /// Decrement or remove
  static Future<void> removeItem(String name) async {
    final cart = await loadCart();
    final current = (cart[name] ?? 0) - 1;
    if (current <= 0) {
      cart.remove(name);
    } else {
      cart[name] = current;
    }
    await saveCart(cart);
  }
}
