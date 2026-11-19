import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/reminder_model.dart';
import 'reminder_editor_page.dart';
import 'reminder_view_model.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderViewModel>().loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Reminders')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              viewModel.startReminder();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReminderEditorPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_alert_outlined),
            label: const Text('Add reminder'),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.reminders.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No reminders yet. Medication and follow-up reminders '
                      'are guidance tools, not medical advice.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: viewModel.reminders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final reminder = viewModel.reminders[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    reminder.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                Text(
                                  reminder.status.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${reminder.type.name} • '
                              '${reminder.scheduledAt.toLocal()}',
                            ),
                            if (reminder.profileName.isNotEmpty)
                              Text('Profile: ${reminder.profileName}'),
                            if (reminder.note.isNotEmpty) Text(reminder.note),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed: () => viewModel.updateStatus(
                                    reminder,
                                    ReminderStatus.completed,
                                  ),
                                  child: const Text('Taken / done'),
                                ),
                                TextButton(
                                  onPressed: () => viewModel.snooze(reminder),
                                  child: const Text('Snooze 15 min'),
                                ),
                                TextButton(
                                  onPressed: () => viewModel.updateStatus(
                                    reminder,
                                    ReminderStatus.skipped,
                                  ),
                                  child: const Text('Skip'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
