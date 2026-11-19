import '../domain/subscription_model.dart';

abstract interface class SubscriptionRepository {
  Future<SubscriptionModel> loadSubscription();

  Future<UsageCounterModel> loadUsage();

  Future<void> saveUsage(UsageCounterModel usage);

  Future<void> restorePurchases();

  Future<void> setPlan(SubscriptionPlan plan);
}

class InMemorySubscriptionRepository implements SubscriptionRepository {
  SubscriptionModel _subscription = const SubscriptionModel();
  UsageCounterModel _usage = const UsageCounterModel();

  @override
  Future<SubscriptionModel> loadSubscription() async {
    return _subscription;
  }

  @override
  Future<UsageCounterModel> loadUsage() async {
    return _usage;
  }

  @override
  Future<void> restorePurchases() async {
    return;
  }

  @override
  Future<void> saveUsage(UsageCounterModel usage) async {
    _usage = usage;
  }

  @override
  Future<void> setPlan(SubscriptionPlan plan) async {
    _subscription = SubscriptionModel(
      plan: plan,
      status: plan == SubscriptionPlan.free
          ? SubscriptionStatus.expired
          : SubscriptionStatus.active,
    );
  }

  Future<void> setUsage(UsageCounterModel usage) async {
    _usage = usage;
  }
}
