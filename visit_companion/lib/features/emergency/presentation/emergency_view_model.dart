import 'package:flutter/foundation.dart';

class EmergencyViewModel extends ChangeNotifier {
  bool _cardEnabled = false;

  bool get cardEnabled => _cardEnabled;

  void setCardEnabled(bool value) {
    _cardEnabled = value;
    notifyListeners();
  }
}
