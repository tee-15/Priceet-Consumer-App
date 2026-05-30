import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String image;
  final String storeName;
  final String distance;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.storeName,
    required this.distance,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? title,
    double? price,
    String? image,
    String? storeName,
    String? distance,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      storeName: storeName ?? this.storeName,
      distance: distance ?? this.distance,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartManager extends ChangeNotifier {
  // Singleton instance
  static final CartManager instance = CartManager._internal();

  CartManager._internal();

  // The actual cart data
  final List<CartItem> _items = [];

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);

  bool get isCartEmpty => _items.isEmpty;

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Group items by store for the UI
  List<Map<String, dynamic>> groupedByStore() {
    final Map<String, List<CartItem>> storeMap = {};
    for (var item in _items) {
      if (!storeMap.containsKey(item.storeName)) {
        storeMap[item.storeName] = [];
      }
      storeMap[item.storeName]!.add(item);
    }

    return storeMap.entries.map((entry) {
      // Find distance from the first item (assuming all items from same store have same distance)
      final distance = entry.value.isNotEmpty ? entry.value.first.distance : '0.0 mi';
      return {
        'storeName': entry.key,
        'distance': distance,
        'items': entry.value,
      };
    }).toList();
  }

  // Modifiers
  void addItem(CartItem newItem) {
    // Check if item already exists in the same store
    final index = _items.indexWhere((item) => item.id == newItem.id && item.storeName == newItem.storeName);

    if (index >= 0) {
      // Increase quantity if it exists
      _items[index].quantity += newItem.quantity;
    } else {
      // Otherwise add it
      _items.add(newItem);
    }
    notifyListeners();
  }

  void updateQuantity(String id, String storeName, int delta) {
    final index = _items.indexWhere((item) => item.id == id && item.storeName == storeName);
    if (index >= 0) {
      final newQuantity = _items[index].quantity + delta;
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String id, String storeName) {
    _items.removeWhere((item) => item.id == id && item.storeName == storeName);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
