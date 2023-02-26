import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RCartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<String> _items = [];
  /// The current total price of all items (assuming all items cost $42).

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

}