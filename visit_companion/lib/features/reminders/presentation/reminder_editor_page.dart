import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/reminder_model.dart';
import 'reminder_view_model.dart';

class ReminderEditorPage extends StatelessWidget {
  const ReminderEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderViewModel>(
      builder: (context, viewModel, _) {
        final draft = viewModel.draft;

        return Scaffold(
          appBar: AppBar(title: const Text('Add reminder')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Reminders are not medical advice. User-confirmed schedules '
                    'can be recorded here and reviewed before use.',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Reminder title'),
                onChanged: viewModel.setTitle,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ReminderType>(
                initialValue: draft.type,
                decoration: const InputDecoration(labelText: 'Reminder type'),
                items: const [
                  DropdownMenuItem(
                    value: ReminderType.medication,
                    child: Text('Medication'),
                  ),
                  DropdownMenuItem(
                    value: ReminderType.followUp,
                    child: Text('Follow-up appointment'),
                  ),
                  DropdownMenuItem(
                    value: ReminderType.refill,
                    child: Text('Refill'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) viewModel.setType(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Profile name'),
                onChanged: viewModel.setProfileName,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 3,
                onChanged: viewModel.setNote,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: draft.scheduledAt,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null || !context.mounted) return;

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(draft.scheduledAt),
                  );
                  if (time == null) return;

                  viewModel.setScheduledAt(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                  );
                },
                icon: const Icon(Icons.schedule),
                label: Text('Schedule: ${draft.scheduledAt.toLocal()}'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final saved = await viewModel.saveDraft();
                  if (!context.mounted) return;

                  if (saved) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a title and future date/time.'),
                      ),
                    );
                  }
                },
                child: const Text('Save reminder'),
              ),
            ],
          ),
        );
      },
    );
  }
}
