import 'package:flutter/material.dart';

import '../domain/visit_model.dart';

class VisitSummaryPage extends StatelessWidget {
  const VisitSummaryPage({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Review every item before showing this page to a clinician.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SummarySection(
            title: 'Reason',
            source: visit.reason,
            target: visit.reason,
          ),
          _SummarySection(
            title: 'Onset',
            source: visit.onset,
            target: visit.onset,
          ),
          _SummarySection(
            title: 'Duration',
            source: visit.duration,
            target: visit.duration,
          ),
          _SummarySection(
            title: 'Severity',
            source: visit.severity,
            target: visit.severity,
          ),
          _SummarySection(
            title: 'Location',
            source: visit.locationOnBody,
            target: visit.locationOnBody,
          ),
          _SummarySection(
            title: 'Triggers',
            source: visit.triggers,
            target: visit.triggers,
          ),
          _SummarySection(
            title: 'Medicines tried',
            source: visit.medicinesTried,
            target: visit.medicinesTried,
          ),
          _SummarySection(
            title: 'Allergies',
            source: visit.allergies,
            target: visit.allergies,
          ),
          _SummarySection(
            title: 'Questions',
            source: visit.questions,
            target: visit.questions,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.fullscreen),
            label: const Text('Show to clinician'),
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.title,
    required this.source,
    required this.target,
  });

  final String title;
  final String source;
  final String target;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(source.isEmpty ? 'Not provided' : source)),
                const SizedBox(width: 12),
                Expanded(child: Text(target.isEmpty ? 'Not provided' : target)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
