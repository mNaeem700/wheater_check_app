import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'visit_editor_page.dart';
import 'visits_view_model.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VisitsViewModel>().loadVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VisitsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Visits')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              viewModel.startVisit();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const VisitEditorPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Prepare visit'),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.visits.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Prepare a bilingual summary before a clinic, pharmacy or lab visit.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: viewModel.visits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final visit = viewModel.visits[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.description_outlined),
                        ),
                        title: Text(
                          visit.reason.isEmpty ? 'Visit summary' : visit.reason,
                        ),
                        subtitle: Text(
                          '${visit.sourceLanguage} / ${visit.targetLanguage}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push('/visit-summary', extra: visit),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
