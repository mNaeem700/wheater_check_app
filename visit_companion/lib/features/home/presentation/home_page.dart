import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Companion'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/emergency'),
            icon: const Icon(Icons.emergency, color: Color(0xFFC62828)),
            label: const Text(
              'Emergency',
              style: TextStyle(color: Color(0xFFC62828)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'What would you like to do?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickAction(
                icon: Icons.location_on_outlined,
                label: 'Find care',
                onTap: () => context.go('/finder'),
              ),
              _QuickAction(
                icon: Icons.edit_note_outlined,
                label: 'Prepare a visit',
                onTap: () => context.go('/visits'),
              ),
              _QuickAction(
                icon: Icons.document_scanner_outlined,
                label: 'Scan a document',
                onTap: () => context.go('/vault'),
              ),
              _QuickAction(
                icon: Icons.notifications_outlined,
                label: 'Reminders',
                onTap: () => context.push('/reminders'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next reminder',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('No reminders yet'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
