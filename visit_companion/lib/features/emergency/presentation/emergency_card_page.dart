import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profiles/presentation/profile_view_model.dart';

class EmergencyCardPage extends StatelessWidget {
  const EmergencyCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final profile = viewModel.profiles.isEmpty
        ? null
        : viewModel.profiles.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Offline emergency card')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFFFEBEE),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'If someone is in immediate danger, call the local emergency number.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: profile == null
                  ? const Text('Create a profile to prepare an emergency card.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text('Country: ${profile.country}'),
                        if (profile.region.isNotEmpty)
                          Text('Region: ${profile.region}'),
                        Text('Languages: ${profile.languages.join(', ')}'),
                        const Divider(height: 24),
                        Text(
                          'Allergies:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          profile.allergies.isEmpty
                              ? 'None entered'
                              : profile.allergies.join(', '),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Conditions:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          profile.conditions.isEmpty
                              ? 'None entered'
                              : profile.conditions.join(', '),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Medicines:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          profile.medicines.isEmpty
                              ? 'None entered'
                              : profile.medicines.join(', '),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
