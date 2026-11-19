import 'package:flutter/foundation.dart';

import '../data/subscription_repository.dart';
import '../domain/subscription_model.dart';

class SubscriptionViewModel extends ChangeNotifier {
  SubscriptionViewModel(this._repository);

  final SubscriptionRepository _repository;

  SubscriptionModel _subscription = const SubscriptionModel();
  UsageCounterModel _usage = const UsageCounterModel();
  bool _isLoading = false;

  SubscriptionModel get subscription => _subscription;
  UsageCounterModel get usage => _usage;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _subscription = await _repository.loadSubscription();
    _usage = await _repository.loadUsage();

    _isLoading = false;
    notifyListeners();
  }

  bool canCreateVisitSummary() {
    return _subscription.isPaid || _usage.visitSummaries < 2;
  }

  bool canExplainDocument() {
    return _subscription.isPaid || _usage.documentExplainers < 3;
  }

  bool canAddProfile() {
    if (_subscription.plan == SubscriptionPlan.family) {
      return _usage.profiles < 5;
    }
    return _usage.profiles < 1;
  }

  Future<void> selectPlan(SubscriptionPlan plan) async {
    await _repository.setPlan(plan);
    await load();
  }

  Future<void> restorePurchases() async {
    await _repository.restorePurchases();
    await load();
  }

  Future<void> recordVisitSummary() async {
    _usage = _usage.copyWith(visitSummaries: _usage.visitSummaries + 1);
    await _repository.saveUsage(_usage);
    notifyListeners();
  }

  Future<void> recordDocumentExplanation() async {
    _usage = _usage.copyWith(documentExplainers: _usage.documentExplainers + 1);
    await _repository.saveUsage(_usage);
    notifyListeners();
  }

  Future<void> recordProfile() async {
    _usage = _usage.copyWith(profiles: _usage.profiles + 1);
    await _repository.saveUsage(_usage);
    notifyListeners();
  }
}
