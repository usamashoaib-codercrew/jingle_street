import 'package:flutter/foundation.dart';

class CartCounter extends ChangeNotifier {
  int itemCount = 0;

  void increment() {
    itemCount++;
    notifyListeners();
  }

  void decrement() {
    if (itemCount > 0) {
      itemCount--;
      notifyListeners();
    }
  }
}
