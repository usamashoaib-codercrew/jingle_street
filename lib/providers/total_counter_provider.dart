import 'package:flutter/foundation.dart';

class TotalCounterProvider extends ChangeNotifier {
  int _totalCount = 0;

  int get totalCount => _totalCount;

  void updateTotalCount(int newTotalCount) {
    Future.delayed(Duration.zero, () {
      _totalCount = newTotalCount;
      notifyListeners();
    });
  }
}
