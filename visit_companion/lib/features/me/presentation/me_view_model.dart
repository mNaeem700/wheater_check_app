import 'package:flutter/foundation.dart';

class MeViewModel extends ChangeNotifier {
  String _locale = 'en';

  String get locale => _locale;

  void setLocale(String value) {
    _locale = value;
    notifyListeners();
  }
}
