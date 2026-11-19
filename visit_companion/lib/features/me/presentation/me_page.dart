import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profiles'),
              subtitle: const Text('Manage people and emergency information'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/profiles'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('Subscription'),
              subtitle: const Text('Plan and entitlements'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/subscription'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy'),
              subtitle: const Text('Consents, export and account deletion'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/privacy'),
            ),
          ),
        ],
      ),
    );
  }
}
