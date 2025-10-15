import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/strings/app_constraints.dart';

class WordExactMatchState extends ChangeNotifier {
  final Box _mainSettingsBox = Hive.box(AppConstraints.keyMainAppSettingsBox);

  WordExactMatchState() {
    _exactMatch = _mainSettingsBox.get(AppConstraints.keyExactMatchValue, defaultValue: true);
  }

  late bool _exactMatch;

  bool get exactMatch => _exactMatch;

  set exactMatch(bool value) {
    _exactMatch = value;
    _mainSettingsBox.put(AppConstraints.keyExactMatchValue, value);
    notifyListeners();
  }
}
