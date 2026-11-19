import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'visits_view_model.dart';

class VisitEditorPage extends StatelessWidget {
  const VisitEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitsViewModel>(
      builder: (context, viewModel, _) {
        final draft = viewModel.draft;

        return Scaffold(
          appBar: AppBar(title: const Text('Prepare a visit')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This app prepares a summary only. It does not diagnose '
                    'or replace a clinician.',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reason for visit',
                  hintText: 'Example: recurring headache',
                ),
                onChanged: viewModel.setReason,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'When did it start?',
                ),
                onChanged: viewModel.setOnset,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'How long has it lasted?',
                ),
                onChanged: viewModel.setDuration,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Severity',
                  hintText: 'Example: mild, moderate or severe',
                ),
                onChanged: viewModel.setSeverity,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location on the body',
                ),
                onChanged: viewModel.setLocationOnBody,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Triggers'),
                onChanged: viewModel.setTriggers,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Medicines already tried',
                ),
                onChanged: viewModel.setMedicinesTried,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Allergies'),
                onChanged: viewModel.setAllergies,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Questions for the clinician',
                ),
                maxLines: 3,
                onChanged: viewModel.setQuestions,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: draft.sourceLanguage,
                decoration: const InputDecoration(labelText: 'My language'),
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Urdu', child: Text('Urdu')),
                ],
                onChanged: null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final emergencyText =
                      '${draft.reason} ${draft.severity} '
                      '${draft.locationOnBody}';
                  if (viewModel.hasRedFlag(emergencyText)) {
                    if (context.mounted) context.push('/emergency');
                    return;
                  }

                  final saved = await viewModel.saveDraft();
                  if (!context.mounted) return;

                  if (saved) {
                    final visit = viewModel.visits.last;
                    context.push('/visit-summary', extra: visit);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Reason, onset and severity are required.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Create summary'),
              ),
            ],
          ),
        );
      },
    );
  }
}
