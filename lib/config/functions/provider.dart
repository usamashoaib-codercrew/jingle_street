import 'package:flutter/foundation.dart';

class BoolProvider extends ChangeNotifier {
  bool _myBoolean = false;

  bool get myBoolean => _myBoolean;

  set myBoolean(bool value) {
    _myBoolean = value;
    notifyListeners();
  }
}