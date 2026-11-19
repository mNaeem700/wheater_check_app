import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../domain/auth_model.dart';

enum AuthMode { signIn, signUp }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  AuthMode _mode = AuthMode.signIn;
  AuthSession? _session;
  String? _errorMessage;
  String? _infoMessage;
  bool _isLoading = false;

  AuthMode get mode => _mode;
  AuthSession? get session => _session;
  String? get errorMessage => _errorMessage;
  String? get infoMessage => _infoMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _session != null;

  void setMode(AuthMode mode) {
    _mode = mode;
    _errorMessage = null;
    _infoMessage = null;
    notifyListeners();
  }

  Future<bool> submit({required String email, required String password}) async {
    _clearMessages();
    if (!_isValidEmail(email)) {
      _errorMessage = 'Enter a valid email address.';
      notifyListeners();
      return false;
    }
    if (password.length < 8) {
      _errorMessage = 'Password must be at least 8 characters.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _session = _mode == AuthMode.signIn
          ? await _repository.signIn(email: email, password: password)
          : await _repository.signUp(email: email, password: password);
      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    _clearMessages();
    if (!_isValidEmail(email)) {
      _errorMessage = 'Enter a valid email address.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      await _repository.requestPasswordReset(email);
      _infoMessage = 'If the account exists, a reset email will be sent.';
      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _session = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _infoMessage = null;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }
}
