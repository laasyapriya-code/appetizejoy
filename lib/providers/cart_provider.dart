
import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String description;
  final int price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  CartProvider._();

  static final CartProvider instance = CartProvider._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalPrice {
    return _items.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void addItem({
    required String name,
    required String description,
    required String price,
    required String image,
    int quantity = 1,
  }) {
    final numericPrice =
    int.parse(price.replaceAll('₹', '').trim());

    final existingIndex =
    _items.indexWhere((item) => item.name == name);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          name: name,
          description: description,
          price: numericPrice,
          image: image,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
