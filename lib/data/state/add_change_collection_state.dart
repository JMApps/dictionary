import 'package:flutter/cupertino.dart';

class AddChangeCollectionState extends ChangeNotifier {
  AddChangeCollectionState(this._colorIndex);

  late int _colorIndex;

  int get colorIndex => _colorIndex;

  set colorIndex(int index) {
    _colorIndex = index;
    notifyListeners();
  }
}
