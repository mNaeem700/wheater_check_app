import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isLoading = false;
    notifyListeners();
  }
}
