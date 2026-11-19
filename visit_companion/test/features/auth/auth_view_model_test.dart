import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/auth/data/auth_repository.dart';
import 'package:visit_companion/features/auth/presentation/auth_view_model.dart';

void main() {
  test('sign up and sign in use email/password only', () async {
    final viewModel = AuthViewModel(InMemoryAuthRepository());

    expect(
      await viewModel.submit(
        email: 'person@example.com',
        password: 'strong-pass',
      ),
      isFalse,
    );

    viewModel.setMode(AuthMode.signUp);
    expect(
      await viewModel.submit(
        email: 'person@example.com',
        password: 'strong-pass',
      ),
      isTrue,
    );
    expect(viewModel.isAuthenticated, isTrue);
    expect(viewModel.session?.user.email, 'person@example.com');
  });

  test('invalid credentials return an explicit error', () async {
    final repository = InMemoryAuthRepository();
    final viewModel = AuthViewModel(repository);
    viewModel.setMode(AuthMode.signUp);
    await viewModel.submit(
      email: 'person@example.com',
      password: 'strong-pass',
    );

    await viewModel.signOut();
    viewModel.setMode(AuthMode.signIn);
    final success = await viewModel.submit(
      email: 'person@example.com',
      password: 'wrong-pass',
    );

    expect(success, isFalse);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('password reset validates email without OTP flow', () async {
    final viewModel = AuthViewModel(InMemoryAuthRepository());

    expect(await viewModel.requestPasswordReset('bad-email'), isFalse);
    expect(await viewModel.requestPasswordReset('person@example.com'), isTrue);
    expect(viewModel.infoMessage, contains('reset email'));
  });
}
