import 'package:flutter/cupertino.dart';

class CardModeState extends ChangeNotifier {
  bool _cardMode = true;

  bool get cardMode => _cardMode;

  set cardMode(bool value) {
    _cardMode = value;
    notifyListeners();
  }
}
