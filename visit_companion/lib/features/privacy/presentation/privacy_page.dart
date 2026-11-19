import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'privacy_view_model.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrivacyViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivacyViewModel>(
      builder: (context, viewModel, _) {
        final model = viewModel.model;
        return Scaffold(
          appBar: AppBar(title: const Text('Privacy')),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'You control your consents. Turning off AI '
                          'processing keeps emergency and finder features '
                          'available but disables AI flows.',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Required consents',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _ConsentTile(
                      title: 'Terms accepted',
                      value: model.termsAccepted,
                    ),
                    _ConsentTile(
                      title: 'Privacy notice accepted',
                      value: model.privacyAccepted,
                    ),
                    _ConsentTile(
                      title: 'Health-data storage',
                      value: model.healthDataAccepted,
                    ),
                    _ConsentTile(
                      title: 'AI processing',
                      value: model.aiProcessingAccepted,
                    ),
                    const Divider(height: 28),
                    const Text(
                      'Optional processing',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SwitchListTile(
                      title: const Text('Product analytics'),
                      subtitle: const Text(
                        'Share usage events without health content.',
                      ),
                      value: model.analyticsAccepted,
                      onChanged: viewModel.setAnalyticsAccepted,
                    ),
                    SwitchListTile(
                      title: const Text('AI quality review'),
                      subtitle: const Text(
                        'Allow short-term content retention for review.',
                      ),
                      value: model.qualityReviewAccepted,
                      onChanged: viewModel.setQualityReviewAccepted,
                    ),
                    const Divider(height: 28),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final data = await viewModel.exportData();
                        if (!context.mounted) return;
                        await showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Export preview'),
                            content: SelectableText(data),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Export my data'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _confirmDelete(context, viewModel),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete account'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    PrivacyViewModel viewModel,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This removes the local account state. In production, the '
          'backend will confirm the retention and deletion timeline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await viewModel.deleteAccount();
    }
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({required this.title, required this.value});

  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Icon(
        value ? Icons.check_circle : Icons.cancel,
        color: value ? Colors.green : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
