import '../domain/auth_model.dart';

abstract interface class AuthRepository {
  Future<AuthSession> signUp({required String email, required String password});

  Future<AuthSession> signIn({required String email, required String password});

  Future<void> requestPasswordReset(String email);

  Future<void> signOut();
}

class InMemoryAuthRepository implements AuthRepository {
  final Map<String, String> _accounts = {};
  AuthSession? _session;

  AuthSession? get currentSession => _session;

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw const AuthException('An account already exists for this email.');
    }

    _accounts[normalizedEmail] = password;
    return _createSession(normalizedEmail);
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts[normalizedEmail] != password) {
      throw const AuthException('Email or password is incorrect.');
    }

    return _createSession(normalizedEmail);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    if (email.trim().isEmpty) {
      throw const AuthException('Enter your email address.');
    }
  }

  @override
  Future<void> signOut() async {
    _session = null;
  }

  AuthSession _createSession(String email) {
    _session = AuthSession(
      user: AuthUser(id: email.hashCode.toString(), email: email),
      accessToken: 'local-session-$email',
    );
    return _session!;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
