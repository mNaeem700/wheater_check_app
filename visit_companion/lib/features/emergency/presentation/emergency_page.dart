import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Emergency'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFFFEBEE),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'If someone is in immediate danger, call your local emergency number now.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.phone),
              title: Text('Local emergency numbers'),
              subtitle: Text(
                'Numbers are country-specific and must be reviewed before launch.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text('Offline emergency card'),
              subtitle: const Text(
                'Configure allergies, conditions and medicines.',
              ),
              onTap: () => context.push('/emergency-card'),
            ),
          ),
        ],
      ),
    );
  }
}
