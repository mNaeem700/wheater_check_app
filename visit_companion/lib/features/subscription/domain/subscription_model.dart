enum SubscriptionPlan { free, plus, family }

enum SubscriptionStatus {
  trial,
  active,
  gracePeriod,
  billingRetry,
  expired,
  refunded,
}

class SubscriptionModel {
  const SubscriptionModel({
    this.plan = SubscriptionPlan.free,
    this.status = SubscriptionStatus.expired,
  });

  final SubscriptionPlan plan;
  final SubscriptionStatus status;

  bool get isPaid =>
      plan != SubscriptionPlan.free &&
      (status == SubscriptionStatus.active ||
          status == SubscriptionStatus.trial ||
          status == SubscriptionStatus.gracePeriod);
}

class UsageCounterModel {
  const UsageCounterModel({
    this.visitSummaries = 0,
    this.documentExplainers = 0,
    this.profiles = 1,
  });

  final int visitSummaries;
  final int documentExplainers;
  final int profiles;

  UsageCounterModel copyWith({
    int? visitSummaries,
    int? documentExplainers,
    int? profiles,
  }) {
    return UsageCounterModel(
      visitSummaries: visitSummaries ?? this.visitSummaries,
      documentExplainers: documentExplainers ?? this.documentExplainers,
      profiles: profiles ?? this.profiles,
    );
  }
}
