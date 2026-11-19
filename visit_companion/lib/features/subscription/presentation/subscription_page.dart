import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/subscription_model.dart';
import 'subscription_view_model.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionViewModel>(
      builder: (context, viewModel, _) {
        final plan = viewModel.subscription.plan;

        return Scaffold(
          appBar: AppBar(title: const Text('Subscription')),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current plan',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.name.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Visit summaries: '
                              '${viewModel.usage.visitSummaries}/'
                              '${plan == SubscriptionPlan.free ? '2' : 'Unlimited'}',
                            ),
                            Text(
                              'Document explainers: '
                              '${viewModel.usage.documentExplainers}/'
                              '${plan == SubscriptionPlan.free ? '3' : 'Unlimited'}',
                            ),
                            Text(
                              'Profiles: '
                              '${viewModel.usage.profiles}/'
                              '${plan == SubscriptionPlan.family ? '5' : '1'}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _PlanCard(
                      title: 'Free',
                      price: 'No charge',
                      features: const [
                        '2 visit summaries/month',
                        '3 document explainers/month',
                        '1 profile',
                        'Emergency and existing data remain free',
                      ],
                      selected: plan == SubscriptionPlan.free,
                      onTap: () => viewModel.selectPlan(SubscriptionPlan.free),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      title: 'Plus',
                      price: 'Monthly or annual',
                      features: const [
                        'Unlimited visit summaries',
                        'Unlimited document explainers',
                        'Up to 5 language pairs',
                        'Advanced reminders',
                      ],
                      selected: plan == SubscriptionPlan.plus,
                      onTap: () => viewModel.selectPlan(SubscriptionPlan.plus),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      title: 'Family',
                      price: 'Monthly or annual',
                      features: const [
                        'Everything in Plus',
                        'Up to 5 profiles',
                        'Shared family records',
                        'Shared reminders',
                      ],
                      selected: plan == SubscriptionPlan.family,
                      onTap: () =>
                          viewModel.selectPlan(SubscriptionPlan.family),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: viewModel.restorePurchases,
                      child: const Text('Restore purchases'),
                    ),
                    const SizedBox(height: 12),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Emergency numbers, emergency card, nearby care, '
                          'existing records, data export and account deletion '
                          'are never blocked by a subscription.',
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String price;
  final List<String> features;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(price),
              ],
            ),
            const SizedBox(height: 12),
            for (final feature in features)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: selected
                  ? OutlinedButton(
                      onPressed: null,
                      child: const Text('Current plan'),
                    )
                  : ElevatedButton(
                      onPressed: onTap,
                      child: Text('Select $title'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
