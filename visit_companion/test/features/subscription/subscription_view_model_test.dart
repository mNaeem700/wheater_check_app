import 'package:flutter_test/flutter_test.dart';
import 'package:visit_companion/features/subscription/data/subscription_repository.dart';
import 'package:visit_companion/features/subscription/domain/subscription_model.dart';
import 'package:visit_companion/features/subscription/presentation/subscription_view_model.dart';

void main() {
  test('free plan enforces monthly creation limits', () async {
    final viewModel = SubscriptionViewModel(InMemorySubscriptionRepository());
    await viewModel.load();

    expect(viewModel.canCreateVisitSummary(), isTrue);
    await viewModel.recordVisitSummary();
    await viewModel.recordVisitSummary();
    expect(viewModel.canCreateVisitSummary(), isFalse);

    expect(viewModel.canExplainDocument(), isTrue);
  });

  test('plus plan grants unlimited visit and document creation', () async {
    final viewModel = SubscriptionViewModel(InMemorySubscriptionRepository());
    await viewModel.selectPlan(SubscriptionPlan.plus);

    for (var i = 0; i < 10; i++) {
      await viewModel.recordVisitSummary();
      await viewModel.recordDocumentExplanation();
    }

    expect(viewModel.canCreateVisitSummary(), isTrue);
    expect(viewModel.canExplainDocument(), isTrue);
  });

  test('downgrade preserves profile and data creation state', () async {
    final viewModel = SubscriptionViewModel(InMemorySubscriptionRepository());
    await viewModel.selectPlan(SubscriptionPlan.family);
    await viewModel.recordProfile();
    await viewModel.selectPlan(SubscriptionPlan.free);

    expect(viewModel.subscription.plan, SubscriptionPlan.free);
    expect(viewModel.usage.profiles, 2);
  });
}
